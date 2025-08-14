import 'package:dartz/dartz.dart';
import 'package:technical_test_sgt/modules/home/data/models/current_weather_response_model.dart';

import '../../data/repository/weather_repository_impl.dart';
import '../repository/weather_repository.dart';

class GetWeatherUsecase {
  GetWeatherUsecase();

  final WeatherRepository repository = WeatherRepositoryImpl();

  Future<Either<String, CurrentWeatherResponseModel>> call(
          {required String latitude, required String longitude}) async =>
      await repository.getWeatherData(latitude, longitude);
}
