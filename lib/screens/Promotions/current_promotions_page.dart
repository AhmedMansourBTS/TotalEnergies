// import 'package:flutter/material.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/curr_promo_model.dart';
// import 'package:total_energies/screens/Promotions/redeem_promo_details_screen.dart';
// import 'package:total_energies/screens/loading_screen.dart';
// import 'package:total_energies/services/get_curr_promo_service.dart';
// import 'package:total_energies/widgets/Promotions/curr_promo_card.dart';

// class CurrentPromotionsPage extends StatefulWidget {
//   const CurrentPromotionsPage({super.key});

//   @override
//   _CurrentPromotionsPageState createState() => _CurrentPromotionsPageState();
// }

// class _CurrentPromotionsPageState extends State<CurrentPromotionsPage> {
//   late Future<List<CurrPromoModel>> _futurePromotions;
//   final GetCurrPromoService _promotionsService = GetCurrPromoService();

//   @override
//   void initState() {
//     super.initState();
//     _futurePromotions = _promotionsService.getCurrPromotions();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: FutureBuilder<List<CurrPromoModel>>(
//         future: _futurePromotions,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: LoadingScreen());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(
//                 child: Text('You dont\'t have applied promotions'));
//           }

//           List<CurrPromoModel> promotions = snapshot.data!;

//           return ListView.builder(
//             padding: const EdgeInsets.all(10),
//             itemCount: promotions.length,
//             itemBuilder: (context, index) {
//               final promo = promotions[index];

//               return Directionality.of(context) != TextDirection.rtl
//                   ? CurrPromoCard(
//                       imagepath: promo.imagePath,
//                       title: promo.eventTopic,
//                       description: promo.eventEnDescription,
//                       startDate: promo.startDate,
//                       endDate: promo.endDate,
//                       total: promo.qrMaxUsage,
//                       remained: promo.remainingUsage,
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 RedeemPromoDetailsScreen(promotion: promo),
//                           ),
//                         );
//                       },
//                     )
//                   : CurrPromoCard(
//                       imagepath: promo.imagePath,
//                       title: promo.eventTopic,
//                       description: promo.eventDescription,
//                       startDate: promo.startDate,
//                       endDate: promo.endDate,
//                       total: promo.qrMaxUsage,
//                       remained: promo.remainingUsage,
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 RedeemPromoDetailsScreen(promotion: promo),
//                           ),
//                         );
//                       },
//                     );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/curr_promo_model.dart';
import 'package:total_energies/screens/Promotions/redeem_promo_details_screen.dart';
import 'package:total_energies/services/get_curr_promo_service.dart';
import 'package:total_energies/widgets/Promotions/curr_promo_card.dart';

class CurrentPromotionsPage extends StatefulWidget {
  const CurrentPromotionsPage({Key? key}) : super(key: key);

  @override
  State<CurrentPromotionsPage> createState() => _CurrentPromotionsPageState();
}

class _CurrentPromotionsPageState extends State<CurrentPromotionsPage> {
  late Future<List<CurrPromoModel>> _futurePromos;

  @override
  void initState() {
    super.initState();
    _futurePromos = GetCurrPromoService().getCurrPromotions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<List<CurrPromoModel>>(
        future: _futurePromos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final promos = snapshot.data;

          if (promos == null || promos.isEmpty) {
            return const Center(child: Text("No promotions found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            itemCount: promos.length,
            itemBuilder: (context, index) {
              final promo = promos[index];
              final imageUrl = promo.imagePath != null
                  ? promo.imagePath!.replaceAll('\\', '/')
                  : '';

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
