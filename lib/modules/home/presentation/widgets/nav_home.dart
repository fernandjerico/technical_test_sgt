import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:technical_test_sgt/core/theme/app_colors.dart';
import 'package:technical_test_sgt/modules/auth/presentation/pages/login_page.dart';
import 'package:technical_test_sgt/modules/home/presentation/pages/weather_page.dart';

class NavHome extends StatelessWidget {
  const NavHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
              color: AppColors.whiteColor, shape: BoxShape.circle),
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
            icon: SvgPicture.asset('assets/icons/icon-list.svg')),
      ],
    );
  }
}
