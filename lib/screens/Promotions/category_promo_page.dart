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
                    'Check internet connection',
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
                imagepath: promo.imagePath.replaceAll('\\', '/'),
                title: promo.eventTopic,
                description: promo.eventDescription,
                startDate:
                    DateTime.tryParse(promo.startDate) ?? DateTime.now(),
                endDate:
                    DateTime.tryParse(promo.endDate) ?? DateTime.now(),
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
