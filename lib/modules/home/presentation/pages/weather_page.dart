import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:technical_test_sgt/core/theme/app_colors.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E335A), Color(0xFF1C1B33)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 36),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.whiteColor,
                      )),
                  Text(
                    'Weather',
                    style: TextStyle(fontSize: 28, color: AppColors.whiteColor),
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset('assets/icons/icon-list-rounded.svg'))
            ],
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: Offset(2, 2),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.white54),
                  hintText: 'Search for a city or airport',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width,
                height: 184,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        'assets/images/bg-card.png',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 32, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '19°',
                                style: TextStyle(
                                    fontSize: 64,
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w400),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'H:24° L:15°',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.labelDarkSecondary,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    'Montreal, Canada',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Image.asset(
                                'assets/images/moon-cloud-mid-rain.png',
                                height: 140,
                              ),
                              Text(
                                'Mid Rain',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 8),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )),
        ],
      ),
    ));
  }
}
