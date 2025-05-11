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

// mesada2
// Disable cards based on applied or expired
// import 'package:flutter/material.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/curr_promo_model.dart';
// import 'package:total_energies/models/exp_promo_model.dart';
// import 'package:total_energies/models/promotions_model.dart';
// import 'package:total_energies/screens/Promotions/apply_to_promo_det.dart';
// import 'package:total_energies/screens/loading_screen.dart';
// import 'package:total_energies/services/curr_promo_service.dart';
// import 'package:total_energies/services/exp_promo_service.dart';
// import 'package:total_energies/services/promotions_service.dart';
// import 'package:total_energies/widgets/Promotions/all_promo_card.dart';

// class AllPromotionsPage extends StatefulWidget {
//   const AllPromotionsPage({super.key});

//   @override
//   State<AllPromotionsPage> createState() => _AllPromotionsPageState();
// }

// class _AllPromotionsPageState extends State<AllPromotionsPage> {
//   late Future<List<dynamic>> _futurePromotions;

//   @override
//   void initState() {
//     super.initState();
//     _futurePromotions = _loadAllData();
//   }

//   Future<List<dynamic>> _loadAllData() async {
//     try {
//       final allPromos = PromotionsService().getPromotions();
//       final currPromos = GetCurrPromoService().getCurrPromotion();
//       final expPromos = ExpiredPromoService().getExpiredPromotions();

//       return await Future.wait([allPromos, currPromos, expPromos]);
//     } catch (e) {
//       // Log or process the error as needed
//       rethrow;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: FutureBuilder<List<dynamic>>(
//         future: _futurePromotions,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: LoadingScreen());
//           }

//           if (snapshot.hasError) {
//             return Center(
//                 child:
//                     Text('حدث خطأ أثناء تحميل البيانات:\n${snapshot.error}'));
//           }

//           if (!snapshot.hasData || snapshot.data!.length != 3) {
//             return const Center(child: Text('لا توجد بيانات متاحة.'));
//           }

//           final List<PromotionsModel> allPromos =
//               List<PromotionsModel>.from(snapshot.data![0]);
//           final List<CurrPromoModel> currPromos =
//               List<CurrPromoModel>.from(snapshot.data![1]);
//           final List<ExpiredPromoModel> expPromos =
//               List<ExpiredPromoModel>.from(snapshot.data![2]);

//           final Set<int> currentPromoSerials = currPromos
//               .map((e) => int.tryParse(e.serial.toString()) ?? -1)
//               .toSet();
//           final Set<int> expiredPromoSerials = expPromos
//               .map((e) => int.tryParse(e.serial.toString()) ?? -1)
//               .toSet();

//           return ListView.builder(
//             padding: const EdgeInsets.all(10),
//             itemCount: allPromos.length,
//             itemBuilder: (context, index) {
//               final promo = allPromos[index];
//               final int serial = promo.serial ?? -1;

//               final bool isCurrentPromo = currentPromoSerials.contains(serial);
//               final bool isExpiredPromo = expiredPromoSerials.contains(serial);

//               final String imageUrl = promo.imagePath != null
//                   ? "https://www.besttopsystems.net:4336${promo.imagePath!.replaceAll('\\', '/')}"
//                   : '';

//               final bool isPromoAvailable = !isCurrentPromo && !isExpiredPromo;

//               print("Image Url: $imageUrl");

//               return AllPromoCard(
//                 serial: promo.serial,
//                 imagepath: imageUrl,
//                 title: Directionality.of(context) == TextDirection.rtl
//                     ? promo.eventDescription ?? "بدون عنوان"
//                     : promo.eventTopic ?? "No Title",
//                 description: Directionality.of(context) == TextDirection.rtl
//                     ? promo.eventArDescription ?? ""
//                     : promo.eventEnDescription ?? "",
//                 startDate: promo.startDate,
//                 endDate: promo.endDate,
//                 promodet: promo.promotionDetails?.isNotEmpty == true
//                     ? promo.promotionDetails!.first.promotionCode
//                     : "N/A",
//                 onTap: isPromoAvailable
//                     ? () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 ApplyToPromoDet(promotion: promo),
//                           ),
//                         );
//                       }
//                     : () {},
//                 isAvailable: isPromoAvailable,
//                 isexp: isExpiredPromo,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// Hady w sha8al tamam
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/promotions_model.dart';
// import 'package:total_energies/screens/Promotions/apply_to_promo_det.dart';
// import 'package:total_energies/services/promotions_service.dart';
// import 'package:total_energies/widgets/Promotions/all_promo_card.dart';

// class AllPromotionsPage extends StatefulWidget {
//   const AllPromotionsPage({super.key});

//   @override
//   State<AllPromotionsPage> createState() => _AllPromotionsPageState();
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
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No promotions available.'));
//           }

//           final promotions = snapshot.data!;

//           return ListView.builder(
//             itemCount: promotions.length,
//             itemBuilder: (context, index) {
//               final promo = promotions[index];
//               // final isAvailable = promo.remainingUsage! > 0;
//               // final isExpired = promo.endDate!.isAfter(DateTime.now());

//               return AllPromoCard(
//                 serial: promo.serial,
//                 imagepath: promo.imagePath ?? '',
//                 title: promo.eventTopic ?? '',
//                 description: promo.eventDescription ?? '',
//                 startDate: promo.startDate,
//                 endDate: promo.endDate,
//                 total: promo.qrMaxUsage,
//                 used: promo.usedTimes,
//                 // isAvailable: isAvailable,
//                 // isexp: isExpired,
//                 onTap: () {
//                   Get.to(() => ApplyToPromoDet(promotion: promo));
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/promotions_model.dart';
import 'package:total_energies/screens/Promotions/apply_to_promo_det.dart';
import 'package:total_energies/services/get_curr_promo_service.dart';
import 'package:total_energies/services/get_exp_promo_service.dart';
import 'package:total_energies/services/promotions_service.dart';
import 'package:total_energies/widgets/Promotions/all_promo_card.dart';

class AllPromotionsPage extends StatefulWidget {
  const AllPromotionsPage({super.key});

  @override
  State<AllPromotionsPage> createState() => _AllPromotionsPageState();
}

class _AllPromotionsPageState extends State<AllPromotionsPage> {
  final PromotionsService _promotionsService = PromotionsService();

  late Future<void> _loadDataFuture;
  List<PromotionsModel> _promotions = [];
  Set<int> _currPromoSerials = {};
  Set<int> _expPromoSerials = {};

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
  }

  Future<void> _loadData() async {
    _promotions = await _promotionsService.getPromotions();

    final currPromos = await GetCurrPromoService().getCurrPromotions();
    _currPromoSerials = currPromos.map((e) => e.serial).toSet();

    final expPromos = await GetExpPromoService().getExpPromotions();
    _expPromoSerials = expPromos.map((e) => e.serial).toSet();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<void>(
        future: _loadDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (_promotions.isEmpty) {
            return const Center(child: Text('No promotions available.'));
          }

          return ListView.builder(
            itemCount: _promotions.length,
            itemBuilder: (context, index) {
              final promo = _promotions[index];
              final isBlocked = _currPromoSerials.contains(promo.serial) ||
                  _expPromoSerials.contains(promo.serial);

              return AllPromoCard(
                serial: promo.serial,
                imagepath: promo.imagePath ?? '',
                title: promo.eventTopic ?? '',
                description: promo.eventDescription ?? '',
                startDate: promo.startDate,
                endDate: promo.endDate,
                total: promo.qrMaxUsage,
                used: promo.usedTimes,
                isBlocked: isBlocked,
                onTap: () {
                  if (!isBlocked) {
                    Get.to(() => ApplyToPromoDet(promotion: promo));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
