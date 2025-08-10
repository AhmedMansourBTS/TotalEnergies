import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';

class AdsSection extends StatelessWidget {
  final double adsHeight;

  const AdsSection({
    super.key,
    this.adsHeight = 150,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> ads = [
      'assets/images/logo.png',
      'assets/images/logo.png',
      'assets/images/logo.png',
      'assets/images/logo.png',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: adsHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: ads.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  ads[index],
                  width: 250,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}