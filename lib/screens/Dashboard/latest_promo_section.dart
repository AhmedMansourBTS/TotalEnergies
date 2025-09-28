import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/core/controllers/bottom_bar_controller.dart';
import 'package:total_energies/models/curr_promo_model.dart';
import 'package:total_energies/models/exp_promo_model.dart';
import 'package:total_energies/models/promotions_model.dart';
import 'package:total_energies/screens/Promotions/promotions_screen.dart';
import 'package:get/get.dart';

class LatestPromos extends StatelessWidget {
  final List<PromotionsModel> allPromos;
  final List<CurrPromoModel> redeemedPromos;
  final List<ExpiredPromoModel> expiredPromos;

  const LatestPromos({
    super.key,
    required this.allPromos,
    required this.redeemedPromos,
    required this.expiredPromos,
  });

  @override
  Widget build(BuildContext context) {
    final int total = allPromos.length;
    final int expired = expiredPromos.length;
    final int redeemed = redeemedPromos.length;
    final int activePromotions = allPromos
        .where((promo) =>
            !redeemedPromos.any((rp) => rp.serial == promo.serial) &&
            !expiredPromos.any((ep) => ep.serial == promo.serial))
        .length;

    final List<Map<String, dynamic>> promoStats = [
      // {'title': 'Active', 'value': '$total', 'icon': Icons.local_offer},
      {
        'title': 'Not Applied',
        'value': '$activePromotions',
        'icon': Icons.check_circle
      },
      {'title': 'Used', 'value': '$expired', 'icon': Icons.cancel},
      {'title': 'Ongoing', 'value': '$redeemed', 'icon': Icons.redeem},
    ];

    // Get screen dimensions for responsive sizing
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double padding = (screenWidth * 0.03)
        .clamp(8.0, 12.0); // 3% of screen width, min 8px, max 12px
    final double iconSize = (screenWidth * 0.06)
        .clamp(18.0, 24.0); // 6% of screen width, min 18px, max 24px
    final double fontSizeTitle = (screenWidth * 0.045)
        .clamp(12.0, 14.0); // 3.5% of screen width, min 12px, max 14px
    final double fontSizeValue = (screenWidth * 0.05)
        .clamp(14.0, 18.0); // 5% of screen width, min 14px, max 18px
    final double gridItemHeight = (screenHeight * 0.15)
        .clamp(100.0, 120.0); // 15% of screen height, min 100px, max 120px

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Promotions Analysis',
            style: TextStyle(
              fontSize: (screenWidth * 0.05).clamp(
                  16.0, 20.0), // Responsive title font size, min 16px, max 20px
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: padding),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxCrossAxisExtent = (screenWidth < 360)
                  ? 140.0
                  : 150.0; // Smaller extent for very small screens
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent:
                      maxCrossAxisExtent, // Max 140-150px per item
                  crossAxisSpacing: padding,
                  mainAxisSpacing: padding,
                  mainAxisExtent:
                      gridItemHeight, // Dynamic height based on screen
                ),
                itemCount: promoStats.length,
                itemBuilder: (context, index) {
                  final promo = promoStats[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      Get.find<BottomBarController>().changeIndex(1);
                      // 👆 switch to Promotions tab
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(padding * 0.8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Icon(
                              promo['icon'],
                              color: primaryColor,
                              size: iconSize,
                            ),
                          ),
                          SizedBox(height: padding * 0.5),
                          Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                promo['value'],
                                style: TextStyle(
                                  fontSize: fontSizeValue,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          SizedBox(height: padding * 0.3),
                          Center(
                            child: Text(
                              promo['title'],
                              style: TextStyle(
                                fontSize: fontSizeTitle,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
