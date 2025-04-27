// import 'package:flutter/material.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/promotions_model.dart';
// import 'package:total_energies/screens/Promotions/apply_to_promo_det.dart';
// import 'package:total_energies/screens/loading_screen.dart';
// import 'package:total_energies/services/promotions_service.dart';
// import 'package:total_energies/widgets/Promotions/all_promo_card.dart';

// class AllPromotionsPage extends StatefulWidget {
//   const AllPromotionsPage({super.key});

//   @override
//   _AllPromotionsPageState createState() => _AllPromotionsPageState();
// }

// class _AllPromotionsPageState extends State<AllPromotionsPage> {
//   late Future<List<PromotionsModel>> _futurePromotions;
//   final PromotionsService _promotionsService = PromotionsService();

//   @override
//   void initState() {
//     super.initState();
//     _futurePromotions = _promotionsService.getPromotions();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: FutureBuilder<List<PromotionsModel>>(
//         future: _futurePromotions,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: LoadingScreen());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No promotions available.'));
//           }

//           List<PromotionsModel> promotions = snapshot.data!;

//           return ListView.builder(
//             padding: const EdgeInsets.all(10),
//             itemCount: promotions.length,
//             itemBuilder: (context, index) {
//               final promo = promotions[index];
//               print(promo);
//               return Directionality.of(context) != TextDirection.rtl
//                   ? AllPromoCard(
//                       serial: promo.serial,
//                       imagepath: promo.imagePath ?? '',
//                       title: promo.eventTopic,
//                       description: promo.eventEnDescription,
//                       startDate: promo.startDate,
//                       endDate: promo.endDate,
//                       promodet: promo.promotionDetails.isNotEmpty
//                           ? promo.promotionDetails[0].promotionCode
//                           : "N/A",
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 ApplyToPromoDet(promotion: promo),
//                           ),
//                         );
//                       },
//                     )
//                   : AllPromoCard(
//                       serial: promo.serial,
//                       imagepath: promo.imagePath ?? '',
//                       title: promo.eventDescription,
//                       description: promo.eventArDescription,
//                       startDate: promo.startDate,
//                       endDate: promo.endDate,
//                       promodet: promo.promotionDetails.isNotEmpty
//                           ? promo.promotionDetails[0].promotionCode
//                           : "N/A",
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 ApplyToPromoDet(promotion: promo),
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

// Disable cards based on applied or expired
import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/curr_promo_model.dart';
import 'package:total_energies/models/exp_promo_model.dart';
import 'package:total_energies/models/promotions_model.dart';
import 'package:total_energies/screens/Promotions/apply_to_promo_det.dart';
import 'package:total_energies/screens/loading_screen.dart';
import 'package:total_energies/services/curr_promo_service.dart';
import 'package:total_energies/services/exp_promo_service.dart';
import 'package:total_energies/services/promotions_service.dart';
import 'package:total_energies/widgets/Promotions/all_promo_card.dart';

class AllPromotionsPage extends StatefulWidget {
  const AllPromotionsPage({super.key});

  @override
  _AllPromotionsPageState createState() => _AllPromotionsPageState();
}

class _AllPromotionsPageState extends State<AllPromotionsPage> {
  late Future<List<PromotionsModel>> _futureAllPromos;
  late Future<List<CurrPromoModel>> _futureCurrPromos;
  late Future<List<ExpiredPromoModel>> _futureExpPromos;
  // final PromotionsService _promotionsService = PromotionsService();

  @override
  void initState() {
    super.initState();
    _futureAllPromos = PromotionsService().getPromotions();
    _futureCurrPromos = GetCurrPromoService().getCurrPromotion();
    _futureExpPromos = ExpiredPromoService().getExpiredPromotions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait(
            [_futureAllPromos, _futureCurrPromos, _futureExpPromos]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingScreen());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<PromotionsModel> allPromos = snapshot.data![0];
          List<CurrPromoModel> currPromos = snapshot.data![1];
          List<ExpiredPromoModel> expPromos = snapshot.data![2];

          // Ensure both are int (or both are string)
          Set<int> currPromoSerials =
              currPromos.map((e) => int.parse(e.serial.toString())).toSet();
          Set<int> expPromoSerials =
              expPromos.map((e) => int.parse(e.serial.toString())).toSet();

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: allPromos.length,
            itemBuilder: (context, index) {
              final promo = allPromos[index];
              final isAvailable = !currPromoSerials.contains(promo.serial);
              final isexp = !expPromoSerials.contains(promo.serial);
              print(
                  "Promo serial: ${promo.serial} | isAvailable: $isAvailable | isexp: $isexp");
              return AllPromoCard(
                serial: promo.serial,
                imagepath: promo.imagePath ?? '',
                title: Directionality.of(context) != TextDirection.rtl
                    ? promo.eventTopic
                    : promo.eventDescription,
                description: Directionality.of(context) != TextDirection.rtl
                    ? promo.eventEnDescription
                    : promo.eventArDescription,
                startDate: promo.startDate,
                endDate: promo.endDate,
                promodet: promo.promotionDetails.isNotEmpty
                    ? promo.promotionDetails[0].promotionCode
                    : "N/A",
                onTap: isAvailable || isexp
                    ? () {}
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ApplyToPromoDet(promotion: promo),
                          ),
                        );
                      },
                isAvailable: isAvailable,
                isexp: isexp, // ← add this parameter
              );
            },
          );
        },
      ),
    );
  }
}
