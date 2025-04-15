// import 'package:flutter/material.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/promotions_model.dart';
// import 'package:total_energies/screens/Promotions/exp_promo_det.dart';
// import 'package:total_energies/screens/loading_screen.dart';
// import 'package:total_energies/services/get_exp_promo_service.dart';
// import 'package:total_energies/widgets/Promotions/old_promo_card.dart';

// class OldPromotionsPage extends StatefulWidget {
//   const OldPromotionsPage({super.key});

//   @override
//   _OldPromotionsPageState createState() => _OldPromotionsPageState();
// }

// class _OldPromotionsPageState extends State<OldPromotionsPage> {
//   late Future<List<PromotionsModel>> _futurePromotions;
//   // final PromotionsService _promotionsService = PromotionsService();
//   final GetExpPromoService _promotionsService = GetExpPromoService();

//   @override
//   void initState() {
//     super.initState();
//     _futurePromotions = _promotionsService.getExpPromotions();
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
//             return const Center(
//                 child: Text(
//               'You dont have expired promotions',
//               style: TextStyle(color: Colors.red, fontSize: 20),
//             ));
//           }

//           List<PromotionsModel> promotions = snapshot.data!;

//           return ListView.builder(
//             padding: const EdgeInsets.all(10),
//             itemCount: promotions.length,
//             itemBuilder: (context, index) {
//               final promo = promotions[index];

//               return Directionality.of(context) != TextDirection.rtl
//                   ? OldPromoCard(
//                       imagepath: promo.imagePath ?? '',
//                       title: promo.eventTopic,
//                       description: promo.eventEnDescription,
//                       startDate: promo.startDate,
//                       endDate: promo.endDate,
//                       total: promo.qrMaxUsage,
//                       used: 0,
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ExpPromoDet(promotion: promo),
//                           ),
//                         );
//                       },
//                     )
//                   : OldPromoCard(
//                       imagepath: promo.imagePath ?? '',
//                       title: promo.eventTopic,
//                       description: promo.eventDescription,
//                       startDate: promo.startDate,
//                       endDate: promo.endDate,
//                       total: promo.qrMaxUsage,
//                       used: 0,
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ExpPromoDet(promotion: promo),
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
import 'package:total_energies/models/exp_promo_model.dart';
import 'package:total_energies/models/promotions_model.dart';
import 'package:total_energies/screens/Promotions/exp_promo_det.dart';
import 'package:total_energies/screens/loading_screen.dart';
import 'package:total_energies/services/get_exp_promo_service.dart';
import 'package:total_energies/widgets/Promotions/old_promo_card.dart';

class OldPromotionsPage extends StatefulWidget {
  const OldPromotionsPage({super.key});

  @override
  _OldPromotionsPageState createState() => _OldPromotionsPageState();
}

class _OldPromotionsPageState extends State<OldPromotionsPage> {
  late Future<List<ExpiredPromoModel>> _futurePromotions;
  // final PromotionsService _promotionsService = PromotionsService();
  final GetExpPromoService _promotionsService = GetExpPromoService();

  @override
  void initState() {
    super.initState();
    _futurePromotions = _promotionsService.getExpPromotions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<List<ExpiredPromoModel>>(
        future: _futurePromotions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingScreen());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
              'You dont have expired promotions',
              style: TextStyle(color: Colors.red, fontSize: 20),
            ));
          }

          List<ExpiredPromoModel> promotions = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: promotions.length,
            itemBuilder: (context, index) {
              final promo = promotions[index];

              return Directionality.of(context) != TextDirection.rtl
                  ? OldPromoCard(
                      imagepath: promo.imagePath ?? '',
                      title: promo.eventTopic,
                      description: promo.eventEnDescription,
                      startDate: promo.startDate,
                      endDate: promo.endDate,
                      total: promo.qrMaxUsage,
                      used: promo.qrMaxUsage,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExpPromoDet(promotion: promo),
                          ),
                        );
                      },
                    )
                  : OldPromoCard(
                      imagepath: promo.imagePath ?? '',
                      title: promo.eventTopic,
                      description: promo.eventDescription,
                      startDate: promo.startDate,
                      endDate: promo.endDate,
                      total: promo.qrMaxUsage,
                      used: promo.qrMaxUsage,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExpPromoDet(promotion: promo),
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
