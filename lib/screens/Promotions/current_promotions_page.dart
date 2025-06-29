import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/curr_promo_model.dart';
import 'package:total_energies/screens/Promotions/redeem_promo_details_screen.dart';
import 'package:total_energies/screens/loading_screen.dart';
import 'package:total_energies/services/get_curr_promo_service.dart';
import 'package:total_energies/widgets/Promotions/curr_promo_card.dart';

class CurrentPromotionsPage extends StatefulWidget {
  const CurrentPromotionsPage({super.key});

  @override
  State<CurrentPromotionsPage> createState() => _CurrentPromotionsPageState();
}

class _CurrentPromotionsPageState extends State<CurrentPromotionsPage> {
  late Future<List<CurrPromoModel>> _futurePromos;

  @override
  void initState() {
    super.initState();
    _futurePromos = GetCurrPromoService().getCurrPromotions(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<List<CurrPromoModel>>(
        future: _futurePromos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingScreen());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _futurePromos = GetCurrPromoService().getCurrPromotions(context);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    child: const Text(
                      "Retry",
                      style: TextStyle(color: btntxtColors, fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }

          final promos = snapshot.data;

          if (promos == null || promos.isEmpty) {
            return const Center(
              child: Text(
                "No promotions found.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            itemCount: promos.length,
            itemBuilder: (context, index) {
              final promo = promos[index];
              final imageUrl = promo.imagePath?.replaceAll('\\', '/') ?? '';

              return CurrPromoCard(
                serial: promo.serial,
                imagepath: imageUrl,
                title: Directionality.of(context) == TextDirection.rtl
                    ? promo.eventDescription
                    : promo.eventTopic,
                description: Directionality.of(context) == TextDirection.rtl
                    ? promo.eventArDescription
                    : promo.eventEnDescription,
                startDate: promo.startDate,
                endDate: promo.endDate,
                total: promo.qrMaxUsage,
                remained: promo.remainingUsage,
                promodet: promo.promotionDetails.isNotEmpty
                    ? promo.promotionDetails[0].promotionCode
                    : "N/A",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RedeemPromoDetailsScreen(promotion: promo),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}