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
    final response =
        await dio.get('/data/2.5/weather?lat=$latitude&lon=$longitude');
    if (response.statusCode == 200) {
      return CurrentWeatherResponseModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
