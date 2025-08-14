import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:technical_test_sgt/modules/home/domain/usecases/get_weather_usecase.dart';

import '../../../data/models/current_weather_response_model.dart';

part 'get_current_weather_event.dart';
part 'get_current_weather_state.dart';
part 'get_current_weather_bloc.freezed.dart';

class GetCurrentWeatherBloc
    extends Bloc<GetCurrentWeatherEvent, GetCurrentWeatherState> {
  final GetWeatherUsecase getWeatherUsecase = GetWeatherUsecase();
  GetCurrentWeatherBloc() : super(_Initial()) {
    on<_GetCurrentWeather>((event, emit) async {
      emit(_Loading());
      final result = await getWeatherUsecase.call(
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
