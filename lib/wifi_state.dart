import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class WifiState {
  static const MethodChannel _channel = MethodChannel('wifi_state');

  static Future<bool> isOn() async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod('isOn');
    } else {
      return false;
    }
  }

  /// Before Android Q directly enables wifi
  /// After Android Q launches wifi settings
  static Future<bool> open() async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod('open');
    } else {
      return false;
    }
  }
}
