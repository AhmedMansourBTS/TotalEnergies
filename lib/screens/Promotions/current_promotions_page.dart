import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/promotions_model.dart';
import 'package:total_energies/screens/Promotions/redeem_promo_details_screen.dart';
import 'package:total_energies/screens/loading_screen.dart';
import 'package:total_energies/services/get_curr_promo_service.dart';
import 'package:total_energies/widgets/Promotions/curr_promo_card.dart';

class CurrentPromotionsPage extends StatefulWidget {
  const CurrentPromotionsPage({super.key});

  @override
  _CurrentPromotionsPageState createState() => _CurrentPromotionsPageState();
}

class _CurrentPromotionsPageState extends State<CurrentPromotionsPage> {
  late Future<List<PromotionsModel>> _futurePromotions;
  // final PromotionsService _promotionsService = PromotionsService();
  final GetCurrPromoService _promotionsService = GetCurrPromoService();

  // int serial = 0;

  // void loadUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     serial = prefs.getInt('serial') ?? 0;
  //     print(serial);
  //   });
  // }

  @override
  void initState() {
    super.initState();

    // loadUserData();
    _futurePromotions = _promotionsService.getCurrPromotions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<List<PromotionsModel>>(
        future: _futurePromotions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingScreen());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No promotions available.'));
          }

          List<PromotionsModel> promotions = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: promotions.length,
            itemBuilder: (context, index) {
              final promo = promotions[index];

              return Directionality.of(context) != TextDirection.rtl
                  ? CurrPromoCard(
                      imagepath: promo.imagePath,
                      title: promo.eventTopic,
                      description: promo.eventEnDescription,
                      startDate: promo.startDate,
                      endDate: promo.endDate,
                      total: promo.qrMaxUsage,
                      used: promo.remainingUsage,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RedeemPromoDetailsScreen(promotion: promo),
                          ),
                        );
                      },
                    )
                  : CurrPromoCard(
                      imagepath: promo.imagePath,
                      title: promo.eventTopic,
                      description: promo.eventDescription,
                      startDate: promo.startDate,
                      endDate: promo.endDate,
                      total: promo.qrMaxUsage,
                      used: promo.remainingUsage,
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
