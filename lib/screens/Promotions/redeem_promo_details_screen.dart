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

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:geolocator/geolocator.dart'; // Import geolocator
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
//   double deviceLatitude = 0.0; // For storing device latitude
//   double deviceLongitude = 0.0; // For storing device longitude
//   double stationLatitude =
//       37.7749; // Demo latitude (replace with real station latitude)
//   double stationLongitude =
//       -122.4194; // Demo longitude (replace with real station longitude)
//   double rangeInMeters = 1000.0; // Demo range (1 km)

//   // Method to load user data
//   void loadUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       custserial = prefs.getInt('serial') ?? 0;
//     });
//   }

//   // Method to check if the device is within range of the station
//   Future<void> checkLocation() async {
//     // Get the current device location
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Location services are disabled.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Location permission denied.'),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Location permissions are permanently denied.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     setState(() {
//       deviceLatitude = position.latitude;
//       deviceLongitude = position.longitude;
//     });

//     // Calculate the distance between device and station
//     double distance = Geolocator.distanceBetween(
//       deviceLatitude,
//       deviceLongitude,
//       stationLatitude,
//       stationLongitude,
//     );

//     if (distance <= rangeInMeters) {
//       // Within range
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('You are within range of the station.'),
//           backgroundColor: Colors.green,
//         ),
//       );
//       // Proceed with redemption
//       Get.to(() => QRPage(
//             customerId: custserial,
//             eventId: widget.promotion.serial,
//           ));
//     } else {
//       // Out of range
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('You are out of range of the station.'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//     }
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
//             // StationsDropdown(
//             //   stations: widget.promotion.stations,
//             //   stationAddresses: widget.promotion.stationAddresses,
//             //   selectedStation: selectedStation,
//             //   onChanged: (stationSerial, stationAddress) {
//             //     setState(() {
//             //       selectedStation = stationSerial;
//             //       selectedStationAddressUrl = stationAddress;
//             //     });
//             //     print("Selected station: $stationSerial");
//             //     print("Selected address: $stationAddress");
//             //   },
//             // ),
//             // StationsDropdown(
//             //   stationSerials:
//             //       widget.promotion.stations, // These are the serials you pass
//             //       selectedStation: selectedStation,
//             //   onChanged: (stationSerial,String? selectedStationAddressUrl) {
//             //     setState(() {
//             //       selectedStation = stationSerial;
//             //       selectedStationAddressUrl = selectedStationAddressUrl;
//             //     });
//             //   },
//             // ),

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
//                     // Trigger the location check
//                     checkLocation();
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

// works wellllllllll
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/curr_promo_model.dart';
// import 'package:total_energies/models/stations_model.dart';
// import 'package:total_energies/screens/Promotions/qr_screen.dart';
// import 'package:total_energies/widgets/Promotions/activity_indicator.dart';
// import 'package:total_energies/widgets/global/app_bar_logos.dart';
// import 'package:total_energies/widgets/withService/custStationDrpDwn.dart';
// import 'package:total_energies/widgets/stations/maps.dart'; // For OpenMapLinkButton

// class RedeemPromoDetailsScreen extends StatefulWidget {
//   final CurrPromoModel promotion;

//   const RedeemPromoDetailsScreen({super.key, required this.promotion});

//   @override
//   State<RedeemPromoDetailsScreen> createState() =>
//       _RedeemPromoDetailsScreenState();
// }

// class _RedeemPromoDetailsScreenState extends State<RedeemPromoDetailsScreen> {
//   int custserial = 0;
//   StationModel? selectedStation;
//   String? selectedStationAddressUrl;

//   @override
//   void initState() {
//     super.initState();
//     loadUserData();
//   }

//   void loadUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       custserial = prefs.getInt('serial') ?? 0;
//     });
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
//               child: widget.promotion.imagePath == null ||
//                       widget.promotion.imagePath!.isEmpty
//                   ? Image.asset("assets/images/logo.png")
//                   : Image.network(widget.promotion.imagePath!),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               widget.promotion.eventTopic,
//               style: const TextStyle(
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
//                       Text("all_card.start_date".tr,
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold)),
//                       const SizedBox(width: 10),
//                       Text(widget.promotion.startDate.toString().split(' ')[0],
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold))
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Text("all_card.end_date".tr,
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold)),
//                       const SizedBox(width: 10),
//                       Text(widget.promotion.endDate.toString().split(' ')[0],
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold))
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
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             StationsDropdown(
//               stationSerials: widget.promotion.stations,
//               selectedStation: selectedStation,
//               onChanged: (StationModel? station, String? selectedAddress) {
//                 setState(() {
//                   selectedStation = station;
//                   selectedStationAddressUrl = selectedAddress;
//                 });
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
//                     if ((widget.promotion.remainingUsage ?? 0) == 0) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text(
//                               'You have reached the maximum number of redemptions.'),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                       return;
//                     }

//                     if (selectedStation == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('You must choose a station first.'),
//                           backgroundColor: Colors.orange,
//                         ),
//                       );
//                       return;
//                     }

//                     Get.to(() => QRPage(
//                           customerId: custserial,
//                           eventId: widget.promotion.serial,
//                         ));
//                   },
//                   style: const ButtonStyle(
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

// Works well with location check
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/curr_promo_model.dart';
// import 'package:total_energies/models/stations_model.dart';
// import 'package:total_energies/screens/Promotions/qr_screen.dart';
// import 'package:total_energies/services/station_service.dart';
// import 'package:total_energies/widgets/Promotions/activity_indicator.dart';
// import 'package:total_energies/widgets/global/app_bar_logos.dart';
// import 'package:total_energies/widgets/withService/custStationDrpDwn.dart';
// import 'package:total_energies/widgets/stations/maps.dart';
// import 'package:geolocator/geolocator.dart'; // New import

// class RedeemPromoDetailsScreen extends StatefulWidget {
//   final CurrPromoModel promotion;

//   const RedeemPromoDetailsScreen({super.key, required this.promotion});

//   @override
//   State<RedeemPromoDetailsScreen> createState() =>
//       _RedeemPromoDetailsScreenState();
// }

// class _RedeemPromoDetailsScreenState extends State<RedeemPromoDetailsScreen> {
//   int custserial = 0;
//   StationModel? selectedStation;
//   String? selectedStationAddressUrl;

// // fatya
//   List<StationModel> nearbyStations = [];
//   Position? userPosition;

//   @override
//   void initState() {
//     super.initState();
//     loadUserData();
//   }

//   void loadUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       custserial = prefs.getInt('serial') ?? 0;
//     });
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
//               child: widget.promotion.imagePath == null ||
//                       widget.promotion.imagePath!.isEmpty
//                   ? Image.asset("assets/images/logo.png")
//                   : Image.network(widget.promotion.imagePath!),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               widget.promotion.eventTopic,
//               style: const TextStyle(
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
//                       Text("all_card.start_date".tr,
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold)),
//                       const SizedBox(width: 10),
//                       Text(widget.promotion.startDate.toString().split(' ')[0],
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold))
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Text("all_card.end_date".tr,
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold)),
//                       const SizedBox(width: 10),
//                       Text(widget.promotion.endDate.toString().split(' ')[0],
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold))
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
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             StationsDropdown(
//               stationSerials: widget.promotion.stations,
//               selectedStation: selectedStation,
//               onChanged: (StationModel? station, String? selectedAddress) {
//                 setState(() {
//                   selectedStation = station;
//                   selectedStationAddressUrl = selectedAddress;
//                 });
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
//                   onPressed: () async {
//                     if ((widget.promotion.remainingUsage ?? 0) == 0) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text(
//                               'You have reached the maximum number of redemptions.'),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                       return;
//                     }

//                     if (selectedStation == null ||
//                         selectedStationAddressUrl == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('You must choose a station first.'),
//                           backgroundColor: Colors.orange,
//                         ),
//                       );
//                       return;
//                     }

//                     // Step 1: Location permission and service
//                     bool serviceEnabled =
//                         await Geolocator.isLocationServiceEnabled();
//                     LocationPermission permission =
//                         await Geolocator.checkPermission();
//                     if (permission == LocationPermission.denied) {
//                       permission = await Geolocator.requestPermission();
//                     }

//                     if (!serviceEnabled ||
//                         permission == LocationPermission.denied ||
//                         permission == LocationPermission.deniedForever) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text(
//                               'Location permission not granted or service is off.'),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                       return;
//                     }

//                     // Step 2: Get user location
//                     Position userPos = await Geolocator.getCurrentPosition(
//                         desiredAccuracy: LocationAccuracy.high);

//                     // Print user's lat and long
//                     print(
//                         "User's Latitude: ${userPos.latitude}, User's Longitude: ${userPos.longitude}");

//                     // Step 3: Extract lat/lng from station URL
//                     // RegExp regex = RegExp(r'loc:([0-9\.-]+),([0-9\.-]+)');
//                     RegExp regex = RegExp(r'([0-9\.-]+),([0-9\.-]+)');
//                     Match? match = regex.firstMatch(selectedStationAddressUrl!);

//                     if (match == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Invalid station location link.'),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                       return;
//                     }

//                     double stationLat = double.parse(match.group(1)!);
//                     double stationLng = double.parse(match.group(2)!);

//                     // Print station's lat and long
//                     print(
//                         "Station's Latitude: $stationLat, Station's Longitude: $stationLng");

//                     // Step 4: Compare distance
//                     double distanceInMeters = Geolocator.distanceBetween(
//                       userPos.latitude,
//                       userPos.longitude,
//                       stationLat,
//                       stationLng,
//                     );

//                     const allowedRange = 1000; // in meters

//                     // Print distance between user and station
//                     print(
//                         "Distance between user and station: $distanceInMeters meters");

//                     if (distanceInMeters <= allowedRange) {
//                       Get.to(() => QRPage(
//                             customerId: custserial,
//                             eventId: widget.promotion.serial,
//                           ));
//                     } else {
//                       // Show a message with the distance if out of range
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                               'You are out of range by ${((distanceInMeters - allowedRange) / 1000).toStringAsFixed(2)} kilometers.'),
//                           backgroundColor: Colors.red,
//                         ),
//                         // SnackBar(
//                         //   content: Text(
//                         //       'You are out of range by ${(distanceInMeters - allowedRange).toInt()} meters.'),
//                         //   backgroundColor: Colors.red,
//                         // ),
//                       );
//                     }
//                   },
//                   style: const ButtonStyle(
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

// tamammmmm
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/curr_promo_model.dart';
// import 'package:total_energies/models/stations_model.dart';
// import 'package:total_energies/screens/Promotions/qr_screen.dart';
// import 'package:total_energies/screens/loading_screen.dart';
// import 'package:total_energies/services/station_service.dart';
// import 'package:total_energies/widgets/Promotions/activity_indicator.dart';
// import 'package:total_energies/widgets/global/app_bar_logos.dart';
// import 'package:total_energies/widgets/stations/maps.dart';
// import 'package:geolocator/geolocator.dart';

// class RedeemPromoDetailsScreen extends StatefulWidget {
//   final CurrPromoModel promotion;

//   const RedeemPromoDetailsScreen({super.key, required this.promotion});

//   @override
//   State<RedeemPromoDetailsScreen> createState() =>
//       _RedeemPromoDetailsScreenState();
// }

// class _RedeemPromoDetailsScreenState extends State<RedeemPromoDetailsScreen> {
//   int custserial = 0;
//   StationModel? selectedStation;
//   String? selectedStationAddressUrl;

//   List<StationModel> nearbyStations = [];
//   bool isLoadingStations = true;

//   @override
//   void initState() {
//     super.initState();
//     loadUserDataAndStations();
//   }

//   Future<void> loadUserDataAndStations() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int userSerial = prefs.getInt('serial') ?? 0;

//     // Check and request location permission
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }

//     if (!serviceEnabled ||
//         permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Location permission denied or service is off.'),
//         backgroundColor: Colors.red,
//       ));
//       return;
//     }

//     Position userPos = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     // Fetch all stations
//     StationService stationService = StationService();
//     List<StationModel> allStations = await stationService.getStations();

//     // Filter by station serials in promotion
//     List<StationModel> filtered = allStations
//         .where((s) => widget.promotion.stations.contains(s.serial))
//         .toList();

//     // Calculate distance to each
//     for (var station in filtered) {
//       if (station.stationAdress != null) {
//         final match = RegExp(r'([0-9\.-]+),([0-9\.-]+)')
//             .firstMatch(station.stationAdress!);
//         if (match != null) {
//           double lat = double.tryParse(match.group(1) ?? '') ?? 0;
//           double lng = double.tryParse(match.group(2) ?? '') ?? 0;
//           double dist = Geolocator.distanceBetween(
//               userPos.latitude, userPos.longitude, lat, lng);
//           station.distance = dist;
//         } else {
//           station.distance = double.infinity;
//         }
//       } else {
//         station.distance = double.infinity; // ADD THIS CASE
//       }
//     }

//     // Sort by distance
//     // filtered.sort((a, b) => a.distance!.compareTo(b.distance!));
//     filtered.sort((a, b) => (a.distance ?? double.infinity)
//         .compareTo(b.distance ?? double.infinity));

//     setState(() {
//       custserial = userSerial;
//       nearbyStations = filtered;
//       isLoadingStations = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         title: LogoRow(),
//       ),
//       body: isLoadingStations
//           ? const Center(child: LoadingScreen())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Center(
//                   //   child: widget.promotion.imagePath == null ||
//                   //           widget.promotion.imagePath!.isEmpty
//                   //       ? Image.network(widget.promotion.imagePath!)
//                   //       : Image.asset("assets/images/logo.png"),
//                   // ),
//                   Center(
//                     child: Image.asset("assets/images/logo.png"),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(widget.promotion.eventTopic,
//                       style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: primaryColor)),
//                   const SizedBox(height: 20),
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(widget.promotion.eventEnDescription,
//                             style: const TextStyle(
//                                 fontSize: 18, color: Colors.black)),
//                         const SizedBox(height: 10),
//                         Row(
//                           children: [
//                             Text("all_card.start_date".tr,
//                                 style: const TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.bold)),
//                             const SizedBox(width: 10),
//                             Text(
//                                 widget.promotion.startDate
//                                     .toString()
//                                     .split(' ')[0],
//                                 style: const TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.bold))
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           children: [
//                             Text("all_card.end_date".tr,
//                                 style: const TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.bold)),
//                             const SizedBox(width: 10),
//                             Text(
//                                 widget.promotion.endDate
//                                     .toString()
//                                     .split(' ')[0],
//                                 style: const TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.bold))
//                           ],
//                         ),
//                         ActivityIndicator(
//                           left: widget.promotion.remainingUsage,
//                           total: widget.promotion.qrMaxUsage,
//                           title: 'promotion_det_page.activity'.tr,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Text("Choose Nearest Station",
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),

//                   // Nearby station selector
//                   DropdownButton<StationModel>(
//                     isExpanded: true,
//                     value: selectedStation,
//                     hint: const Text("Select nearest station"),
//                     items: nearbyStations.map((station) {
//                       return DropdownMenuItem(
//                         value: station,
//                         child: Text(
//                             "${station.stationName} (${(station.distance! / 1000).toStringAsFixed(2)} km)"),
//                       );
//                     }).toList(),
//                     onChanged: (station) {
//                       setState(() {
//                         selectedStation = station;
//                         selectedStationAddressUrl = station?.stationAdress;
//                       });
//                     },
//                   ),

//                   const SizedBox(height: 20),
//                   Center(
//                     child: OpenMapLinkButton(
//                       label: 'Get station directions',
//                       mapUrl: selectedStationAddressUrl ?? '',
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Center(
//                     child: SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           if ((widget.promotion.remainingUsage) == 0) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text(
//                                     'You have reached the maximum number of redemptions.'),
//                                 backgroundColor: Colors.red,
//                               ),
//                             );
//                             return;
//                           }

//                           if (selectedStation == null ||
//                               selectedStationAddressUrl == null) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content:
//                                     Text('You must choose a station first.'),
//                                 backgroundColor: Colors.orange,
//                               ),
//                             );
//                             return;
//                           }

//                           Position userPos =
//                               await Geolocator.getCurrentPosition(
//                                   desiredAccuracy: LocationAccuracy.high);
//                           RegExp regex = RegExp(r'([0-9\.-]+),([0-9\.-]+)');
//                           Match? match =
//                               regex.firstMatch(selectedStationAddressUrl!);

//                           if (match == null) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                   content:
//                                       Text('Invalid station location link.'),
//                                   backgroundColor: Colors.red),
//                             );
//                             return;
//                           }

//                           double stationLat = double.parse(match.group(1)!);
//                           double stationLng = double.parse(match.group(2)!);
//                           double distanceInMeters = Geolocator.distanceBetween(
//                             userPos.latitude,
//                             userPos.longitude,
//                             stationLat,
//                             stationLng,
//                           );

//                           const allowedRange = 20000; // meters
//                           if (distanceInMeters <= allowedRange) {
//                             Get.to(() => QRPage(
//                                 customerId: custserial,
//                                 eventId: widget.promotion.serial));
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(
//                                     'You are out of range by ${(distanceInMeters / 1000 - allowedRange / 1000).toStringAsFixed(2)} km.'),
//                                 backgroundColor: Colors.red,
//                               ),
//                             );
//                           }
//                         },
//                         style: const ButtonStyle(
//                             backgroundColor:
//                                 WidgetStatePropertyAll(primaryColor)),
//                         child: Text('btn.promotions_det_pag_redeem'.tr,
//                             style: const TextStyle(
//                                 color: btntxtColors, fontSize: 20)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/curr_promo_model.dart';
import 'package:total_energies/models/governorate_model.dart';
import 'package:total_energies/models/stations_model.dart';
import 'package:total_energies/models/city_model.dart';
import 'package:total_energies/screens/Promotions/qr_screen.dart';
import 'package:total_energies/screens/loading_screen.dart';
import 'package:total_energies/services/station_service.dart';
import 'package:total_energies/services/governorate_service.dart';
import 'package:total_energies/services/city_service.dart';
import 'package:total_energies/widgets/Promotions/activity_indicator.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';
import 'package:total_energies/widgets/stations/maps.dart';
import 'package:geolocator/geolocator.dart';

class RedeemPromoDetailsScreen extends StatefulWidget {
  final CurrPromoModel promotion;

  const RedeemPromoDetailsScreen({super.key, required this.promotion});

  @override
  State<RedeemPromoDetailsScreen> createState() =>
      _RedeemPromoDetailsScreenState();
}

class _RedeemPromoDetailsScreenState extends State<RedeemPromoDetailsScreen> {
  int custserial = 0;
  StationModel? selectedStation;
  String? selectedStationAddressUrl;

  List<StationModel> nearbyStations = [];
  List<StationModel> filteredStations = [];
  bool isLoadingStations = true;
  bool isLoadingFilters = true;
  String? filterError;

  List<GovernorateModel> _governorates = [];
  List<CityModel> _cities = [];
  List<CityModel> _filteredCities = [];
  GovernorateModel? _selectedGovernorate;
  CityModel? _selectedCity;

  final GovernorateService _governorateService = GovernorateService();
  final CityService _cityService = CityService();
  final StationService _stationService = StationService();

  @override
  void initState() {
    super.initState();
    loadUserDataAndStations();
    loadFilters();
  }

  Future<void> loadUserDataAndStations() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userSerial = prefs.getInt('serial') ?? 0;

      // Check and request location permission
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (!serviceEnabled ||
          permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permission denied or service is off.'),
          backgroundColor: Colors.redAccent,
        ));
        setState(() {
          isLoadingStations = false;
        });
        return;
      }

      Position userPos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Fetch all stations
      List<StationModel> allStations = await _stationService.getStations(context);

      // Filter by station serials in promotion
      List<StationModel> filtered = allStations
          .where((s) => widget.promotion.stations.contains(s.serial))
          .toList();

      // Calculate distance to each
      for (var station in filtered) {
        if (station.stationAdress != null) {
          final match = RegExp(r'([0-9\.-]+),([0-9\.-]+)')
              .firstMatch(station.stationAdress!);
          if (match != null) {
            double lat = double.tryParse(match.group(1) ?? '') ?? 0;
            double lng = double.tryParse(match.group(2) ?? '') ?? 0;
            double dist = Geolocator.distanceBetween(
                userPos.latitude, userPos.longitude, lat, lng);
            station.distance = dist;
          } else {
            station.distance = double.infinity;
          }
        } else {
          station.distance = double.infinity;
        }
      }

      // Sort by distance
      filtered.sort((a, b) => (a.distance ?? double.infinity)
          .compareTo(b.distance ?? double.infinity));

      setState(() {
        custserial = userSerial;
        nearbyStations = filtered;
        filteredStations = filtered;
        isLoadingStations = false;
      });
    } catch (e) {
      print('Error loading stations: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load stations: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
      setState(() {
        isLoadingStations = false;
      });
    }
  }

  Future<void> loadFilters() async {
    try {
      final governorates = await GovernorateService.getAllGovernorates(context);
      final cities = await _cityService.getCities(context);
      setState(() {
        _governorates = governorates;
        _cities = cities;
        _filteredCities = cities;
        isLoadingFilters = false;
      });
    } catch (e) {
      print("Error loading filters: $e");
      setState(() {
        filterError = e.toString();
        isLoadingFilters = false;
      });
    }
  }

  void _filterCitiesByGovernorate(int? governorateId) {
    setState(() {
      if (governorateId == null) {
        _filteredCities = _cities;
        _selectedCity = null;
      } else {
        _filteredCities = _cities
            .where((city) => city.governorateId == governorateId)
            .toList();
        _selectedCity = null;
      }
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      filteredStations = nearbyStations;
      if (_selectedGovernorate != null) {
        filteredStations = filteredStations
            .where((station) =>
                station.governorateId == _selectedGovernorate!.governorateId)
            .toList();
      }
      if (_selectedCity != null) {
        filteredStations = filteredStations
            .where((station) => station.cityId == _selectedCity!.cityId)
            .toList();
      }
      // Reset selected station if it’s no longer in filtered list
      if (selectedStation != null &&
          !filteredStations.contains(selectedStation)) {
        selectedStation = null;
        selectedStationAddressUrl = null;
      }
    });
  }

  String? getGovernorateNameById(int? id, bool isRTL) {
    final match = _governorates.firstWhere(
      (gov) => gov.governorateId == id,
      orElse: () => GovernorateModel(
          governorateId: 0, governorateName: '', governorateLatName: ''),
    );
    final name = isRTL ? match.governorateName : match.governorateLatName;
    return name.isNotEmpty ? name : 'Unknown';
  }

  String? getCityNameById(int? id, bool isRTL) {
    final match = _cities.firstWhere(
      (city) => city.cityId == id,
      orElse: () =>
          CityModel(cityId: 0, cityLatName: '', cityName: '', governorateId: 0),
    );
    final name = isRTL ? match.cityName : match.cityLatName;
    return name.isNotEmpty ? name : 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const LogoRow(),
      ),
      body: isLoadingStations || isLoadingFilters
          ? const Center(child: LoadingScreen())
          : filterError != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: $filterError',
                        style: const TextStyle(
                            color: Colors.redAccent, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoadingFilters = true;
                            filterError = null;
                            loadFilters();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        child: Text(
                          'Retry'.tr,
                          style: const TextStyle(
                              color: btntxtColors, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: widget.promotion.imagePath != null &&
                                widget.promotion.imagePath!.isNotEmpty
                            ? Image.network(
                                widget.promotion.imagePath!.replaceAll('\\', '/'),
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset("assets/images/logo.png"),
                              )
                            : Image.asset("assets/images/logo.png"),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.promotion.eventTopic ?? 'Promotion',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
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
                            Text(
                              widget.promotion.eventEnDescription ?? '',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text("all_card.start_date".tr,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(width: 10),
                                Text(
                                  widget.promotion.startDate
                                          ?.toString()
                                          .split(' ')[0] ??
                                      'N/A',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text("all_card.end_date".tr,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(width: 10),
                                Text(
                                  widget.promotion.endDate
                                          ?.toString()
                                          .split(' ')[0] ??
                                      'N/A',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            ActivityIndicator(
                              left: widget.promotion.remainingUsage,
                              total: widget.promotion.qrMaxUsage,
                              title: 'promotion_det_page.activity'.tr,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Filter Stations".tr,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<GovernorateModel>(
                              decoration: InputDecoration(
                                labelText: "Select governorate".tr,
                                border: const OutlineInputBorder(),
                                prefixIcon:
                                    isRTL ? null : const Icon(Icons.filter_alt),
                                suffixIcon:
                                    isRTL ? const Icon(Icons.filter_alt) : null,
                              ),
                              isExpanded: true,
                              value: _selectedGovernorate,
                              hint: Text("Choose governorate".tr),
                              items: [
                                DropdownMenuItem<GovernorateModel>(
                                  value: null,
                                  child: Text("Choose governorate".tr),
                                ),
                                ..._governorates.map(
                                    (gov) => DropdownMenuItem<GovernorateModel>(
                                          value: gov,
                                          child: Text(isRTL
                                              ? gov.governorateName
                                              : gov.governorateLatName),
                                        )),
                              ],
                              onChanged: (GovernorateModel? newValue) {
                                setState(() {
                                  _selectedGovernorate = newValue;
                                  _filterCitiesByGovernorate(
                                      newValue?.governorateId);
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<CityModel>(
                              decoration: InputDecoration(
                                labelText: "Select city".tr,
                                border: const OutlineInputBorder(),
                                prefixIcon:
                                    isRTL ? null : const Icon(Icons.filter_alt),
                                suffixIcon:
                                    isRTL ? const Icon(Icons.filter_alt) : null,
                              ),
                              isExpanded: true,
                              value: _selectedCity,
                              hint: Text("Choose city".tr),
                              items: [
                                DropdownMenuItem<CityModel>(
                                  value: null,
                                  child: Text("Choose city".tr),
                                ),
                                ..._filteredCities.map(
                                    (city) => DropdownMenuItem<CityModel>(
                                          value: city,
                                          child: Text(isRTL
                                              ? city.cityName
                                              : city.cityLatName),
                                        )),
                              ],
                              onChanged: (CityModel? newValue) {
                                setState(() {
                                  _selectedCity = newValue;
                                  _applyFilters();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Choose Nearest Station".tr,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<StationModel>(
                        isExpanded: true,
                        value: selectedStation,
                        hint: Text("Select nearest station".tr),
                        items: filteredStations.map((station) {
                          String subtitle = '';
                          final govName = getGovernorateNameById(
                              station.governorateId, isRTL);
                          final cityName =
                              getCityNameById(station.cityId, isRTL);
                          subtitle = '$govName, $cityName';
                          return DropdownMenuItem(
                            value: station,
                            child: Text(
                              "${isRTL ? station.stationArabicName : station.stationName} ($subtitle, ${(station.distance! / 1000).toStringAsFixed(2)} km)",
                            ),
                          );
                        }).toList(),
                        onChanged: (station) {
                          setState(() {
                            selectedStation = station;
                            selectedStationAddressUrl = station?.stationAdress;
                          });
                        },
                      ),
                      if (filteredStations.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'No stations available for selected filters.'.tr,
                            style: const TextStyle(
                                color: Colors.redAccent, fontSize: 14),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Center(
                        child: OpenMapLinkButton(
                          label: 'Get station directions'.tr,
                          mapUrl: selectedStationAddressUrl ?? '',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if ((widget.promotion.remainingUsage) == 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'You have reached the maximum number of redemptions.'
                                            .tr),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                                return;
                              }

                              if (selectedStation == null ||
                                  selectedStationAddressUrl == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('You must choose a station first.'.tr),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                                return;
                              }

                              Position userPos =
                                  await Geolocator.getCurrentPosition(
                                      desiredAccuracy: LocationAccuracy.high);
                              RegExp regex = RegExp(r'([0-9\.-]+),([0-9\.-]+)');
                              Match? match =
                                  regex.firstMatch(selectedStationAddressUrl!);

                              if (match == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Invalid station location link.'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                                return;
                              }

                              double stationLat = double.parse(match.group(1)!);
                              double stationLng = double.parse(match.group(2)!);
                              double distanceInMeters =
                                  Geolocator.distanceBetween(
                                userPos.latitude,
                                userPos.longitude,
                                stationLat,
                                stationLng,
                              );

                              const allowedRange = 20000; // meters
                              if (distanceInMeters <= allowedRange) {
                                Get.to(() => QRPage(
                                    customerId: custserial,
                                    eventId: widget.promotion.serial));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'You are out of range by ${(distanceInMeters / 1000 - allowedRange / 1000).toStringAsFixed(2)} km.'
                                            .tr),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(primaryColor)),
                            child: Text('btn.promotions_det_pag_redeem'.tr,
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