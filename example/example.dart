import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:wifi_state/wifi_state.dart';

class Example extends StatefulWidget {
  const Example({super.key});
  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> with WidgetsBindingObserver {
  bool? isWifiOn;

  fetchWifiState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      isWifiOn = await WifiState.isOn();
      if (mounted) {
        setState(() {});
      }
    });
  }

  Widget wifiToggleButton() {
    return Switch(
      value: isWifiOn!,
      activeTrackColor: Colors.green,
      thumbIcon: WidgetStateProperty.resolveWith(
        (a) {
          return isWifiOn! ? Icon(Icons.wifi) : Icon(Icons.wifi_off);
        },
      ),
      onChanged: (val) async {
        if (!isWifiOn!) {
          /// Before Android Q directly enables wifi
          /// After Android Q launches wifi settings
          await WifiState.open();
        } else {
          snack(
            context,
            'You can close in the settings.',
          );
        }
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchWifiState();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fetchWifiState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wifi State'),
        actions: [
          isWifiOn == null ? CupertinoActivityIndicator() : wifiToggleButton(),
        ],
      ),
    );
  }
}

void snack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
