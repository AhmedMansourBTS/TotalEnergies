// import 'package:flutter/material.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/exp_promo_model.dart';
// import 'package:total_energies/screens/Promotions/exp_promo_det.dart';
// import 'package:total_energies/screens/loading_screen.dart';
// import 'package:total_energies/services/get_categ_promo_service.dart';
// import 'package:total_energies/services/get_exp_promo_service.dart';
// import 'package:total_energies/widgets/Promotions/old_promo_card.dart';

// class CategoryPromoPage extends StatefulWidget {
//   const CategoryPromoPage({super.key});

//   @override
//   _CategoryPromoPageState createState() => _CategoryPromoPageState();
// }

// class _CategoryPromoPageState extends State<CategoryPromoPage> {
//   late Future<List<ExpiredPromoModel>> _futurePromotions;
//   // final PromotionsService _promotionsService = PromotionsService();
//   final GetCategPromoService _promotionsService = GetCategPromoService();

//   @override
//   void initState() {
//     super.initState();
//     _futurePromotions = _promotionsService.getPromotionsByCategory();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: FutureBuilder<List<ExpiredPromoModel>>(
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
//               style: TextStyle(color: Colors.red, fontSize: 18),
//             ));
//           }

//           List<ExpiredPromoModel> promotions = snapshot.data!;

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
//                       used: promo.qrMaxUsage,
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
//                       used: promo.qrMaxUsage,
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

// import 'package:flutter/material.dart';
// import 'package:total_energies/models/categories_model.dart';

// class CategoryDetailsPage extends StatelessWidget {
//   final CategoryModel category;

//   const CategoryDetailsPage({Key? key, required this.category})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(category.categoryLatName)),
//       body: Center(
//         child: Text(
//             'Category ID: ${category.categoryId}\nName: ${category.categoryLatName}'),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/categories_promotion_model.dart';
// import 'package:total_energies/screens/Promotions/category_promo_det_page.dart';
// import 'package:total_energies/services/get_categ_promo_service.dart';
// import 'package:total_energies/widgets/Promotions/categ_promo_card.dart';
// import 'package:total_energies/widgets/global/app_bar_logos.dart';

// class CategoryDetailsPage extends StatefulWidget {
//   final int categoryId;
//   final String categoryTitle;

//   const CategoryDetailsPage({
//     Key? key,
//     required this.categoryId,
//     required this.categoryTitle,
//   }) : super(key: key);

//   @override
//   State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
// }

// class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
//   late Future<List<CategoriesPromotionModel>> _promosFuture;

//   @override
//   void initState() {
//     super.initState();
//     _promosFuture =
//         GetCategPromoService.getPromotionsByCategory(widget.categoryId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//           backgroundColor: backgroundColor, title: LogoRow()),
//       body: FutureBuilder<List<CategoriesPromotionModel>>(
//         future: _promosFuture,
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
//               return CategPromoCard(
//                 imagepath: promo.imagePath,
//                 title: promo.eventTopic,
//                 description: promo.eventDescription,
//                 startDate: DateTime.tryParse(promo.startDate),
//                 endDate: DateTime.tryParse(promo.endDate),
//                 total: promo.qrMaxUsage,
//                 used: promo.usedTimes,
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => CategoryPromoDetailPage(promotion: promo),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// works well
// import 'package:flutter/material.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/categories_promotion_model.dart';
// import 'package:total_energies/screens/Promotions/category_promo_det_page.dart';
// import 'package:total_energies/screens/loading_screen.dart';
// import 'package:total_energies/services/get_categ_promo_service.dart';
// import 'package:total_energies/services/get_curr_promo_service.dart';
// import 'package:total_energies/services/get_exp_promo_service.dart';
// import 'package:total_energies/widgets/Promotions/categ_promo_card.dart';
// import 'package:total_energies/widgets/global/app_bar_logos.dart';

// class CategoryDetailsPage extends StatefulWidget {
//   final int categoryId;
//   final String categoryTitle;

//   const CategoryDetailsPage({
//     super.key,
//     required this.categoryId,
//     required this.categoryTitle,
//   });

//   @override
//   State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
// }

// class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
//   late Future<void> _loadDataFuture;
//   List<CategoriesPromotionModel> _promotions = [];
//   Set<int> _currPromoSerials = {};
//   Set<int> _expPromoSerials = {};

//   @override
//   void initState() {
//     super.initState();
//     _loadDataFuture = _loadData();
//   }

//   Future<void> _loadData() async {
//     // Fetch category promotions
//     _promotions =
//         await GetCategPromoService.getPromotionsByCategory(widget.categoryId);

//     // Fetch current promotions and extract their serials
//     final currPromos = await GetCurrPromoService().getCurrPromotions(context);
//     _currPromoSerials = currPromos.map((e) => e.serial).toSet();

//     // Fetch current promotions and extract their serials
//     final expPromos = await GetExpPromoService().getExpPromotions(context);
//     _expPromoSerials = expPromos.map((e) => e.serial).toSet();

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         title: const LogoRow(),
//       ),
//       body: FutureBuilder<void>(
//         future: _loadDataFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: LoadingScreen());
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

//               return CategPromoCard(
//                 serial: promo.serial,
//                 imagepath: promo.imagePath,
//                 title: promo.eventTopic,
//                 description: promo.eventDescription,
//                 startDate: DateTime.tryParse(promo.startDate),
//                 endDate: DateTime.tryParse(promo.endDate),
//                 total: promo.qrMaxUsage,
//                 used: promo.usedTimes,
//                 isBlocked: isBlocked,
//                 onTap: () {
//                   if (!isBlocked) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) =>
//                             CategoryPromoDetailPage(promotion: promo),
//                       ),
//                     );
//                   }
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/categories_promotion_model.dart';
// import 'package:total_energies/screens/Promotions/category_promo_det_page.dart';
// import 'package:total_energies/screens/loading_screen.dart';
// import 'package:total_energies/services/get_categ_promo_service.dart';
// import 'package:total_energies/services/get_curr_promo_service.dart';
// import 'package:total_energies/services/get_exp_promo_service.dart';
// import 'package:total_energies/widgets/Promotions/categ_promo_card.dart';
// import 'package:total_energies/widgets/global/app_bar_logos.dart';

// class CategoryDetailsPage extends StatefulWidget {
//   final int categoryId;
//   final String categoryTitle;

//   const CategoryDetailsPage({
//     super.key,
//     required this.categoryId,
//     required this.categoryTitle,
//   });

//   @override
//   State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
// }

// class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
//   late Future<void> _loadDataFuture;
//   List<CategoriesPromotionModel> _promotions = [];
//   Set<int> _currPromoSerials = {};
//   Set<int> _expPromoSerials = {};

//   @override
//   void initState() {
//     super.initState();
//     _loadDataFuture = _loadData();
//   }

//   Future<void> _loadData() async {
//     try {
//       // Fetch category promotions with context
//       _promotions = await GetCategPromoService.getPromotionsByCategory(
//           widget.categoryId, context);

//       // Fetch current promotions and extract their serials
//       final currPromos = await GetCurrPromoService().getCurrPromotions(context);
//       _currPromoSerials = currPromos.map((e) => e.serial).toSet();

//       // Fetch expired promotions and extract their serials
//       final expPromos = await GetExpPromoService().getExpPromotions(context);
//       _expPromoSerials = expPromos.map((e) => e.serial).toSet();
//     } catch (e) {
//       print("Error loading data: $e");
//       rethrow; // Rethrow to let FutureBuilder handle the error
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         title: const LogoRow(),
//       ),
//       body: FutureBuilder<void>(
//         future: _loadDataFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: LoadingScreen());
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Error: ${snapshot.error}',
//                     style:
//                         const TextStyle(color: Colors.redAccent, fontSize: 16),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _loadDataFuture = _loadData();
//                       });
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: primaryColor,
//                     ),
//                     child: const Text(
//                       "Retry",
//                       style: TextStyle(color: btntxtColors, fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           } else if (_promotions.isEmpty) {
//             return const Center(
//               child: Text(
//                 'No promotions available.',
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             );
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             itemCount: _promotions.length,
//             itemBuilder: (context, index) {
//               final promo = _promotions[index];
//               final isBlocked = _currPromoSerials.contains(promo.serial) ||
//                   _expPromoSerials.contains(promo.serial);

//               return CategPromoCard(
//                 serial: promo.serial,
//                 imagepath: promo.imagePath?.replaceAll('\\', '/') ?? '',
//                 title: promo.eventTopic ?? '',
//                 description: promo.eventDescription ?? '',
//                 startDate:
//                     DateTime.tryParse(promo.startDate ?? '') ?? DateTime.now(),
//                 endDate:
//                     DateTime.tryParse(promo.endDate ?? '') ?? DateTime.now(),
//                 total: promo.qrMaxUsage,
//                 used: promo.usedTimes,
//                 isBlocked: isBlocked,
//                 onTap: () {
//                   if (!isBlocked) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) =>
//                             CategoryPromoDetailPage(promotion: promo),
//                       ),
//                     );
//                   }
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
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/categories_promotion_model.dart';
import 'package:total_energies/screens/Promotions/category_promo_det_page.dart';
import 'package:total_energies/screens/loading_screen.dart';
import 'package:total_energies/services/get_categ_promo_service.dart';
import 'package:total_energies/services/get_curr_promo_service.dart';
import 'package:total_energies/services/get_exp_promo_service.dart';
import 'package:total_energies/widgets/Promotions/categ_promo_card.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';

class CategoryDetailsPage extends StatefulWidget {
  final int categoryId;
  final String categoryTitle;

  const CategoryDetailsPage({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
  });

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  late Future<void> _loadDataFuture;
  List<CategoriesPromotionModel> _promotions = [];
  Set<int> _currPromoSerials = {};
  Set<int> _expPromoSerials = {};

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
  }

  Future<void> _loadData() async {
    try {
      _promotions = await GetCategPromoService.getPromotionsByCategory(
        widget.categoryId,
        context,
      );

      final currPromos = await GetCurrPromoService().getCurrPromotions(context);
      _currPromoSerials = currPromos.map((e) => e.serial).toSet();

      final expPromos = await GetExpPromoService().getExpPromotions(context);
      _expPromoSerials = expPromos.map((e) => e.serial).toSet();
    } catch (e) {
      print("Error loading data: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: true, // shows back arrow if needed
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: const LogoRow(),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40), // prevents overlap
                child: Text(
                  widget.categoryTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<void>(
        future: _loadDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingScreen());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${snapshot.error}',
                    style:
                        const TextStyle(color: Colors.redAccent, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _loadDataFuture = _loadData();
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
          } else if (_promotions.isEmpty) {
            return const Center(
              child: Text(
                'No promotions available.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            itemCount: _promotions.length,
            itemBuilder: (context, index) {
              final promo = _promotions[index];
              final isBlocked = _currPromoSerials.contains(promo.serial) ||
                  _expPromoSerials.contains(promo.serial);

              return CategPromoCard(
                serial: promo.serial,
                imagepath: promo.imagePath?.replaceAll('\\', '/') ?? '',
                title: promo.eventTopic ?? '',
                description: promo.eventDescription ?? '',
                startDate:
                    DateTime.tryParse(promo.startDate ?? '') ?? DateTime.now(),
                endDate:
                    DateTime.tryParse(promo.endDate ?? '') ?? DateTime.now(),
                total: promo.qrMaxUsage,
                used: promo.usedTimes,
                isBlocked: isBlocked,
                onTap: () {
                  if (!isBlocked) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CategoryPromoDetailPage(promotion: promo),
                      ),
                    );
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
