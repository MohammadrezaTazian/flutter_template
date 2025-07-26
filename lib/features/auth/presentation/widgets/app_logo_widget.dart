import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).primaryColor,
          child: SvgPicture.asset(
            'assets/images/icons/logo.svg', // آیکون لازم را قرار دهید
            color: Colors.white,
            height: 40,
            width: 40,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'پلتفرم آموزشی',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Educational Platform',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}