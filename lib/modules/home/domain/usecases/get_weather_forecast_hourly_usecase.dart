import 'package:dartz/dartz.dart';
import 'package:technical_test_sgt/modules/home/data/models/weather_forecast_hourly_response_model.dart';

import '../../data/repository/weather_repository_impl.dart';
import '../repository/weather_repository.dart';

class GetWeatherForecastHourlyUsecase {
  GetWeatherForecastHourlyUsecase();

  final WeatherRepository repository = WeatherRepositoryImpl();

  Future<Either<String, WeatherForecastHourlyResponseModel>> call(
          {required String latitude, required String longitude}) async =>
      await repository.getWeatherForecastHourly(latitude, longitude);
}
