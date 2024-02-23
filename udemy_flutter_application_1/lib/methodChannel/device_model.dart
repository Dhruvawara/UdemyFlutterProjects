import 'package:flutter/services.dart';

class DeviceModel {
  static const platform = MethodChannel(
      'com.example.platform_channel_in_flutter/Udemy Flutter Application 1');
  static Future<String> getDeviceModel() async {
    try {
      final result = await platform.invokeMethod('getDeviceModel');
      return result.toString();
    } catch (e) {
      return 'Err';
    }
  }
}
