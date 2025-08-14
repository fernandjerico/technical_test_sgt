import 'dart:developer';

import 'package:technical_test_sgt/core/service/dio_service.dart';
import 'package:technical_test_sgt/modules/home/data/models/current_weather_response_model.dart';

abstract class WeatherDatasource {
  Future<CurrentWeatherResponseModel> getWeatherData(
      String latitude, String longitude);
}

class WeatherDatasourceImpl implements WeatherDatasource {
  final DioService dio = DioService();

  @override
  Future<CurrentWeatherResponseModel> getWeatherData(
      String latitude, String longitude) async {
    final response = await dio
        .get('/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric');
    if (response.statusCode == 200) {
      log('Weather data fetched successfully: ${response.data}');
      return CurrentWeatherResponseModel.fromMap(response.data);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
