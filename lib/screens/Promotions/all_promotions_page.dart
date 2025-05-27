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

// Sha8ala tamam w b disable el curr w el exp bas allpromocard doesn't have iscurr w isexp
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/promotions_model.dart';
// import 'package:total_energies/screens/Promotions/apply_to_promo_det.dart';
// import 'package:total_energies/services/get_curr_promo_service.dart';
// import 'package:total_energies/services/get_exp_promo_service.dart';
// import 'package:total_energies/services/promotions_service.dart';
// import 'package:total_energies/widgets/Promotions/all_promo_card.dart';

// class AllPromotionsPage extends StatefulWidget {
//   const AllPromotionsPage({super.key});

//   @override
//   State<AllPromotionsPage> createState() => _AllPromotionsPageState();
// }

// class _AllPromotionsPageState extends State<AllPromotionsPage> {
//   final PromotionsService _promotionsService = PromotionsService();

//   late Future<void> _loadDataFuture;
//   List<PromotionsModel> _promotions = [];
//   Set<int> _currPromoSerials = {};
//   Set<int> _expPromoSerials = {};

//   @override
//   void initState() {
//     super.initState();
//     _loadDataFuture = _loadData();
//   }

//   Future<void> _loadData() async {
//     _promotions = await _promotionsService.getPromotions();

//     final currPromos = await GetCurrPromoService().getCurrPromotions();
//     _currPromoSerials = currPromos.map((e) => e.serial).toSet();

//     final expPromos = await GetExpPromoService().getExpPromotions();
//     _expPromoSerials = expPromos.map((e) => e.serial).toSet();

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: FutureBuilder<void>(
//         future: _loadDataFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (_promotions.isEmpty) {
//             return const Center(child: Text('No promotions available.'));
//           }

//           return ListView.builder(
//             itemCount: _promotions.length,
//             itemBuilder: (context, index) {
//               final promo = _promotions[index];
//               final isBlocked = _currPromoSerials.contains(promo.serial) ||
//                   _expPromoSerials.contains(promo.serial);

//               final isCurr = _currPromoSerials.contains(promo.serial);
//               final isExp = _expPromoSerials.contains(promo.serial);

//               return Container(
//                 child: Column(
//                   children: [
//                     AllPromoCard(
//                       serial: promo.serial,
//                       imagepath: promo.imagePath ?? '',
//                       title: promo.eventTopic ?? '',
//                       description: promo.eventDescription ?? '',
//                       startDate: promo.startDate,
//                       endDate: promo.endDate,
//                       total: promo.qrMaxUsage,
//                       used: promo.usedTimes,
//                       isBlocked: isBlocked,
//                       onTap: () {
//                         if (!isBlocked) {
//                           Get.to(() => ApplyToPromoDet(promotion: promo));
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// with categoriszing
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/promotions_model.dart';
// import 'package:total_energies/screens/Promotions/apply_to_promo_det.dart';
// import 'package:total_energies/services/get_curr_promo_service.dart';
// import 'package:total_energies/services/get_exp_promo_service.dart';
// import 'package:total_energies/services/promotions_service.dart';
// import 'package:total_energies/widgets/Promotions/all_promo_card.dart';

// class AllPromotionsPage extends StatefulWidget {
//   const AllPromotionsPage({super.key});

//   @override
//   State<AllPromotionsPage> createState() => _AllPromotionsPageState();
// }

// class _AllPromotionsPageState extends State<AllPromotionsPage> {
//   final PromotionsService _promotionsService = PromotionsService();

//   late Future<void> _loadDataFuture;
//   List<PromotionsModel> _promotions = [];
//   Set<int> _currPromoSerials = {};
//   Set<int> _expPromoSerials = {};

//   @override
//   void initState() {
//     super.initState();
//     _loadDataFuture = _loadData();
//   }

//   Future<void> _loadData() async {
//     _promotions = await _promotionsService.getPromotions();

//     final currPromos = await GetCurrPromoService().getCurrPromotions();
//     _currPromoSerials = currPromos.map((e) => e.serial).toSet();

//     final expPromos = await GetExpPromoService().getExpPromotions();
//     _expPromoSerials = expPromos.map((e) => e.serial).toSet();

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: FutureBuilder<void>(
//         future: _loadDataFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (_promotions.isEmpty) {
//             return const Center(child: Text('No promotions available.'));
//           }

//           // Split promotions by state
//           final currentPromos = _promotions
//               .where((promo) => _currPromoSerials.contains(promo.serial))
//               .toList();
//           final expiredPromos = _promotions
//               .where((promo) =>
//                   !_currPromoSerials.contains(promo.serial) &&
//                   _expPromoSerials.contains(promo.serial))
//               .toList();
//           final availablePromos = _promotions
//               .where((promo) =>
//                   !_currPromoSerials.contains(promo.serial) &&
//                   !_expPromoSerials.contains(promo.serial))
//               .toList();

//           return ListView(
//             padding: const EdgeInsets.all(12),
//             children: [
//               if (availablePromos.isNotEmpty) ...[
//                 const Text("Available Promotions",
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: primaryColor)),
//                 const SizedBox(height: 10),
//                 ...availablePromos.map((promo) {
//                   return AllPromoCard(
//                     serial: promo.serial,
//                     imagepath: promo.imagePath ?? '',
//                     title: promo.eventTopic ?? '',
//                     description: promo.eventDescription ?? '',
//                     startDate: promo.startDate,
//                     endDate: promo.endDate,
//                     total: promo.qrMaxUsage,
//                     used: promo.usedTimes,
//                     isBlocked: false,
//                     isCurr: false,
//                     isExp: false,
//                     onTap: () {
//                       Get.to(() => ApplyToPromoDet(promotion: promo));
//                     },
//                   );
//                 }),
//               ],
//               if (currentPromos.isNotEmpty) ...[
//                 const SizedBox(height: 24),
//                 const Text("Current Promotions",
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: primaryColor)),
//                 const SizedBox(height: 10),
//                 ...currentPromos.map((promo) {
//                   return AllPromoCard(
//                     serial: promo.serial,
//                     imagepath: promo.imagePath ?? '',
//                     title: promo.eventTopic ?? '',
//                     description: promo.eventDescription ?? '',
//                     startDate: promo.startDate,
//                     endDate: promo.endDate,
//                     total: promo.qrMaxUsage,
//                     used: promo.usedTimes,
//                     isBlocked: true,
//                     isCurr: true,
//                     isExp: false,
//                     onTap: () {}, // disabled
//                   );
//                 }),
//               ],
//               if (expiredPromos.isNotEmpty) ...[
//                 const SizedBox(height: 24),
//                 const Text("Expired Promotions",
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: primaryColor)),
//                 const SizedBox(height: 10),
//                 ...expiredPromos.map((promo) {
//                   return AllPromoCard(
//                     serial: promo.serial,
//                     imagepath: promo.imagePath ?? '',
//                     title: promo.eventTopic ?? '',
//                     description: promo.eventDescription ?? '',
//                     startDate: promo.startDate,
//                     endDate: promo.endDate,
//                     total: promo.qrMaxUsage,
//                     used: promo.usedTimes,
//                     isBlocked: true,
//                     isCurr: false,
//                     isExp: true,
//                     onTap: () {}, // disabled
//                   );
//                 }),
//               ],
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// with filtering
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/promotions_model.dart';
import 'package:total_energies/screens/Promotions/apply_to_promo_det.dart';
import 'package:total_energies/screens/loading_screen.dart';
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
  List<PromotionsModel> _filteredPromotions = [];
  Set<int> _currPromoSerials = {};
  Set<int> _expPromoSerials = {};
  String _filter = 'All';

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

    _applyFilter();
    setState(() {});
  }

  void _applyFilter() {
    _filteredPromotions = _promotions.where((promo) {
      final isCurr = _currPromoSerials.contains(promo.serial);
      final isExp = _expPromoSerials.contains(promo.serial);
      final isAvailable = !isCurr && !isExp;

      switch (_filter) {
        case 'Available':
          return isAvailable;
        case 'Ongoing':
          return isCurr;
        case 'Expired':
          return isExp;
        default:
          return true;
      }
    }).toList();
  }

  void _onFilterChanged(String filter) {
    _filter = filter;
    _applyFilter();
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
            return const Center(child: LoadingScreen());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (_filteredPromotions.isEmpty) {
            return const Center(child: Text('No promotions found.'));
          }

          return Column(
            children: [
              // Filter Chips (without search)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: ['All', 'Available', 'Ongoing', 'Expired']
                      .map((label) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(label),
                              selected: _filter == label,
                              onSelected: (_) => _onFilterChanged(label),
                              selectedColor: primaryColor,
                            ),
                          ))
                      .toList(),
                ),
              ),

              // Promotions List
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredPromotions.length,
                  itemBuilder: (context, index) {
                    final promo = _filteredPromotions[index];
                    final isCurr = _currPromoSerials.contains(promo.serial);
                    final isExp = _expPromoSerials.contains(promo.serial);
                    final isBlocked = isCurr || isExp;

                    String statusLabel = 'Available';
                    Color statusColor = Colors.green;
                    if (isCurr) {
                      statusLabel = 'Ongoing';
                      statusColor = Colors.orange;
                    } else if (isExp) {
                      statusLabel = 'Expired';
                      statusColor = Colors.grey;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: AllPromoCard(
                        serial: promo.serial,
                        imagepath: promo.imagePath ?? '',
                        title: promo.eventTopic ?? '',
                        description: promo.eventDescription ?? '',
                        startDate: promo.startDate,
                        endDate: promo.endDate,
                        total: promo.qrMaxUsage,
                        used: promo.usedTimes,
                        isBlocked: isBlocked,
                        statusLabel: statusLabel,
                        statusColor: statusColor,
                        onTap: () {
                          if (!isBlocked) {
                            Get.to(() => ApplyToPromoDet(promotion: promo));
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
