import 'package:flutter/material.dart';
import 'package:total_energies/models/categories_promotion_model.dart';

class CategoryPromoDetailPage extends StatelessWidget {
  final CategoriesPromotionModel promotion;

  const CategoryPromoDetailPage({Key? key, required this.promotion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(promotion.eventTopic)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              promotion.eventDescription,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text("From: ${promotion.startDate.split('T').first}"),
            Text("To: ${promotion.endDate.split('T').first}"),
            const SizedBox(height: 12),
            Text("Used: ${promotion.usedTimes} / ${promotion.qrMaxUsage}"),
          ],
        ),
      ),
    );
  }
}
