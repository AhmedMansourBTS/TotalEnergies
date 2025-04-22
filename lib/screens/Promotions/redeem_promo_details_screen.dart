// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/promotions_model.dart';
// import 'package:total_energies/screens/Promotions/qr_screen.dart';
// import 'package:total_energies/widgets/Promotions/activity_indicator.dart';
// import 'package:total_energies/widgets/withService/custStationDrpDwn.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class RedeemPromoDetailsScreen extends StatefulWidget {
//   final PromotionsModel promotion;

//   const RedeemPromoDetailsScreen({super.key, required this.promotion});

//   @override
//   _RedeemPromoDetailsScreenState createState() =>
//       _RedeemPromoDetailsScreenState();
// }

// class _RedeemPromoDetailsScreenState extends State<RedeemPromoDetailsScreen> {
//   int custserial = 0;
//   int? selectedStation;

//   void loadUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       custserial = prefs.getInt('serial') ?? 0;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadUserData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         title: Row(
//           children: [
//             SizedBox(
//               height: kToolbarHeight - 25,
//               child: Image.asset(
//                 "assets/images/logo1.1.png",
//                 fit: BoxFit.contain,
//               ),
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             SizedBox(
//               height: kToolbarHeight - 25,
//               child: Image.asset(
//                 "assets/images/ADNOC logo1.1.png",
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               // child: widget.promotion.imagePath == null ||
//               //         widget.promotion.imagePath == ''
//               //     ? Image.network(widget.promotion.imagePath ?? '')
//               //     : Image.asset("assets/images/logo.png"),
//               child: widget.promotion.imagePath == null ||
//                       widget.promotion.imagePath == ''
//                   ? Image.asset("assets/images/logo.png")
//                   : Image.network(widget.promotion.imagePath ?? ''),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               widget.promotion.eventTopic,
//               style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: primaryColor),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(widget.promotion.eventEnDescription,
//                       style:
//                           const TextStyle(fontSize: 18, color: Colors.black)),
//                   const SizedBox(height: 10),
//                   Text(
//                       "Start Date: ${widget.promotion.startDate.toString().split(' ')[0]}",
//                       style:
//                           const TextStyle(fontSize: 18, color: Colors.black)),
//                   const SizedBox(height: 10),
//                   Text(
//                       'End date: ${widget.promotion.endDate.toString().split(' ')[0]}',
//                       style:
//                           const TextStyle(fontSize: 18, color: Colors.black)),
//                   ActivityIndicator(
//                       completed: widget.promotion.remainingUsage ?? 0,
//                       total: widget.promotion.qrMaxUsage ?? 0),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               "Choose Station to use the promotion",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             // StationDropdown(
//             //   onChanged: (selectedStation) {
//             //     print("Selected Station: ${selectedStation?.stationName}");
//             //   },
//             // ),
//             StationsDropdown(
//               selectedStation: selectedStation,
//               onChanged: (value) {
//                 setState(() {
//                   selectedStation = value;
//                 });
//                 print("Selected station: $value");
//               },
//             ),
//             const SizedBox(height: 20),
//             Center(
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Get.to(() => QRPage());
//                     Get.to(() => QRPage(
//                         customerId: custserial,
//                         eventId: widget.promotion.serial));
//                   },
//                   style: ButtonStyle(
//                     backgroundColor: WidgetStatePropertyAll(primaryColor),
//                   ),
//                   child: Text(
//                     'btn.promotions_det_pag_redeem'.tr,
//                     style: const TextStyle(color: btntxtColors, fontSize: 20),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/curr_promo_model.dart';
import 'package:total_energies/screens/Promotions/qr_screen.dart';
import 'package:total_energies/widgets/Promotions/activity_indicator.dart';
import 'package:total_energies/widgets/stations/maps.dart';
import 'package:total_energies/widgets/withService/custStationDrpDwn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RedeemPromoDetailsScreen extends StatefulWidget {
  final CurrPromoModel promotion;

  const RedeemPromoDetailsScreen({super.key, required this.promotion});

  @override
  _RedeemPromoDetailsScreenState createState() =>
      _RedeemPromoDetailsScreenState();
}

class _RedeemPromoDetailsScreenState extends State<RedeemPromoDetailsScreen> {
  int custserial = 0;
  int? selectedStation;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            SizedBox(
              height: kToolbarHeight - 25,
              child: Image.asset(
                "assets/images/logo1.1.png",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              height: kToolbarHeight - 25,
              child: Image.asset(
                "assets/images/ADNOC logo1.1.png",
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              // child: widget.promotion.imagePath == null ||
              //         widget.promotion.imagePath == ''
              //     ? Image.network(widget.promotion.imagePath ?? '')
              //     : Image.asset("assets/images/logo.png"),
              child: widget.promotion.imagePath == null ||
                      widget.promotion.imagePath == ''
                  ? Image.asset("assets/images/logo.png")
                  : Image.network(widget.promotion.imagePath ?? ''),
            ),
            const SizedBox(height: 20),
            Text(
              widget.promotion.eventTopic,
              style: TextStyle(
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
                  Text(widget.promotion.eventEnDescription,
                      style:
                          const TextStyle(fontSize: 18, color: Colors.black)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "all_card.start_date".tr,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.promotion.startDate.toString().split(' ')[0],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "all_card.end_date".tr,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.promotion.endDate.toString().split(' ')[0],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  ActivityIndicator(
                    left: widget.promotion.remainingUsage ?? 0,
                    total: widget.promotion.qrMaxUsage ?? 0,
                    title: 'promotion_det_page.activity'.tr,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Choose Station to use the promotion",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // StationDropdown(
            //   onChanged: (selectedStation) {
            //     print("Selected Station: ${selectedStation?.stationName}");
            //   },
            // ),
            StationsDropdown(
              selectedStation: selectedStation,
              onChanged: (value) {
                setState(() {
                  selectedStation = value;
                });
                print("Selected station: $value");
              },
            ),
            // const SizedBox(height: 20),
            // OpenMapLinkButton(
            //   label: 'Get station directions',
            //   mapUrl: selectedStation?.stationAdress ?? '',
            // ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if ((widget.promotion.remainingUsage) == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'You have reached the maximum number of redemptions.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    Get.to(() => QRPage(
                          customerId: custserial,
                          eventId: widget.promotion.serial,
                        ));
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(primaryColor),
                  ),
                  child: Text(
                    'btn.promotions_det_pag_redeem'.tr,
                    style: const TextStyle(color: btntxtColors, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
