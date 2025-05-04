// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/curr_promo_model.dart';
// import 'package:total_energies/screens/Promotions/qr_screen.dart';
// import 'package:total_energies/widgets/Promotions/activity_indicator.dart';
// import 'package:total_energies/widgets/global/app_bar_logos.dart';
// import 'package:total_energies/widgets/stations/maps.dart';
// import 'package:total_energies/widgets/withService/custStationDrpDwn.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class RedeemPromoDetailsScreen extends StatefulWidget {
//   final CurrPromoModel promotion;

//   const RedeemPromoDetailsScreen({super.key, required this.promotion});

//   @override
//   _RedeemPromoDetailsScreenState createState() =>
//       _RedeemPromoDetailsScreenState();
// }

// class _RedeemPromoDetailsScreenState extends State<RedeemPromoDetailsScreen> {
//   int custserial = 0;
//   int? selectedStation;
//   String? selectedStationAddressUrl;

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
//         title: LogoRow(),
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
//                   Row(
//                     children: [
//                       Text(
//                         "all_card.start_date".tr,
//                         style: const TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         widget.promotion.startDate.toString().split(' ')[0],
//                         style: const TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Text(
//                         "all_card.end_date".tr,
//                         style: const TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         widget.promotion.endDate.toString().split(' ')[0],
//                         style: const TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                       )
//                     ],
//                   ),
//                   ActivityIndicator(
//                     left: widget.promotion.remainingUsage ?? 0,
//                     total: widget.promotion.qrMaxUsage ?? 0,
//                     title: 'promotion_det_page.activity'.tr,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               "Choose Station to use the promotion",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             StationsDropdown(
//               stations: widget.promotion.stations,
//               stationAddresses: widget.promotion.stationAddresses,
//               selectedStation: selectedStation,
//               onChanged: (stationSerial, stationAddress) {
//                 setState(() {
//                   selectedStation = stationSerial;
//                   selectedStationAddressUrl = stationAddress;
//                 });
//                 print("Selected station: $stationSerial");
//                 print("Selected address: $stationAddress");
//               },
//             ),
//             const SizedBox(height: 20),
//             Center(
//               child: OpenMapLinkButton(
//                 label: 'Get station directions',
//                 mapUrl: selectedStationAddressUrl ?? '',
//               ),
//             ),
//             const SizedBox(height: 20),
//             Center(
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if ((widget.promotion.remainingUsage) == 0) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text(
//                             'You have reached the maximum number of redemptions.',
//                           ),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                       return;
//                     }
//                     if (selectedStation == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text(
//                             'You must choose a station first.',
//                           ),
//                           backgroundColor: Colors.orange,
//                         ),
//                       );
//                       return;
//                     }
//                     // If everything is okay
//                     Get.to(() => QRPage(
//                           customerId: custserial,
//                           eventId: widget.promotion.serial,
//                         ));
//                   },
//                   style: ButtonStyle(
//                     backgroundColor: const WidgetStatePropertyAll(primaryColor),
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
import 'package:geolocator/geolocator.dart'; // Import geolocator
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/curr_promo_model.dart';
import 'package:total_energies/screens/Promotions/qr_screen.dart';
import 'package:total_energies/widgets/Promotions/activity_indicator.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';
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
  String? selectedStationAddressUrl;
  double deviceLatitude = 0.0; // For storing device latitude
  double deviceLongitude = 0.0; // For storing device longitude
  double stationLatitude =
      37.7749; // Demo latitude (replace with real station latitude)
  double stationLongitude =
      -122.4194; // Demo longitude (replace with real station longitude)
  double rangeInMeters = 1000.0; // Demo range (1 km)

  // Method to load user data
  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      custserial = prefs.getInt('serial') ?? 0;
    });
  }

  // Method to check if the device is within range of the station
  Future<void> checkLocation() async {
    // Get the current device location
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location services are disabled.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission denied.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permissions are permanently denied.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      deviceLatitude = position.latitude;
      deviceLongitude = position.longitude;
    });

    // Calculate the distance between device and station
    double distance = Geolocator.distanceBetween(
      deviceLatitude,
      deviceLongitude,
      stationLatitude,
      stationLongitude,
    );

    if (distance <= rangeInMeters) {
      // Within range
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are within range of the station.'),
          backgroundColor: Colors.green,
        ),
      );
      // Proceed with redemption
      Get.to(() => QRPage(
            customerId: custserial,
            eventId: widget.promotion.serial,
          ));
    } else {
      // Out of range
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are out of range of the station.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
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
        title: LogoRow(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
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
            StationsDropdown(
              stations: widget.promotion.stations,
              stationAddresses: widget.promotion.stationAddresses,
              selectedStation: selectedStation,
              onChanged: (stationSerial, stationAddress) {
                setState(() {
                  selectedStation = stationSerial;
                  selectedStationAddressUrl = stationAddress;
                });
                print("Selected station: $stationSerial");
                print("Selected address: $stationAddress");
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: OpenMapLinkButton(
                label: 'Get station directions',
                mapUrl: selectedStationAddressUrl ?? '',
              ),
            ),
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
                            'You have reached the maximum number of redemptions.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    if (selectedStation == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'You must choose a station first.',
                          ),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }
                    // Trigger the location check
                    checkLocation();
                  },
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll(primaryColor),
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
