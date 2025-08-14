part of 'get_weather_hourly_bloc.dart';

@freezed
class GetWeatherHourlyEvent with _$GetWeatherHourlyEvent {
  const factory GetWeatherHourlyEvent.started() = _Started;
  const factory GetWeatherHourlyEvent.getWeatherHourly({
    required String latitude,
    required String longitude,
  }) = _GetWeatherHourly;
}
