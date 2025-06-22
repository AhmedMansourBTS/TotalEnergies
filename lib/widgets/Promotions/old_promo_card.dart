import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/screens/loading_screen.dart';

class OldPromoCard extends StatefulWidget {
  final int? serial;
  final String imagepath;
  final String title;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final IconData? icon;
  final int? total;
  final int? used;
  final VoidCallback onTap;
  final String? promodet;

  // You can control heights here easily
  final double cardHeight;
  final double imageFlex;
  final double descriptionFlex;

  const OldPromoCard({
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
    required this.onTap,
    this.promodet,
    this.cardHeight = 400, // default card height
    this.imageFlex = 1, // default ratio for image
    this.descriptionFlex = 1, // default ratio for description
  });

  @override
  _OldPromoCardState createState() => _OldPromoCardState();
}

final String baseUrl = "http://92.204.139.204:4335";

class _OldPromoCardState extends State<OldPromoCard> {
  Widget imageWidget(String imageUrl) {
    imageUrl = imageUrl.replaceAll("\\", "/");
    print('$baseUrl$imageUrl');
    return Image.network(
      '$baseUrl/$imageUrl',
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: LoadingScreen());
      },
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/logo.png',
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
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: widget.cardHeight, // Fixed card height
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
                // 🔵 Fixed height for the image
                SizedBox(
                  height: 200, // 🔥 Fixed image height
                  width: double.infinity,
                  child: imageWidget(widget.imagepath),
                ),
                // 🟠 Remaining space for description
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, // ✨ Distribute contents equally
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
                        if (widget.startDate != null &&
                            widget.endDate != null) ...[
                          Text(
                            "Start Date: ${widget.startDate.toString().split(' ')[0]}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "End Date: ${widget.endDate.toString().split(' ')[0]}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Used times:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.used ?? 0} / ${widget.total ?? 0}",
                                textAlign: TextAlign.end,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
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
