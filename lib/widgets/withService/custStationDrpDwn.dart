// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:total_energies/models/stations_model.dart';
// import 'package:total_energies/services/station_service.dart';
// // Adjust path as needed

// class StationDropdown extends StatefulWidget {
//   final Function(StationModel?)? onChanged; // Callback function

//   const StationDropdown({super.key, this.onChanged});

//   @override
//   _StationDropdownState createState() => _StationDropdownState();
// }

// class _StationDropdownState extends State<StationDropdown> {
//   final StationService _stationService = StationService();
//   List<StationModel> _stations = [];
//   StationModel? _selectedStation;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchStations();
//   }

//   Future<void> _fetchStations() async {
//     try {
//       List<StationModel> stations = await _stationService.getOnlyStations();
//       setState(() {
//         _stations = stations;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       Directionality.of(context) != TextDirection.rtl
//           ? print("خطأ في جلب المحطات:  $e")
//           : print("Error fetching stations: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? const CircularProgressIndicator() // Show loader while fetching
//         : DropdownButtonFormField<StationModel>(
//             value: _selectedStation,
//             hint: Text(
//               'promotion_det_page.select_station'.tr,
//               style: TextStyle(color: Colors.black),
//             ),
//             isExpanded: true,
//             menuMaxHeight: 200,
//             itemHeight: 50,
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: Colors.white, // Background color
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(30), // Rounded borders
//                 borderSide: BorderSide.none, // Remove default border
//               ),
//             ),
//             items: _stations.map((station) {
//               return DropdownMenuItem<StationModel>(
//                 value: station,
//                 child: Text(
//                   Directionality.of(context) != TextDirection.rtl
//                       ? station.stationName
//                       : station.stationArabicName,
//                 ),
//               );
//             }).toList(),
//             onChanged: (station) {
//               setState(() {
//                 _selectedStation = station;
//               });
//               if (widget.onChanged != null) {
//                 widget.onChanged!(station);
//               }
//             },
//           );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:total_energies/models/promotions_model.dart';
// import 'package:total_energies/models/stations_model.dart';
// import 'package:total_energies/services/promotions_service.dart';
// import 'package:total_energies/services/station_service.dart';
// // Adjust path as needed

// class StationDropdown extends StatefulWidget {
//   final Function(PromotionsModel?)? onChanged; // Callback function

//   const StationDropdown({super.key, this.onChanged});

//   @override
//   _StationDropdownState createState() => _StationDropdownState();
// }

// class _StationDropdownState extends State<StationDropdown> {
//   final PromotionsService _stationService = PromotionsService();
//   List<PromotionsModel> _stations = [];
//   PromotionsModel? _selectedStation;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchStations();
//   }


//   Future<void> _fetchStations() async {
//     try {
//       List<PromotionsModel> stations = await _stationService.getPromotions();
//       setState(() {
//         _stations = stations;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       Directionality.of(context) != TextDirection.rtl
//           ? print("خطأ في جلب المحطات:  $e")
//           : print("Error fetching stations: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? const CircularProgressIndicator() // Show loader while fetching
//         : DropdownButtonFormField<PromotionsModel>(
//             value: _selectedStation,
//             hint: Text(
//               'promotion_det_page.select_station'.tr,
//               style: TextStyle(color: Colors.black),
//             ),
//             isExpanded: true,
//             menuMaxHeight: 200,
//             itemHeight: 50,
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: Colors.white, // Background color
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(30), // Rounded borders
//                 borderSide: BorderSide.none, // Remove default border
//               ),
//             ),
//             items: _stations.map((station) {
//               return DropdownMenuItem<PromotionsModel>(
//                 value: station,
//                 child: Text(station.stations as String),
//                 // child: Text(
//                 //   Directionality.of(context) != TextDirection.rtl
//                 //       ? station.stations
//                 //       : station.stationArabicName,
//                 // ),
//               );
//             }).toList(),
//             onChanged: (station) {
//               setState(() {
//                 _selectedStation = station;
//               });
//               if (widget.onChanged != null) {
//                 widget.onChanged!(station);
//               }
//             },
//           );
//   }
// }

import 'package:flutter/material.dart';
import 'package:total_energies/services/promotions_service.dart';
import 'package:total_energies/models/promotions_model.dart';

class StationsDropdown extends StatefulWidget {
  final Function(int?)? onChanged;
  final int? selectedStation;

  const StationsDropdown({
    super.key,
    this.onChanged,
    this.selectedStation,
  });

  @override
  State<StationsDropdown> createState() => _StationsDropdownState();
}

class _StationsDropdownState extends State<StationsDropdown> {
  List<int> stationIds = [];
  int? selected;

  @override
  void initState() {
    super.initState();
    _loadStations();
  }

  Future<void> _loadStations() async {
    try {
      PromotionsService service = PromotionsService();
      List<PromotionsModel> promotions = await service.getPromotions();

      // Collect and deduplicate all station IDs from promotions
      Set<int> uniqueStations = {};
      for (var promo in promotions) {
        if (promo.stations != null) {
          uniqueStations.addAll(promo.stations!);
        }
      }

      setState(() {
        stationIds = uniqueStations.toList()..sort();
      });
    } catch (e) {
      debugPrint("Error fetching stations: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: widget.selectedStation,
      decoration: const InputDecoration(
        labelText: "Select Station",
        border: OutlineInputBorder(),
      ),
      items: stationIds.map((stationId) {
        return DropdownMenuItem<int>(
          value: stationId,
          child: Text('Station $stationId'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selected = value;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
    );
  }
}

