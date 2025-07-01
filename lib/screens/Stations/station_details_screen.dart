// import 'package:flutter/material.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/stations_model.dart';
// import 'package:total_energies/widgets/global/app_bar_logos.dart';
// import 'package:total_energies/widgets/stations/maps.dart';

// class StationDetailsScreen extends StatelessWidget {
//   final StationModel station;

//   const StationDetailsScreen({super.key, required this.station});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//           backgroundColor: backgroundColor,
//           title: Row(
//             children: [
//               LogoRow(),
//               Spacer(),
//               Text(
//                 station.stationName,
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ],
//           )),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Station Code: ${station.stationCode ?? 'N/A'}",
//                 style: TextStyle(fontSize: 18)),
//             SizedBox(height: 8),
//             Text("Address: ${station.stationAdress ?? 'N/A'}",
//                 style: TextStyle(fontSize: 18)),
//             SizedBox(height: 8),
//             Text("Government: ${station.stationGovernment ?? 'N/A'}",
//                 style: TextStyle(fontSize: 18)),
//             SizedBox(height: 8),
//             Text("BT Code: ${station.btCode ?? 'N/A'}",
//                 style: TextStyle(fontSize: 18)),
//             SizedBox(height: 8),
//             Text("Active: ${station.activeYN == true ? 'Yes' : 'No'}",
//                 style: TextStyle(fontSize: 18)),
//             SizedBox(height: 8),
//             OpenMapLinkButton(
//               label: 'Open Location in Google Maps',
//               mapUrl: station.stationAdress ?? '',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/service_model.dart';
// import 'package:total_energies/models/stations_model.dart';
// import 'package:total_energies/screens/Stations/stations_screen.dart';
// import 'package:total_energies/screens/loading_screen.dart';
// import 'package:total_energies/services/service_service.dart';
// import 'package:total_energies/widgets/global/app_bar_logos.dart';
// import 'package:total_energies/widgets/stations/maps.dart';

// class StationDetailsScreen extends StatelessWidget {
//   final StationModel station;

//   const StationDetailsScreen({super.key, required this.station});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         title: Row(
//           children: [
//             LogoRow(),
//             const Spacer(),
//             Text(
//               station.stationName,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Station Code: ${station.stationCode ?? 'N/A'}",
//                 style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 8),
//             Text("Address: ${station.stationAdress ?? 'N/A'}",
//                 style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 8),
//             Text("Government: ${station.stationGovernment ?? 'N/A'}",
//                 style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 8),
//             Text("BT Code: ${station.btCode ?? 'N/A'}",
//                 style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 8),
//             Text("Active: ${station.activeYN == true ? 'Yes' : 'No'}",
//                 style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 8),
//             OpenMapLinkButton(
//               label: 'Open Location in Google Maps',
//               mapUrl: station.stationAdress ?? '',
//             ),
//             const SizedBox(height: 30),
//             _buildAvailableServices(context),
//           ],
//         ),
//       ),
//     );
//   }

//   /// 🔧 Service Widget
//   Widget _buildAvailableServices(BuildContext context) {
//     return FutureBuilder<List<ServiceModel>>(
//       future: GetAllServicesService.fetchAllServices(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Container(
//             height: 160,
//             alignment: Alignment.center,
//             child: const LoadingScreen(),
//           );
//         } else if (snapshot.hasError) {
//           return Padding(
//             padding: const EdgeInsets.all(16),
//             child: Text('Failed to load services: ${snapshot.error}'),
//           );
//         }

//         final services = snapshot.data!.where((s) => s.activeYN).toList();

//         if (services.isEmpty) {
//           return const Padding(
//             padding: EdgeInsets.all(16),
//             child: Text('No active services available.'),
//           );
//         }

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Available Services',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               height: 120,
//               child: ListView.separated(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: services.length,
//                 separatorBuilder: (context, index) => const SizedBox(width: 20),
//                 itemBuilder: (context, index) {
//                   final service = services[index];
//                   return InkWell(
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => StationListScreen(service: service),
//                         ),
//                       );
//                     },
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 30,
//                           backgroundColor: primaryColor,
//                           child: const Icon(
//                             Icons.miscellaneous_services,
//                             color: Colors.white,
//                             size: 30,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           service.serviceLatDescription,
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/service_model.dart';
import 'package:total_energies/models/stations_model.dart';
import 'package:total_energies/models/promotions_model.dart';
import 'package:total_energies/screens/Promotions/apply_to_promo_det.dart';
import 'package:total_energies/screens/Stations/stations_screen.dart';
import 'package:total_energies/screens/loading_screen.dart';
import 'package:total_energies/services/service_service.dart';
import 'package:total_energies/services/promotions_service.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';
import 'package:total_energies/widgets/Promotions/all_promo_card.dart';
import 'package:total_energies/widgets/stations/maps.dart';

class StationDetailsScreen extends StatefulWidget {
  final StationModel station;

  const StationDetailsScreen({super.key, required this.station});

  @override
  State<StationDetailsScreen> createState() => _StationDetailsScreenState();
}

class _StationDetailsScreenState extends State<StationDetailsScreen> {
  final PromotionsService _promotionsService = PromotionsService();
  late Future<List<PromotionsModel>> _promosFuture;

  @override
  void initState() {
    super.initState();
    _promosFuture = _promotionsService.getPromotions(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            LogoRow(),
            const Spacer(),
            Text(
              widget.station.stationName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Station Code: ${widget.station.stationCode ?? 'N/A'}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Address: ${widget.station.stationAdress ?? 'N/A'}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Government: ${widget.station.stationGovernment ?? 'N/A'}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("BT Code: ${widget.station.btCode ?? 'N/A'}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Active: ${widget.station.activeYN == true ? 'Yes' : 'No'}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            OpenMapLinkButton(
              label: 'Open Location in Google Maps',
              mapUrl: widget.station.stationAdress ?? '',
            ),
            const SizedBox(height: 30),
            _buildAvailableServices(context),
            const SizedBox(height: 30),
            _buildRelatedPromotions(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableServices(BuildContext context) {
    return FutureBuilder<List<ServiceModel>>(
      future: GetAllServicesService.fetchAllServices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 160,
            alignment: Alignment.center,
            child: const LoadingScreen(),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Failed to load services: ${snapshot.error}'),
          );
        }

        final services = snapshot.data!.where((s) => s.activeYN).toList();

        if (services.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No active services available.'),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Services',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: services.length,
                separatorBuilder: (context, index) => const SizedBox(width: 20),
                itemBuilder: (context, index) {
                  final service = services[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StationListScreen(service: service),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: primaryColor,
                          child: const Icon(
                            Icons.miscellaneous_services,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          service.serviceLatDescription,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRelatedPromotions() {
    return FutureBuilder<List<PromotionsModel>>(
      future: _promosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Failed to load promotions: ${snapshot.error}'),
          );
        }

        final relatedPromos = snapshot.data!
            .where((promo) => promo.stations!.contains(widget.station.serial))
            .toList();

        if (relatedPromos.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'No promotions available for this station.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Promotions at This Station',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: relatedPromos.length,
              itemBuilder: (context, index) {
                final promo = relatedPromos[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: AllPromoCard(
                    serial: promo.serial,
                    imagepath: promo.imagePath ?? '',
                    title: promo.eventTopic ?? '',
                    description: promo.eventDescription ?? '',
                    startDate: promo.startDate,
                    endDate: promo.endDate,
                    total: promo.qrMaxUsage,
                    used: promo.usedTimes,
                    isBlocked: false,
                    statusLabel: 'Available',
                    statusColor: Colors.green,
                    onTap: () {
                      Get.to(() => ApplyToPromoDet(promotion: promo));
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
