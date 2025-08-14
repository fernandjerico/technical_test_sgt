import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'package:technical_test_sgt/core/theme/app_colors.dart';

import '../../data/models/weather_forecast_hourly_response_model.dart';
import '../bloc/get_current_weather/get_current_weather_bloc.dart';
import '../bloc/get_weather_hourly/get_weather_hourly_bloc.dart';
import '../widgets/nav_home.dart';
import '../widgets/weather_initial.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? latitude;
  String? longitude;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showLocationDialog({required String title, required String content}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationDialog(
        title: 'Location Service Disabled',
        content: 'Please enable location services to use this feature.',
      );
      return;
    }

    // Cek permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permission ditolak
        _showLocationDialog(
          title: 'Permission Denied',
          content: 'Location permission is required to get weather data.',
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showLocationDialog(
        title: 'Permission Denied Permanently',
        content:
            'Location permission is permanently denied. Please enable it from app settings.',
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
    });
    if (latitude != null && longitude != null) {
      Future.microtask(
        () {
          if (mounted) {
            context.read<GetCurrentWeatherBloc>().add(
                  GetCurrentWeatherEvent.getCurrentWeather(
                    latitude: latitude!,
                    longitude: longitude!,
                  ),
                );
            context.read<GetWeatherHourlyBloc>().add(
                  GetWeatherHourlyEvent.getWeatherHourly(
                    latitude: latitude!,
                    longitude: longitude!,
                  ),
                );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/bg-home.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 80,
            left: 20,
            right: 20,
            child: BlocBuilder<GetCurrentWeatherBloc, GetCurrentWeatherState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => WeatherInitial(size: size),
                  loaded: (weather) => Column(
                    children: [
                      Text(
                        weather.name ?? '-',
                        style: const TextStyle(
                            fontSize: 34,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '${weather.main?.temp?.round() ?? '-'}°C',
                        style: const TextStyle(
                            fontSize: 98,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      ),
                      Column(
                        children: [
                          Text(
                            weather.weather != null &&
                                    weather.weather!.isNotEmpty
                                ? weather.weather![0].main ?? '-'
                                : '-',
                            style: TextStyle(
                                fontSize: 20,
                                color: AppColors.labelDarkSecondary,
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'H:${weather.main?.humidity?.round() ?? '-'}°',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'FL:${weather.main?.feelsLike?.round() ?? '-'}°C',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Image.asset(
                        'assets/images/house.png',
                        width: size.width * 0.9,
                        height: size.height * 0.45,
                      ),
                    ],
                  ),
                  error: (message) => Center(
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(52.0),
                  topRight: Radius.circular(52.0),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 8.0),
                  child: Container(
                    width: double.infinity,
                    height: size.height * 0.34,
                    decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(color: Colors.white, width: 1),
                            right: BorderSide(color: Colors.white, width: 1)),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(52.0),
                            topRight: Radius.circular(52.0)),
                        gradient: LinearGradient(
                            colors: [
                              Colors.deepPurple.withValues(alpha: 0.8),
                              Colors.deepPurple.withValues(alpha: 0.2),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Column(
                      children: [
                        Container(
                          height: 5,
                          width: 48,
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.5),
                              color: Colors.black.withValues(alpha: 0.4)),
                        ),
                        TabBar(
                          controller: _tabController,
                          indicatorColor: Colors.white,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white70,
                          tabs: const [
                            Tab(text: 'Hourly Forecast'),
                            Tab(text: 'Weekly Forecast'),
                          ],
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 120,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // Hourly Forecast Tab
                              hourlyForecastTab(),
                              // Weekly Forecast Tab
                              weeklyForecastTab(),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        NavHome(),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  BlocBuilder<GetWeatherHourlyBloc, GetWeatherHourlyState> weeklyForecastTab() {
    return BlocBuilder<GetWeatherHourlyBloc, GetWeatherHourlyState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => Center(child: CircularProgressIndicator()),
          error: (message) => Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          loaded: (weather) {
            // Ambil hanya 1 data per hari (jam 12 siang)
            final List<ListElement> daily = [];
            final Set<String> addedDates = {};
            for (final item in weather.list ?? []) {
              if (item.dtTxt != null && item.dtTxt!.hour == 12) {
                final dateStr =
                    '${item.dtTxt!.year}-${item.dtTxt!.month.toString().padLeft(2, '0')}-${item.dtTxt!.day.toString().padLeft(2, '0')}';
                if (!addedDates.contains(dateStr)) {
                  daily.add(item);
                  addedDates.add(dateStr);
                }
              }
            }
            if (daily.isEmpty) {
              return Center(
                  child: Text('No daily data available',
                      style: TextStyle(color: Colors.white)));
            }
            return ListView.builder(
              itemCount: daily.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final item = daily[index];
                String day = '-';
                if (item.dtTxt != null) {
                  final dt = item.dtTxt!;
                  day = [
                    'MON',
                    'TUE',
                    'WED',
                    'THU',
                    'FRI',
                    'SAT',
                    'SUN'
                  ][dt.weekday - 1];
                }
                String weatherMain = '-';
                if (item.weather != null &&
                    item.weather!.isNotEmpty &&
                    item.weather![0].main != null) {
                  weatherMain = item.weather![0].main!.name;
                }
                final temp = item.main?.temp?.round();
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  margin: EdgeInsets.only(right: 6, left: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        day,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteColor),
                      ),
                      Text(
                        weatherMain,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteColor),
                      ),
                      Text(
                        '${temp ?? '-'}°C',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.whiteColor),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  BlocBuilder<GetWeatherHourlyBloc, GetWeatherHourlyState> hourlyForecastTab() {
    return BlocBuilder<GetWeatherHourlyBloc, GetWeatherHourlyState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => Center(child: CircularProgressIndicator()),
          error: (message) => Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          loaded: (weather) {
            return ListView.builder(
              itemCount: weather.list?.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final item = weather.list![index];
                String time = '-';
                if (item.dtTxt != null) {
                  final hour = item.dtTxt!.hour.toString().padLeft(2, '0');
                  final minute = item.dtTxt!.minute.toString().padLeft(2, '0');
                  time = '$hour:$minute';
                }
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  margin: EdgeInsets.only(right: 6, left: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteColor),
                      ),
                      Text(item.weather?[0].main?.name ?? '-',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.whiteColor)),
                      Text(
                        '${item.main?.temp?.round() ?? '-'}°C',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.whiteColor),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
