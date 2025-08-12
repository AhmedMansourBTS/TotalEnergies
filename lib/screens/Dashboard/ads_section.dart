import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';

class AdsSection extends StatelessWidget {
  final double adsHeight;

  const AdsSection({
    super.key,
    this.adsHeight = 180,
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
            double screenWidth = MediaQuery.of(context).size.width;
            double itemWidth = screenWidth - 32; // 16 padding on each side

            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: itemWidth, // full width inside the padding
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  ads[index],
                  width: itemWidth,
                  height: adsHeight,
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
