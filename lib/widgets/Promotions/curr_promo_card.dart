// import 'package:flutter/material.dart';
// import 'package:get/get_utils/get_utils.dart';
// import 'package:total_energies/core/constant/colors.dart';

// class CurrPromoCard extends StatefulWidget {
//   final int? serial;
//   final String? imagepath;
//   final String title;
//   final String description;
//   final DateTime? startDate;
//   final DateTime? endDate;
//   final IconData? icon;
//   final int? total;
//   final int? remained;
//   final VoidCallback onTap; // New parameter
//   final String? promodet;

//   const CurrPromoCard({
//     super.key,
//     this.serial,
//     required this.imagepath,
//     required this.title,
//     required this.description,
//     this.startDate,
//     this.endDate,
//     this.icon,
//     this.total,
//     this.remained,
//     required this.onTap, // New parameter
//     this.promodet,
//   });

//   @override
//   _CurrPromoCardState createState() => _CurrPromoCardState();
// }

// final String baseUrl = "https://www.besttopsystems.net:4335";

// class _CurrPromoCardState extends State<CurrPromoCard> {
//   Widget imageWidget(String imageUrl) {
//     imageUrl = imageUrl.replaceAll("\\", "/");
//     print('$baseUrl$imageUrl');
//     return Image.network(
//       '$baseUrl/$imageUrl',
//       // 'http://92.204.139.204:4335//Event//1073//Profile.Jpg',
//       width: double.infinity,
//       height: 350,
//       fit: BoxFit.cover,
//       loadingBuilder: (context, child, loadingProgress) {
//         if (loadingProgress == null) return child;
//         return Center(
//             child: CircularProgressIndicator()); // Show loader while loading
//       },
//       errorBuilder: (context, error, stackTrace) {
//         return Image.asset(
//           'assets/images/logo.png', // Fallback image
//           width: double.infinity,
//           height: 320,
//           fit: BoxFit.cover,
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onTap, // Handle navigation when tapped
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 10),
//         child: Card(
//           color: Colors.grey,
//           elevation: 5,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Stack(
//               children: [
//                 // imageWidget('http://92.204.139.204:4335' + widget.imagepath),
//                 imageWidget(widget.imagepath ?? ''),
//                 // text
//                 Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//                     color: Colors.white,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.title,
//                           style: const TextStyle(
//                             color: primaryColor,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 widget.description,
//                                 style: const TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         Row(
//                           children: [
//                             Text(
//                               "all_card.start_date".tr,
//                               style: const TextStyle(
//                                   fontSize: 14, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               widget.startDate.toString().split(' ')[0],
//                               style: const TextStyle(
//                                   fontSize: 14, fontWeight: FontWeight.bold),
//                             )
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               "all_card.end_date".tr,
//                               style: const TextStyle(
//                                   fontSize: 14, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               widget.endDate.toString().split(' ')[0],
//                               style: const TextStyle(
//                                   fontSize: 14, fontWeight: FontWeight.bold),
//                             )
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               'curr_card.activity'.tr,
//                               style: const TextStyle(
//                                   fontSize: 14, fontWeight: FontWeight.bold),
//                             ),
//                             Expanded(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     "${widget.remained} / ${widget.total}",
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         )
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

import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:total_energies/core/constant/colors.dart';

class CurrPromoCard extends StatefulWidget {
  final int? serial;
  final String? imagepath;
  final String title;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final IconData? icon;
  final int? total;
  final int? remained;
  final VoidCallback onTap; // New parameter
  final String? promodet;

  const CurrPromoCard({
    super.key,
    this.serial,
    required this.imagepath,
    required this.title,
    required this.description,
    this.startDate,
    this.endDate,
    this.icon,
    this.total,
    this.remained,
    required this.onTap, // New parameter
    this.promodet,
  });

  @override
  _CurrPromoCardState createState() => _CurrPromoCardState();
}

final String baseUrl = "https://www.besttopsystems.net:4335";

class _CurrPromoCardState extends State<CurrPromoCard> {
  double cardHeight = 400; // You can make this dynamic if you want

  Widget imageWidget(String imageUrl) {
    imageUrl = imageUrl.replaceAll("\\", "/");
    return Image.network(
      '$baseUrl/$imageUrl',
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
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

  // @override
  // Widget build(BuildContext context) {
  //   return GestureDetector(
  //     onTap: widget.onTap,
  //     child: Container(
  //       height: cardHeight,
  //       margin: const EdgeInsets.symmetric(vertical: 10),
  //       child: Card(
  //         color: Colors.grey,
  //         elevation: 5,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(10),
  //           child: Column(
  //             children: [
  //               Expanded(
  //                 flex: 6, // 60% for image
  //                 child: widget.imagepath != null
  //                     ? imageWidget(widget.imagepath!)
  //                     : Image.asset('assets/images/logo.png',
  //                         fit: BoxFit.cover),
  //               ),
  //               Expanded(
  //                 flex: 4, // 40% for description
  //                 child: Container(
  //                   width: double.infinity,
  //                   color: Colors.white,
  //                   padding:
  //                       const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         widget.title,
  //                         style: const TextStyle(
  //                           color: primaryColor,
  //                           fontSize: 20,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                         maxLines: 1,
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                       const SizedBox(height: 4),
  //                       Expanded(
  //                         child: Text(
  //                           widget.description,
  //                           style: const TextStyle(
  //                             color: Colors.black,
  //                             fontSize: 14,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                           maxLines: 2,
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 4),
  //                       Row(
  //                         children: [
  //                           Text(
  //                             "all_card.start_date".tr,
  //                             style: const TextStyle(
  //                                 fontSize: 12, fontWeight: FontWeight.bold),
  //                           ),
  //                           const SizedBox(width: 5),
  //                           Text(
  //                             widget.startDate?.toString().split(' ')[0] ?? '',
  //                             style: const TextStyle(
  //                                 fontSize: 12, fontWeight: FontWeight.bold),
  //                           ),
  //                         ],
  //                       ),
  //                       Row(
  //                         children: [
  //                           Text(
  //                             "all_card.end_date".tr,
  //                             style: const TextStyle(
  //                                 fontSize: 12, fontWeight: FontWeight.bold),
  //                           ),
  //                           const SizedBox(width: 5),
  //                           Text(
  //                             widget.endDate?.toString().split(' ')[0] ?? '',
  //                             style: const TextStyle(
  //                                 fontSize: 12, fontWeight: FontWeight.bold),
  //                           ),
  //                         ],
  //                       ),
  //                       const SizedBox(height: 4),
  //                       Row(
  //                         children: [
  //                           Text(
  //                             'curr_card.activity'.tr,
  //                             style: const TextStyle(
  //                                 fontSize: 12, fontWeight: FontWeight.bold),
  //                           ),
  //                           const Spacer(),
  //                           Text(
  //                             "${widget.remained ?? 0} / ${widget.total ?? 0}",
  //                             style: const TextStyle(
  //                                 fontSize: 14, fontWeight: FontWeight.bold),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
                  height: 250, // Set a fixed height
                  width: double.infinity,
                  child: widget.imagepath != null
                      ? imageWidget(widget.imagepath!)
                      : Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                ),
                // 🟠 Remaining space for description
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, // ✨ Distribute contents equally
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
                        // Row(
                        //   children: [
                        //     Text(
                        //       "all_card.start_date".tr,
                        //       style: const TextStyle(
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //     const SizedBox(width: 5),
                        //     Text(
                        //       widget.startDate?.toString().split(' ')[0] ?? '',
                        //       style: const TextStyle(
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // Row(
                        //   children: [
                        //     Text(
                        //       "all_card.end_date".tr,
                        //       style: const TextStyle(
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //     const SizedBox(width: 5),
                        //     Text(
                        //       widget.endDate?.toString().split(' ')[0] ?? '',
                        //       style: const TextStyle(
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Row(
                          children: [
                            Text(
                              'curr_card.activity'.tr,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "${widget.remained ?? 0} / ${widget.total ?? 0}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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
