package com.example.wifi_state

import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
//
import android.net.wifi.WifiManager
import android.content.Intent
import android.os.Build
import android.provider.Settings

class WifiState : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        this.applicationContext = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "wifi_state")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        var isWiFiEnabled = wifiManager.isWifiEnabled

        if (call.method == "isOn") {
            result.success(isWiFiEnabled)
        } else if(call.method == "open"){
             if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
                // Before Android Q: Programmatically toggle Wi-Fi
                wifiManager.isWifiEnabled = true
                result.success(true)
            } else {
                // After Android Q: Redirect to Wi-Fi settings
                var intent = Intent(Settings.ACTION_WIFI_SETTINGS)
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK) 
                applicationContext.startActivity(intent)
                result.success(true)
            }
        }
        else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
