import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:total_energies/core/constant/colors.dart';

class AllPromoCard extends StatefulWidget {
  final int? serial;
  final String imagepath;
  final String title;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final IconData? icon;
  final int? total;
  final int? used;
  final VoidCallback onTap; // New parameter
  final String? promodet;
  final bool isAvailable;
  final bool isexp;

  const AllPromoCard({
    super.key,
    this.serial,
    required this.imagepath,
    required this.title,
    required this.description,
    this.startDate,
    this.endDate,
    this.icon,
    this.total,
    this.used,
    required this.onTap, // New parameter
    this.promodet,
    this.isAvailable = false,
    this.isexp = false,
  });

  @override
  _AllPromoCardState createState() => _AllPromoCardState();
}

final String baseUrl = "http://92.204.139.204:4335";

class _AllPromoCardState extends State<AllPromoCard> {
  double cardHeight = 400; // You can make this dynamic if you want

  Widget imageWidget(String imageUrl) {
    imageUrl = imageUrl.replaceAll("\\", "/");
    print('$baseUrl$imageUrl');
    return Image.network(
      '$baseUrl/$imageUrl',
      // 'http://92.204.139.204:4335//Event//1073//Profile.Jpg',
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
            child: CircularProgressIndicator()); // Show loader while loading
      },
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/logo.png', // Fallback image
          width: double.infinity,
          fit: BoxFit.cover,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: cardHeight, // Example: 400
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Card(
          color: Colors.grey,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              children: [
                // 🔵 Fixed height for image
                SizedBox(
                  height: 250,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                    child: Stack(
                      children: [
                        imageWidget(widget.imagepath),
                        if (!widget.isAvailable || !widget.isexp)
                          Positioned.fill(
                            child: Container(
                              color: const Color.fromARGB(110, 0, 0, 0),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // 🟠 Remaining space for description
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, // ✨ Distribute content equally
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.description,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "all_card.start_date".tr,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.startDate
                                              ?.toString()
                                              .split(' ')[0] ??
                                          '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "all_card.end_date".tr,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.endDate
                                              ?.toString()
                                              .split(' ')[0] ??
                                          '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (!widget.isAvailable || !widget.isexp)
                              const Icon(Icons.check_circle,
                                  color: Colors.lightGreen, size: 30),
                            if (widget.isAvailable && widget.isexp)
                              Expanded(
                                child: Text(
                                  "all_card.apply".tr,
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
