import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:technical_test_sgt/modules/home/data/models/current_weather_response_model.dart';
import 'package:technical_test_sgt/modules/home/data/models/weather_forecast_hourly_response_model.dart';
import 'package:technical_test_sgt/modules/home/domain/repository/weather_repository.dart';

import '../datasources/weather_datasource.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherDatasource _datasource = WeatherDatasourceImpl();

  @override
  Future<Either<String, CurrentWeatherResponseModel>> getWeatherData(
      String latitude, String longitude) async {
    try {
      final response = await _datasource.getWeatherData(latitude, longitude);
      return Right(response);
    } on DioException catch (e) {
      debugPrint("DioError: ${e.message}");
      return Left(e.message ?? "An error occurred while fetching weather data");
    } catch (e) {
      return Left("An unexpected error occurred: $e");
    }
  }

  @override
  Future<Either<String, WeatherForecastHourlyResponseModel>>
      getWeatherForecastHourly(String latitude, String longitude) async {
    try {
      final response =
          await _datasource.getWeatherForecastHourly(latitude, longitude);
      return Right(response);
    } on DioException catch (e) {
      debugPrint("DioError: ${e.message}");
      return Left(
          e.message ?? "An error occurred while fetching weather forecast");
    } catch (e) {
      return Left("An unexpected error occurred: $e");
    }
  }
}
