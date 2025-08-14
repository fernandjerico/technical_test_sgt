part of 'get_weather_hourly_bloc.dart';

@freezed
class GetWeatherHourlyState with _$GetWeatherHourlyState {
  const factory GetWeatherHourlyState.initial() = _Initial;
  const factory GetWeatherHourlyState.loading() = _Loading;
  const factory GetWeatherHourlyState.loaded(
      WeatherForecastHourlyResponseModel weather) = _Loaded;
  const factory GetWeatherHourlyState.error(String message) = _Error;
}
