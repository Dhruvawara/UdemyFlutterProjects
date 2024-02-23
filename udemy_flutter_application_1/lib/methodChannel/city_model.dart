import 'dart:developer';

import 'package:flutter/services.dart';

class CityModel {
  static const platform = MethodChannel(
      'com.example.platform_channel_in_flutter/Udemy Flutter Application 1');

  static Future<List<String>> getCityModel() async {
    try {
      final result = await platform.invokeListMethod('getCityData');
      return result?.map((element) => element.toString()).toList() ?? ['Empty'];
    } catch (e) {
      print(e);
      return ['Err'];
    }
  }

  static Future<String> getStateFromCity(String cityName) async {
    try {
      final result = await platform.invokeMethod('getStateFromCity', cityName);
      log(result.toString());
      return result;
    } catch (e) {
      print(e);
      return 'Err';
    }
  }
}
