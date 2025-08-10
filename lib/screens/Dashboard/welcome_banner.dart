import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';

class WelcomeBanner extends StatelessWidget {
  final String name;
  final double height;

  const WelcomeBanner({
    super.key,
    required this.name,
    this.height = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: height,
      child: Center(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          alignment: Alignment.center,
          child: Text(
            'Welcome $name',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}