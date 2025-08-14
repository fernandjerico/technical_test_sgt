import 'package:technical_test_sgt/core/service/dio_service.dart';
import 'package:technical_test_sgt/modules/home/data/models/current_weather_response_model.dart';
import 'package:technical_test_sgt/modules/home/data/models/weather_forecast_hourly_response_model.dart';

abstract class WeatherDatasource {
  Future<CurrentWeatherResponseModel> getWeatherData(
      String latitude, String longitude);
  Future<WeatherForecastHourlyResponseModel> getWeatherForecastHourly(
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
      return CurrentWeatherResponseModel.fromMap(response.data);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Future<WeatherForecastHourlyResponseModel> getWeatherForecastHourly(
      String latitude, String longitude) async {
    final response = await dio.get(
        '/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&cnt=40');
    if (response.statusCode == 200) {
      return WeatherForecastHourlyResponseModel.fromMap(response.data);
    } else {
      throw Exception('Failed to load weather forecast');
    }
  }
}
