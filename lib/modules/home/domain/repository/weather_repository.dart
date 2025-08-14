import 'package:dartz/dartz.dart';

import '../../data/models/current_weather_response_model.dart';

abstract class WeatherRepository {
  Future<Either<String, CurrentWeatherResponseModel>> getWeatherData(
      String latitude, String longitude);
}
