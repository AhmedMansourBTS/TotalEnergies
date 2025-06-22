// import 'package:flutter/material.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/categories_promotion_model.dart';
// import 'package:total_energies/widgets/global/app_bar_logos.dart';

// class CategoryPromoDetailPage extends StatelessWidget {
//   final CategoriesPromotionModel promotion;

//   const CategoryPromoDetailPage({Key? key, required this.promotion})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(backgroundColor: backgroundColor, title: LogoRow()),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               promotion.eventDescription,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             Text("From: ${promotion.startDate.split('T').first}"),
//             Text("To: ${promotion.endDate.split('T').first}"),
//             const SizedBox(height: 12),
//             Text("Used: ${promotion.usedTimes} / ${promotion.qrMaxUsage}"),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/categories_promotion_model.dart';
import 'package:total_energies/screens/loading_screen.dart';
import 'package:total_energies/services/register_to_promotion_service.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';

class CategoryPromoDetailPage extends StatefulWidget {
  final CategoriesPromotionModel promotion;

  const CategoryPromoDetailPage({super.key, required this.promotion});

  @override
  _CategoryPromoDetailPageState createState() =>
      _CategoryPromoDetailPageState();
}

class _CategoryPromoDetailPageState extends State<CategoryPromoDetailPage> {
  final RegisterToPromotionService _registerService =
      RegisterToPromotionService();
  bool _isLoading = false;
  int custserial = 0;

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      custserial = prefs.getInt('serial') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> _registerToPromo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _registerService.registerToPromo(
        custserial,
        widget.promotion.promotionDetails[0].promotionCode,
        widget.promotion.serial,
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final success = decoded['success'] == true;
        final message = decoded['message'] ?? 'No message provided';

        Get.snackbar(
          success ? "Success" : "Failed",
          message.toString(),
          duration: const Duration(seconds: 5),
          backgroundColor: success ? Colors.green : Colors.red,
          colorText: Colors.white,
          mainButton: TextButton(
            onPressed: () {
              Get.closeCurrentSnackbar();
            },
            child: const Icon(Icons.close, color: Colors.white),
          ),
        );
      } else {
        Get.snackbar(
          "Error",
          response.body,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          mainButton: TextButton(
            onPressed: () {
              Get.closeCurrentSnackbar();
            },
            child: const Icon(Icons.close, color: Colors.white),
          ),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () {
            Get.closeCurrentSnackbar();
          },
          child: const Icon(Icons.close, color: Colors.white),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: LogoRow(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: widget.promotion.imagePath != null ||
                      widget.promotion.imagePath.isEmpty
                  ? Image.asset("assets/images/logo.png")
                  : Image.network(widget.promotion.imagePath),
            ),
            const SizedBox(height: 20),
            Text(
              widget.promotion.eventTopic,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.promotion.eventDescription,
                      style:
                          const TextStyle(fontSize: 18, color: Colors.black)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text("all_card.start_date".tr,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        widget.promotion.startDate.split('T')[0],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text("all_card.end_date".tr,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        widget.promotion.endDate.split('T')[0],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text("promotion_det_page.max_user".tr,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black)),
                      Text("${widget.promotion.maxParticipants}",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black))
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _registerToPromo,
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(primaryColor),
                  ),
                  child: _isLoading
                      ? const LoadingScreen()
                      : Text("all_card.apply_btn".tr,
                          style: const TextStyle(
                              color: btntxtColors, fontSize: 20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
