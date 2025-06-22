import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/screens/loading_screen.dart';

class CategPromoCard extends StatefulWidget {
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
  final bool isBlocked;

  const CategPromoCard({
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
    this.isBlocked = false,
  });

  @override
  _CategPromoCardState createState() => _CategPromoCardState();
}

final String baseUrl = "http://92.204.139.204:4335";

class _CategPromoCardState extends State<CategPromoCard> {
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
      onTap: widget.isBlocked ? null : widget.onTap,
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
                // Fixed height for the image
                SizedBox(
                  height: 250,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                    child: Stack(
                      children: [
                        imageWidget(widget.imagepath),
                        Positioned.fill(
                          child: widget.isBlocked
                              ? Container(
                                  color: const Color.fromARGB(110, 0, 0, 0),
                                )
                              : Container(
                                  color: Colors.transparent,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Remaining space for description
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
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: widget.isBlocked
                                    ? const Icon(Icons.check_circle,
                                        color: Colors.green, size: 30)
                                    : Text(
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

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/services/curr_promo_service.dart';
// import 'package:total_energies/services/get_exp_promo_service.dart';

// class CategPromoCard extends StatefulWidget {
//   final int? serial;
//   final String imagepath;
//   final String title;
//   final String description;
//   final DateTime? startDate;
//   final DateTime? endDate;
//   final IconData? icon;
//   final int? total;
//   final int? used;
//   final VoidCallback onTap;
//   final String? promodet;

//   final double cardHeight;
//   final double imageFlex;
//   final double descriptionFlex;

//   const CategPromoCard({
//     super.key,
//     this.serial,
//     required this.imagepath,
//     required this.title,
//     required this.description,
//     this.startDate,
//     this.endDate,
//     this.icon,
//     this.total,
//     this.used,
//     required this.onTap,
//     this.promodet,
//     this.cardHeight = 400,
//     this.imageFlex = 1,
//     this.descriptionFlex = 1,
//   });

//   @override
//   _CategPromoCardState createState() => _CategPromoCardState();
// }

// final String baseUrl = "http://92.204.139.204:4335";

// class _CategPromoCardState extends State<CategPromoCard> {
//   bool isBlocked = false;

//   @override
//   void initState() {
//     // super.initState();
//     checkIfBlocked();
//   }

//   void checkIfBlocked() async {
//     if (widget.serial == null) return;

//     final currPromos = await GetCurrPromoService().getCurrPromotion();
//     final expPromos = await GetExpPromoService().getExpPromotions();

//     // final currSerials =
//     //     currPromos.map((e) => int.tryParse(e.serial.toString())).toSet();
//     // final expSerials = expPromos.map((e) => e.serial).toSet();

//     final currSerials = currPromos
//         .where((e) => e.serial != null)
//         .map((e) => e.serial.toString().trim())
//         .toSet();

//     final expSerials = expPromos
//         .where((e) => e.serial != null)
//         .map((e) => e.serial.toString().trim())
//         .toSet();

//     final widgetSerial = widget.serial.toString().trim();

//     if (currSerials.contains(widgetSerial) ||
//         expSerials.contains(widgetSerial)) {
//       setState(() {
//         isBlocked = true;
//       });
//     }
//   }

//   Widget imageWidget(String imageUrl) {
//     imageUrl = imageUrl.replaceAll("\\", "/");
//     return Image.network(
//       '$baseUrl/$imageUrl',
//       width: double.infinity,
//       fit: BoxFit.cover,
//       loadingBuilder: (context, child, loadingProgress) {
//         if (loadingProgress == null) return child;
//         return const Center(child: CircularProgressIndicator());
//       },
//       errorBuilder: (context, error, stackTrace) {
//         return Image.asset(
//           'assets/images/logo.png',
//           width: double.infinity,
//           fit: BoxFit.cover,
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: isBlocked ? null : widget.onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 10),
//         height: widget.cardHeight,
//         child: Card(
//           color: isBlocked ? Colors.grey[400] : Colors.white,
//           elevation: 5,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 200,
//                   width: double.infinity,
//                   child: imageWidget(widget.imagepath),
//                 ),
//                 Expanded(
//                   child: Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.title,
//                           style: const TextStyle(
//                             color: primaryColor,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         Text(
//                           widget.description,
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       "all_card.start_date".tr,
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 4),
//                                     Text(
//                                       widget.startDate
//                                               ?.toString()
//                                               .split(' ')[0] ??
//                                           '',
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text(
//                                       "all_card.end_date".tr,
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 4),
//                                     Text(
//                                       widget.endDate
//                                               ?.toString()
//                                               .split(' ')[0] ??
//                                           '',
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             Expanded(
//                               child: isBlocked
//                                   ? const Icon(Icons.check_circle,
//                                       color: Colors.green, size: 24)
//                                   : Text(
//                                       "all_card.apply".tr,
//                                       textAlign: TextAlign.end,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: const TextStyle(
//                                         color: primaryColor,
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
