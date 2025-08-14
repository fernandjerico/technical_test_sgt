part of 'get_current_weather_bloc.dart';

@freezed
class GetCurrentWeatherState with _$GetCurrentWeatherState {
  const factory GetCurrentWeatherState.initial() = _Initial;
  const factory GetCurrentWeatherState.loading() = _Loading;
  const factory GetCurrentWeatherState.loaded(
      CurrentWeatherResponseModel weather) = _Loaded;
  const factory GetCurrentWeatherState.error(String message) = _Error;
}
