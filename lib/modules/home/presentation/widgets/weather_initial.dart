import 'package:flutter/material.dart';
import 'package:technical_test_sgt/core/theme/app_colors.dart';

class WeatherInitial extends StatelessWidget {
  const WeatherInitial({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          '-',
          style: TextStyle(
              fontSize: 34, color: Colors.white, fontWeight: FontWeight.w400),
        ),
        const Text(
          '-°',
          style: TextStyle(
              fontSize: 98, color: Colors.white, fontWeight: FontWeight.w300),
        ),
        Column(
          children: [
            Text(
              '-',
              style: TextStyle(
                  fontSize: 20,
                  color: AppColors.labelDarkSecondary,
                  fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'H:-°',
                  style: TextStyle(
                      fontSize: 20,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 12),
                Text(
                  'L:-°',
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
    );
  }
}
