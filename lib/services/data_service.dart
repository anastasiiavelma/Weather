import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:list_app/models/weather_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:list_app/utils/constants.dart';

class DataService {
  Future<WeatherResponse> getWeather(String city) async {
    try {
      final queryParameters = {
        'q': city,
        'appid': '7ff9493d3a66fda40633f18ee31d3db7',
        'units': 'metric'
      };

      final uri = Uri.https(
          'api.openweathermap.org', '/data/2.5/weather', queryParameters);

      final response = await http.get(uri);

      if (kDebugMode) {
        print(response.body);
      }

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return WeatherResponse.fromJson(json);
      } else {
        if (kDebugMode) {
          Fluttertoast.showToast(
            msg: 'HTTP Error: ${response.statusCode}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: kSecondaryAccentColor,
            textColor: kSecondaryBackgroundColor,
            fontSize: 16.0,
          );
        }
        throw Exception('Failed to get weather data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception: $e');
      }
      throw Exception('Failed to get weather data');
    }
  }
}
