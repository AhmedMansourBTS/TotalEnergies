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


import 'package:flutter/material.dart';
import 'package:total_energies/models/categories_promotion_model.dart';
import 'package:total_energies/screens/Promotions/category_promo_det_page.dart';
import 'package:total_energies/services/get_categ_promo_service.dart';
import 'package:total_energies/widgets/Promotions/categ_promo_card.dart';

class CategoryDetailsPage extends StatefulWidget {
  final int categoryId;
  final String categoryTitle;

  const CategoryDetailsPage({
    Key? key,
    required this.categoryId,
    required this.categoryTitle,
  }) : super(key: key);

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  late Future<List<CategoriesPromotionModel>> _promosFuture;

  @override
  void initState() {
    super.initState();
    _promosFuture = GetCategPromoService.getPromotionsByCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryTitle)),
      body: FutureBuilder<List<CategoriesPromotionModel>>(
        future: _promosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No promotions available.'));
          }

          final promotions = snapshot.data!;
          return ListView.builder(
            itemCount: promotions.length,
            itemBuilder: (context, index) {
              final promo = promotions[index];
              return CategPromoCard(
                imagepath: promo.imagePath,
                title: promo.eventTopic,
                description: promo.eventDescription,
                startDate: DateTime.tryParse(promo.startDate),
                endDate: DateTime.tryParse(promo.endDate),
                total: promo.qrMaxUsage,
                used: promo.usedTimes,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryPromoDetailPage(promotion: promo),
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
