import 'package:flutter/material.dart';

class LogoRow extends StatelessWidget {
  const LogoRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: kToolbarHeight - 25,
          child: Image.asset(
            "assets/images/logo1.1.png",
            fit: BoxFit.contain,
          ),
        ),
        // const SizedBox(width: 10),
        // SizedBox(
        //   height: kToolbarHeight - 25,
        //   child: Image.asset(
        //     "assets/images/ADNOC logo1.1.png",
        //     fit: BoxFit.contain,
        //   ),
        // ),
      ],
    );
  }
}
