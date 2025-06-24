// // Station List With Filter and direction
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/governorate_model.dart';
// import 'package:total_energies/models/service_model.dart';
// import 'package:total_energies/models/stations_model.dart';
// import 'package:total_energies/screens/loading_screen.dart';
// import 'package:total_energies/screens/Stations/station_details_screen.dart';
// import 'package:total_energies/services/governorate_service.dart';
// import 'package:total_energies/services/station_service.dart';
// import 'package:total_energies/widgets/global/app_bar_logos.dart';

// class StationListScreen extends StatefulWidget {
//   final ServiceModel? service;

//   const StationListScreen({super.key, this.service});

//   @override
//   State<StationListScreen> createState() => _StationListScreenState();
// }

// class _StationListScreenState extends State<StationListScreen> {
//   final StationService _stationService = StationService();
//   final GovernorateService _governorateService = GovernorateService();

//   late Future<List<StationModel>> _stationsFuture;
//   List<GovernorateModel> _governorates = [];
//   String _searchQuery = "";
//   String name = "";

//   @override
//   void initState() {
//     super.initState();
//     _stationsFuture = _stationService.getStations();
//     loadGovernorates(); // Load governorates
//     loadUserData();
//   }

//   void loadGovernorates() async {
//     try {
//       final result = await _governorateService.getGovernorates();
//       setState(() {
//         _governorates = result;
//       });
//     } catch (e) {
//       print("Error loading governorates: $e");
//     }
//   }

//   String? getGovernorateNameById(int? id) {
//     final match = _governorates.firstWhere(
//       (gov) => gov.governorateId == id,
//       orElse: () => GovernorateModel(
//           governorateId: 0, governorateName: '', governorateLatName: ''),
//     );
//     return match.governorateName.isNotEmpty ? match.governorateName : null;
//   }

//   void _navigateToDetails(BuildContext context, StationModel station) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => StationDetailsScreen(station: station),
//       ),
//     );
//   }

//   void loadUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       name = prefs.getString('username') ?? "";
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isRTL =
//         Directionality.of(context) == TextDirection.rtl; // Check direction

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         title: Row(
//           children: [
//             LogoRow(),
//             const Spacer(),
//             if (widget.service != null)
//               Expanded(
//                 child: Center(
//                   child: Text(
//                     widget.service!.serviceLatDescription,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ),
//             const Spacer(),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   'app_bar.hi_txt'.tr,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: primaryColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   name,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: primaryColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(10),
//             child: TextField(
//               decoration: InputDecoration(
//                 labelText: 'stations_page.search'.tr,
//                 border: OutlineInputBorder(),
//                 prefixIcon: isRTL
//                     ? null
//                     : Icon(Icons.search), // Adjust icon for direction
//                 suffixIcon:
//                     isRTL ? Icon(Icons.search) : null, // Search icon for RTL
//               ),
//               textAlign: isRTL ? TextAlign.right : TextAlign.left,
//               onChanged: (value) {
//                 setState(() {
//                   _searchQuery = value.toLowerCase();
//                 });
//               },
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<StationModel>>(
//               future: _stationsFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return LoadingScreen();
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('stations_page.failed_load'.tr));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(child: Text('stations_page.no_stations'.tr));
//                 }

//                 final stations = snapshot.data!
//                     .where((station) => station.stationName
//                         .toLowerCase()
//                         .contains(_searchQuery))
//                     .toList();

//                 return ListView.builder(
//                   padding: EdgeInsets.all(10),
//                   itemCount: stations.length,
//                   itemBuilder: (context, index) {
//                     final station = stations[index];
//                     return GestureDetector(
//                       onTap: () => _navigateToDetails(context, station),
//                       child: Card(
//                         color: Colors.white,
//                         margin: EdgeInsets.only(bottom: 15),
//                         elevation: 5,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: ListTile(
//                           leading: Directionality.of(context) !=
//                                   TextDirection.rtl
//                               ? null
//                               : Icon(Icons.location_on, color: primaryColor),
//                           trailing:
//                               Directionality.of(context) != TextDirection.rtl
//                                   ? Icon(Icons.location_on, color: primaryColor)
//                                   : null,
//                           title: Directionality.of(context) != TextDirection.rtl
//                               ? Text(station.stationArabicName)
//                               : Text(station.stationName),
//                           // subtitle: Text(station.stationGovernment ??
//                           //     'stations_page.station_address'.tr),
//                           subtitle: Text(
//                             getGovernorateNameById(station.governorateId) ??
//                                 station.stationGovernment ??
//                                 'stations_page.station_address'.tr,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/governorate_model.dart';
// import 'package:total_energies/models/service_model.dart';
// import 'package:total_energies/models/stations_model.dart';
// import 'package:total_energies/models/city_model.dart'; // Add CityModel import
// import 'package:total_energies/screens/loading_screen.dart';
// import 'package:total_energies/screens/Stations/station_details_screen.dart';
// import 'package:total_energies/services/governorate_service.dart';
// import 'package:total_energies/services/station_service.dart';
// import 'package:total_energies/services/city_service.dart'; // Add CityService import
// import 'package:total_energies/widgets/global/app_bar_logos.dart';

// class StationListScreen extends StatefulWidget {
//   final ServiceModel? service;

//   const StationListScreen({super.key, this.service});

//   @override
//   State<StationListScreen> createState() => _StationListScreenState();
// }

// class _StationListScreenState extends State<StationListScreen> {
//   final StationService _stationService = StationService();
//   final GovernorateService _governorateService = GovernorateService();
//   final CityService _cityService = CityService(); // Initialize CityService

//   late Future<List<StationModel>> _stationsFuture;
//   List<GovernorateModel> _governorates = [];
//   List<CityModel> _cities = []; // Add list to store cities
//   String _searchQuery = "";
//   String name = "";

//   @override
//   void initState() {
//     super.initState();
//     _stationsFuture = _stationService.getStations();
//     loadGovernorates(); // Load governorates
//     loadCities(); // Load cities
//     loadUserData();
//   }

//   void loadGovernorates() async {
//     try {
//       final result = await _governorateService.getGovernorates();
//       setState(() {
//         _governorates = result;
//       });
//     } catch (e) {
//       print("Error loading governorates: $e");
//     }
//   }

//   void loadCities() async {
//     try {
//       final result = await _cityService.getUsers(); // Fetch cities
//       setState(() {
//         _cities = result;
//       });
//     } catch (e) {
//       print("Error loading cities: $e");
//     }
//   }

//   String? getGovernorateNameById(int? id) {
//     final match = _governorates.firstWhere(
//       (gov) => gov.governorateId == id,
//       orElse: () => GovernorateModel(
//           governorateId: 0, governorateName: '', governorateLatName: ''),
//     );
//     return match.governorateName.isNotEmpty ? match.governorateName : null;
//   }

//   String? getCityNameById(int? id) {
//     final match = _cities.firstWhere(
//       (city) => city.cityId == id,
//       orElse: () => CityModel(cityId: 0, cityName: '', cityLatName: ''),
//     );
//     return match.cityName.isNotEmpty ? match.cityName : null;
//   }

//   void _navigateToDetails(BuildContext context, StationModel station) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => StationDetailsScreen(station: station),
//       ),
//     );
//   }

//   void loadUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       name = prefs.getString('username') ?? "";
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isRTL = Directionality.of(context) == TextDirection.rtl;

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         title: Row(
//           children: [
//             LogoRow(),
//             const Spacer(),
//             if (widget.service != null)
//               Expanded(
//                 child: Center(
//                   child: Text(
//                     widget.service!.serviceLatDescription,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ),
//             const Spacer(),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   'app_bar.hi_txt'.tr,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: primaryColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   name,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: primaryColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(10),
//             child: TextField(
//               decoration: InputDecoration(
//                 labelText: 'stations_page.search'.tr,
//                 border: OutlineInputBorder(),
//                 prefixIcon: isRTL ? null : Icon(Icons.search),
//                 suffixIcon: isRTL ? Icon(Icons.search) : null,
//               ),
//               textAlign: isRTL ? TextAlign.right : TextAlign.left,
//               onChanged: (value) {
//                 setState(() {
//                   _searchQuery = value.toLowerCase();
//                 });
//               },
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<StationModel>>(
//               future: _stationsFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return LoadingScreen();
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('stations_page.failed_load'.tr));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(child: Text('stations_page.no_stations'.tr));
//                 }

//                 final stations = snapshot.data!
//                     .where((station) => station.stationName
//                         .toLowerCase()
//                         .contains(_searchQuery))
//                     .toList();

//                 return ListView.builder(
//                   padding: EdgeInsets.all(10),
//                   itemCount: stations.length,
//                   itemBuilder: (context, index) {
//                     final station = stations[index];
//                     // Combine governorate and city names
//                     final govName =
//                         getGovernorateNameById(station.governorateId) ??
//                             station.stationGovernment ??
//                             'stations_page.station_address'.tr;
//                     final cityName =
//                         getCityNameById(station.cityId) ?? 'Unknown City';
//                     final subtitle = '$govName, $cityName'; // Combine names

//                     return GestureDetector(
//                       onTap: () => _navigateToDetails(context, station),
//                       child: Card(
//                         color: Colors.white,
//                         margin: EdgeInsets.only(bottom: 15),
//                         elevation: 5,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: ListTile(
//                           leading: Directionality.of(context) !=
//                                   TextDirection.rtl
//                               ? null
//                               : Icon(Icons.location_on, color: primaryColor),
//                           trailing:
//                               Directionality.of(context) != TextDirection.rtl
//                                   ? Icon(Icons.location_on, color: primaryColor)
//                                   : null,
//                           title: Directionality.of(context) != TextDirection.rtl
//                               ? Text(station.stationArabicName)
//                               : Text(station.stationName),
//                           subtitle: Text(subtitle), // Use combined subtitle
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/governorate_model.dart';
// import 'package:total_energies/models/service_model.dart';
// import 'package:total_energies/models/stations_model.dart';
// import 'package:total_energies/models/city_model.dart';
// import 'package:total_energies/screens/loading_screen.dart';
// import 'package:total_energies/screens/Stations/station_details_screen.dart';
// import 'package:total_energies/services/governorate_service.dart';
// import 'package:total_energies/services/station_service.dart';
// import 'package:total_energies/services/city_service.dart';
// import 'package:total_energies/widgets/global/app_bar_logos.dart';

// class StationListScreen extends StatefulWidget {
//   final ServiceModel? service;

//   const StationListScreen({super.key, this.service});

//   @override
//   State<StationListScreen> createState() => _StationListScreenState();
// }

// class _StationListScreenState extends State<StationListScreen> {
//   final StationService _stationService = StationService();
//   final GovernorateService _governorateService = GovernorateService();
//   final CityService _cityService = CityService();

//   late Future<List<StationModel>> _stationsFuture;
//   List<GovernorateModel> _governorates = [];
//   List<CityModel> _cities = [];
//   String _searchQuery = "";
//   String name = "";

//   @override
//   void initState() {
//     super.initState();
//     _stationsFuture = _stationService.getStations();
//     loadGovernorates();
//     loadCities();
//     loadUserData();
//   }

//   void loadGovernorates() async {
//     try {
//       final result = await _governorateService.getGovernorates();
//       setState(() {
//         _governorates = result;
//       });
//     } catch (e) {
//       print("Error loading governorates: $e");
//     }
//   }

//   void loadCities() async {
//     try {
//       final result = await _cityService.getCities();
//       setState(() {
//         _cities = result;
//       });
//     } catch (e) {
//       print("Error loading cities: $e");
//     }
//   }

//   String? getGovernorateNameById(int? id) {
//     final match = _governorates.firstWhere(
//       (gov) => gov.governorateId == id,
//       orElse: () => GovernorateModel(
//           governorateId: 0, governorateName: '', governorateLatName: ''),
//     );
//     return match.governorateName.isNotEmpty ? match.governorateName : null;
//   }

//   String? getCityNameById(int? id) {
//     final match = _cities.firstWhere(
//       (city) => city.cityId == id,
//       orElse: () =>
//           CityModel(cityId: 0, cityLatName: '', cityName: '', governorateId: 0),
//     );
//     return match.cityName.isNotEmpty ? match.cityName : null;
//   }

//   void _navigateToDetails(BuildContext context, StationModel station) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => StationDetailsScreen(station: station),
//       ),
//     );
//   }

//   void loadUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       name = prefs.getString('username') ?? "";
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isRTL = Directionality.of(context) == TextDirection.rtl;

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         title: Row(
//           children: [
//             LogoRow(),
//             const Spacer(),
//             if (widget.service != null)
//               Expanded(
//                 child: Center(
//                   child: Text(
//                     widget.service!.serviceLatDescription,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ),
//             const Spacer(),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   'app_bar.hi_txt'.tr,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: primaryColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   name,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: primaryColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(10),
//             child: TextField(
//               decoration: InputDecoration(
//                 labelText: 'stations_page.search'.tr,
//                 border: OutlineInputBorder(),
//                 prefixIcon: isRTL ? null : Icon(Icons.search),
//                 suffixIcon: isRTL ? Icon(Icons.search) : null,
//               ),
//               textAlign: isRTL ? TextAlign.right : TextAlign.left,
//               onChanged: (value) {
//                 setState(() {
//                   _searchQuery = value.toLowerCase();
//                 });
//               },
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<StationModel>>(
//               future: _stationsFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return LoadingScreen();
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('stations_page.failed_load'.tr));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(child: Text('stations_page.no_stations'.tr));
//                 }

//                 final stations = snapshot.data!
//                     .where((station) => station.stationName
//                         .toLowerCase()
//                         .contains(_searchQuery))
//                     .toList();

//                 return ListView.builder(
//                   padding: EdgeInsets.all(10),
//                   itemCount: stations.length,
//                   itemBuilder: (context, index) {
//                     final station = stations[index];
//                     final govName =
//                         getGovernorateNameById(station.governorateId) ??
//                             station.stationGovernment ??
//                             'stations_page.station_address'.tr;
//                     final cityName =
//                         getCityNameById(station.cityId) ?? 'Unknown City';
//                     final subtitle = '$govName, $cityName';

//                     return GestureDetector(
//                       onTap: () => _navigateToDetails(context, station),
//                       child: Card(
//                         color: Colors.white,
//                         margin: EdgeInsets.only(bottom: 15),
//                         elevation: 5,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: ListTile(
//                           leading: Directionality.of(context) !=
//                                   TextDirection.rtl
//                               ? null
//                               : Icon(Icons.location_on, color: primaryColor),
//                           trailing:
//                               Directionality.of(context) != TextDirection.rtl
//                                   ? Icon(Icons.location_on, color: primaryColor)
//                                   : null,
//                           title: Directionality.of(context) != TextDirection.rtl
//                               ? Text(station.stationArabicName)
//                               : Text(station.stationName),
//                           subtitle: Text(subtitle),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/governorate_model.dart';
import 'package:total_energies/models/service_model.dart';
import 'package:total_energies/models/stations_model.dart';
import 'package:total_energies/models/city_model.dart';
import 'package:total_energies/screens/loading_screen.dart';
import 'package:total_energies/screens/Stations/station_details_screen.dart';
import 'package:total_energies/services/governorate_service.dart';
import 'package:total_energies/services/station_service.dart';
import 'package:total_energies/services/city_service.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';

class StationListScreen extends StatefulWidget {
  final ServiceModel? service;

  const StationListScreen({super.key, this.service});

  @override
  State<StationListScreen> createState() => _StationListScreenState();
}

class _StationListScreenState extends State<StationListScreen> {
  final StationService _stationService = StationService();
  final GovernorateService _governorateService = GovernorateService();
  final CityService _cityService = CityService();

  late Future<List<StationModel>> _stationsFuture;
  List<GovernorateModel> _governorates = [];
  List<CityModel> _cities = [];
  List<CityModel> _filteredCities =
      []; // Cities filtered by selected governorate
  String _searchQuery = "";
  String name = "";
  GovernorateModel? _selectedGovernorate; // Selected governorate
  CityModel? _selectedCity; // Selected city

  @override
  void initState() {
    super.initState();
    _stationsFuture = _stationService.getStations();
    loadGovernorates();
    loadCities();
    loadUserData();
  }

  void loadGovernorates() async {
    try {
      final result = await GovernorateService.getAllGovernorates();
      setState(() {
        _governorates = result;
      });
    } catch (e) {
      print("Error loading governorates: $e");
    }
  }

  void loadCities() async {
    try {
      final result = await _cityService.getCities();
      setState(() {
        _cities = result;
        _filteredCities = result; // Initially show all cities
      });
    } catch (e) {
      print("Error loading cities: $e");
    }
  }

  void _filterCitiesByGovernorate(int? governorateId) {
    setState(() {
      if (governorateId == null) {
        _filteredCities = _cities; // Show all cities if no governorate selected
        _selectedCity = null; // Reset city selection
      } else {
        _filteredCities = _cities
            .where((city) => city.governorateId == governorateId)
            .toList();
        _selectedCity = null; // Reset city selection when governorate changes
      }
    });
  }

  String? getGovernorateNameById(int? id) {
    final match = _governorates.firstWhere(
      (gov) => gov.governorateId == id,
      orElse: () => GovernorateModel(
          governorateId: 0, governorateName: '', governorateLatName: ''),
    );
    return match.governorateName.isNotEmpty ? match.governorateName : null;
  }

  String? getCityNameById(int? id) {
    final match = _cities.firstWhere(
      (city) => city.cityId == id,
      orElse: () =>
          CityModel(cityId: 0, cityLatName: '', cityName: '', governorateId: 0),
    );
    return match.cityName.isNotEmpty ? match.cityName : null;
  }

  void _navigateToDetails(BuildContext context, StationModel station) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StationDetailsScreen(station: station),
      ),
    );
  }

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('username') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            LogoRow(),
            const Spacer(),
            if (widget.service != null)
              Expanded(
                child: Center(
                  child: Text(
                    widget.service!.serviceLatDescription,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'app_bar.hi_txt'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'stations_page.search'.tr,
                border: const OutlineInputBorder(),
                prefixIcon: isRTL ? null : const Icon(Icons.search),
                suffixIcon: isRTL ? const Icon(Icons.search) : null,
              ),
              textAlign: isRTL ? TextAlign.right : TextAlign.left,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<GovernorateModel>(
                    decoration: InputDecoration(
                      labelText: 'stations_page.governorate'.tr,
                      border: const OutlineInputBorder(),
                    ),
                    isExpanded: true,
                    value: _selectedGovernorate,
                    hint: Text('stations_page.select_governorate'.tr),
                    items: [
                      DropdownMenuItem<GovernorateModel>(
                        value: null,
                        child: Text('stations_page.all_governorates'.tr),
                      ),
                      ..._governorates
                          .map((gov) => DropdownMenuItem<GovernorateModel>(
                                value: gov,
                                child: Text(isRTL
                                    ? gov.governorateName
                                    : gov.governorateLatName),
                              )),
                    ],
                    onChanged: (GovernorateModel? newValue) {
                      setState(() {
                        _selectedGovernorate = newValue;
                        _filterCitiesByGovernorate(newValue?.governorateId);
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<CityModel>(
                    decoration: InputDecoration(
                      labelText: 'stations_page.city'.tr,
                      border: const OutlineInputBorder(),
                    ),
                    isExpanded: true,
                    value: _selectedCity,
                    hint: Text('stations_page.select_city'.tr),
                    items: [
                      DropdownMenuItem<CityModel>(
                        value: null,
                        child: Text('stations_page.all_cities'.tr),
                      ),
                      ..._filteredCities.map((city) =>
                          DropdownMenuItem<CityModel>(
                            value: city,
                            child:
                                Text(isRTL ? city.cityName : city.cityLatName),
                          )),
                    ],
                    onChanged: (CityModel? newValue) {
                      setState(() {
                        _selectedCity = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<StationModel>>(
              future: _stationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                } else if (snapshot.hasError) {
                  return Center(child: Text('stations_page.failed_load'.tr));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('stations_page.no_stations'.tr));
                }

                var stations = snapshot.data!
                    .where((station) => station.stationName
                        .toLowerCase()
                        .contains(_searchQuery))
                    .toList();

                // Apply governorate filter
                if (_selectedGovernorate != null) {
                  stations = stations
                      .where((station) =>
                          station.governorateId ==
                          _selectedGovernorate!.governorateId)
                      .toList();
                }

                // Apply city filter
                if (_selectedCity != null) {
                  stations = stations
                      .where(
                          (station) => station.cityId == _selectedCity!.cityId)
                      .toList();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: stations.length,
                  itemBuilder: (context, index) {
                    final station = stations[index];
                    final govName =
                        getGovernorateNameById(station.governorateId) ??
                            station.stationGovernment ??
                            'stations_page.station_address'.tr;
                    final cityName =
                        getCityNameById(station.cityId) ?? 'Unknown City';
                    final subtitle = '$govName, $cityName';

                    return GestureDetector(
                      onTap: () => _navigateToDetails(context, station),
                      child: Card(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 15),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: isRTL
                              ? const Icon(Icons.location_on,
                                  color: primaryColor)
                              : null,
                          trailing: !isRTL
                              ? const Icon(Icons.location_on,
                                  color: primaryColor)
                              : null,
                          title: Text(
                            isRTL
                                ? station.stationArabicName
                                : station.stationName,
                          ),
                          subtitle: Text(subtitle),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
