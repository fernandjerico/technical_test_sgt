import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:technical_test_sgt/modules/auth/presentation/pages/splash_page.dart';
import 'package:technical_test_sgt/modules/home/presentation/bloc/get_current_weather/get_current_weather_bloc.dart';

import 'modules/home/presentation/bloc/get_weather_hourly/get_weather_hourly_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetCurrentWeatherBloc()),
        BlocProvider(create: (_) => GetWeatherHourlyBloc()),
      ],
      child: MaterialApp(
        title: 'Weather Forecast App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashPage(),
      ),
    );
  }
}
