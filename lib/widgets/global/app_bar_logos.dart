import 'package:flutter/material.dart';
import 'package:total_energies/screens/home_screen.dart';

class LogoRow extends StatelessWidget {
  const LogoRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
            );
          },
          child: SizedBox(
            height: kToolbarHeight, // Full AppBar height
            child: Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
