import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:technical_test_sgt/core/theme/app_colors.dart';
import 'dart:ui';
import 'package:technical_test_sgt/modules/auth/presentation/pages/login_page.dart';
import 'package:technical_test_sgt/modules/home/presentation/pages/weather_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/get_current_weather/get_current_weather_bloc.dart';
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

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Service tidak aktif, bisa tampilkan dialog ke user
      return;
    }

    // Cek permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permission ditolak
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
    });
    if (latitude != null && longitude != null) {
      if (mounted) {
        context.read<GetCurrentWeatherBloc>().add(
              GetCurrentWeatherEvent.getCurrentWeather(
                latitude: latitude!,
                longitude: longitude!,
              ),
            );
      }
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
                              ListView.builder(
                                itemCount: 24,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 8),
                                    margin: EdgeInsets.only(right: 6, left: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color:
                                            Colors.white.withValues(alpha: 0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '12 AM',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.whiteColor),
                                        ),
                                        Image.asset(
                                            'assets/icons/cloud-mid-rain.png'),
                                        Text(
                                          '19°',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.whiteColor),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              // Weekly Forecast Tab
                              ListView.builder(
                                itemCount: 7,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 8),
                                    margin: EdgeInsets.only(right: 6, left: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color:
                                            Colors.white.withValues(alpha: 0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'TUE',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.whiteColor),
                                        ),
                                        Image.asset(
                                            'assets/icons/cloud-mid-rain.png'),
                                        Text(
                                          '20°',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.whiteColor),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ));
                                },
                                icon: Icon(
                                  Icons.logout,
                                  color: AppColors.whiteColor,
                                )),
                            Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  shape: BoxShape.circle),
                              child: Icon(
                                Icons.add,
                                color: Colors.deepPurple,
                                size: 28,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WeatherPage(),
                                      ));
                                },
                                icon: SvgPicture.asset(
                                    'assets/icons/icon-list.svg')),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
