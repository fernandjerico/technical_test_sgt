part of 'get_current_weather_bloc.dart';

@freezed
class GetCurrentWeatherEvent with _$GetCurrentWeatherEvent {
  const factory GetCurrentWeatherEvent.started() = _Started;
  const factory GetCurrentWeatherEvent.getCurrentWeather({
    required String latitude,
    required String longitude,
  }) = _GetCurrentWeather;
}
