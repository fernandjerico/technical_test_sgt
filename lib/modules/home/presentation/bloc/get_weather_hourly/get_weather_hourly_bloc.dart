import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:technical_test_sgt/modules/home/domain/usecases/get_weather_forecast_hourly_usecase.dart';

import '../../../data/models/weather_forecast_hourly_response_model.dart';

part 'get_weather_hourly_event.dart';
part 'get_weather_hourly_state.dart';
part 'get_weather_hourly_bloc.freezed.dart';

class GetWeatherHourlyBloc
    extends Bloc<GetWeatherHourlyEvent, GetWeatherHourlyState> {
  final GetWeatherForecastHourlyUsecase getWeatherForecastHourlyUsecase =
      GetWeatherForecastHourlyUsecase();
  GetWeatherHourlyBloc() : super(_Initial()) {
    on<_GetWeatherHourly>((event, emit) async {
      emit(_Loading());
      final result = await getWeatherForecastHourlyUsecase.call(
        latitude: event.latitude,
        longitude: event.longitude,
      );
      result.fold(
        (error) => emit(_Error(error)),
        (weather) => emit(_Loaded(weather)),
      );
    });
  }
}
