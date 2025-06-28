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

// Worksss foolaaa
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
//   List<CityModel> _filteredCities =
//       []; // Cities filtered by selected governorate
//   String _searchQuery = "";
//   String name = "";
//   GovernorateModel? _selectedGovernorate; // Selected governorate
//   CityModel? _selectedCity; // Selected city

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
//       final result = await GovernorateService.getAllGovernorates();
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
//         _filteredCities = result; // Initially show all cities
//       });
//     } catch (e) {
//       print("Error loading cities: $e");
//     }
//   }

//   void _filterCitiesByGovernorate(int? governorateId) {
//     setState(() {
//       if (governorateId == null) {
//         _filteredCities = _cities; // Show all cities if no governorate selected
//         _selectedCity = null; // Reset city selection
//       } else {
//         _filteredCities = _cities
//             .where((city) => city.governorateId == governorateId)
//             .toList();
//         _selectedCity = null; // Reset city selection when governorate changes
//       }
//     });
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
//             padding: const EdgeInsets.all(10),
//             child: TextField(
//               decoration: InputDecoration(
//                 labelText: 'stations_page.search'.tr,
//                 border: const OutlineInputBorder(),
//                 prefixIcon: isRTL ? null : const Icon(Icons.search),
//                 suffixIcon: isRTL ? const Icon(Icons.search) : null,
//               ),
//               textAlign: isRTL ? TextAlign.right : TextAlign.left,
//               onChanged: (value) {
//                 setState(() {
//                   _searchQuery = value.toLowerCase();
//                 });
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: DropdownButtonFormField<GovernorateModel>(
//                     decoration: InputDecoration(
//                       labelText: "Select governorate",
//                       border: const OutlineInputBorder(),
//                     ),
//                     isExpanded: true,
//                     value: _selectedGovernorate,
//                     hint: Text(
//                       'Choose governorate',
//                     ),
//                     items: [
//                       DropdownMenuItem<GovernorateModel>(
//                         value: null,
//                         child: Text(
//                           "Choose governorate",
//                           style: TextStyle(
//                             decoration: TextDecoration.underline,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                       ..._governorates
//                           .map((gov) => DropdownMenuItem<GovernorateModel>(
//                                 value: gov,
//                                 child: Text(isRTL
//                                     ? gov.governorateName
//                                     : gov.governorateLatName),
//                               )),
//                     ],
//                     onChanged: (GovernorateModel? newValue) {
//                       setState(() {
//                         _selectedGovernorate = newValue;
//                         _filterCitiesByGovernorate(newValue?.governorateId);
//                       });
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: DropdownButtonFormField<CityModel>(
//                     decoration: InputDecoration(
//                       labelText: "Select region",
//                       border: const OutlineInputBorder(),
//                     ),
//                     isExpanded: true,
//                     value: _selectedCity,
//                     hint: Text("Choose region"),
//                     items: [
//                       DropdownMenuItem<CityModel>(
//                         value: null,
//                         child: Text(
//                           "Choose region",
//                           style: TextStyle(
//                             decoration: TextDecoration.underline,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                       ..._filteredCities.map((city) =>
//                           DropdownMenuItem<CityModel>(
//                             value: city,
//                             child:
//                                 Text(isRTL ? city.cityName : city.cityLatName),
//                           )),
//                     ],
//                     onChanged: (CityModel? newValue) {
//                       setState(() {
//                         _selectedCity = newValue;
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<StationModel>>(
//               future: _stationsFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const LoadingScreen();
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('stations_page.failed_load'.tr));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(child: Text('stations_page.no_stations'.tr));
//                 }

//                 var stations = snapshot.data!
//                     .where((station) => station.stationName
//                         .toLowerCase()
//                         .contains(_searchQuery))
//                     .toList();

//                 // Apply governorate filter
//                 if (_selectedGovernorate != null) {
//                   stations = stations
//                       .where((station) =>
//                           station.governorateId ==
//                           _selectedGovernorate!.governorateId)
//                       .toList();
//                 }

//                 // Apply city filter
//                 if (_selectedCity != null) {
//                   stations = stations
//                       .where(
//                           (station) => station.cityId == _selectedCity!.cityId)
//                       .toList();
//                 }

//                 return ListView.builder(
//                   padding: const EdgeInsets.all(10),
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
//                         margin: const EdgeInsets.only(bottom: 15),
//                         elevation: 5,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: ListTile(
//                           leading: isRTL
//                               ? const Icon(Icons.location_on,
//                                   color: primaryColor)
//                               : null,
//                           trailing: !isRTL
//                               ? const Icon(Icons.location_on,
//                                   color: primaryColor)
//                               : null,
//                           title: Text(
//                             isRTL
//                                 ? station.stationArabicName
//                                 : station.stationName,
//                           ),
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

// Importing necessary packages and project files for the StationListScreen
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

// Defines the StationListScreen widget, a stateful widget to display a list of stations
class StationListScreen extends StatefulWidget {
  // Optional ServiceModel parameter to display service-specific information
  final ServiceModel? service;

  const StationListScreen({super.key, this.service});

  @override
  State<StationListScreen> createState() => _StationListScreenState();
}

// State class for StationListScreen, managing the screen's state and logic
class _StationListScreenState extends State<StationListScreen> {
  // Initialize service instances for fetching station, governorate, and city data
  final StationService _stationService = StationService();
  final GovernorateService _governorateService = GovernorateService();
  final CityService _cityService = CityService();

  // Future to hold the list of stations fetched from the API
  late Future<List<StationModel>> _stationsFuture;
  // Lists to store governorates and cities for dropdown filters
  List<GovernorateModel> _governorates = [];
  List<CityModel> _cities = [];
  // Filtered cities based on selected governorate
  List<CityModel> _filteredCities = [];
  // Search query for filtering stations by name
  String _searchQuery = "";
  // User's name retrieved from SharedPreferences
  String name = "";
  // Selected governorate and city for dropdown filters
  GovernorateModel? _selectedGovernorate;
  CityModel? _selectedCity;

  // Initialize state: fetch stations and load governorates, cities, and user data
  @override
  void initState() {
    super.initState();
    _stationsFuture = _stationService.getStations();
    loadGovernorates();
    loadCities();
    loadUserData();
  }

  // Fetches governorates from GovernorateService and updates state
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

  // Fetches cities from CityService and initializes filtered cities
  void loadCities() async {
    try {
      final result = await _cityService.getCities();
      setState(() {
        _cities = result;
        _filteredCities = result;
      });
    } catch (e) {
      print("Error loading cities: $e");
    }
  }

  // Filters cities based on selected governorate ID, resetting city selection
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
    });
  }

  // Retrieves governorate name (Arabic for RTL, English for LTR) by ID
  String? getGovernorateNameById(int? id, bool isRTL) {
    final match = _governorates.firstWhere(
      (gov) => gov.governorateId == id,
      orElse: () => GovernorateModel(
          governorateId: 0, governorateName: '', governorateLatName: ''),
    );
    final name = isRTL ? match.governorateName : match.governorateLatName;
    return name.isNotEmpty ? name : null;
  }

  // Retrieves city name (Arabic for RTL, English for LTR) by ID
  String? getCityNameById(int? id, bool isRTL) {
    final match = _cities.firstWhere(
      (city) => city.cityId == id,
      orElse: () =>
          CityModel(cityId: 0, cityLatName: '', cityName: '', governorateId: 0),
    );
    final name = isRTL ? match.cityName : match.cityLatName;
    return name.isNotEmpty ? name : null;
  }

  // Navigates to StationDetailsScreen with the selected station
  void _navigateToDetails(BuildContext context, StationModel station) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StationDetailsScreen(station: station),
      ),
    );
  }

  // Loads user data (username) from SharedPreferences
  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('username') ?? "";
    });
  }

  // Builds the UI for the StationListScreen
  @override
  Widget build(BuildContext context) {
    // Determine text direction (RTL for Arabic, LTR for English)
    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    // Main scaffold with app bar and body
    return Scaffold(
      backgroundColor: backgroundColor,
      // App bar with logo, service description, and user greeting
      appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Row(
            children: [
              // Displays the custom logo widget on the left
              LogoRow(),
              // Adds flexible space to balance the layout between logo and other elements
              const Spacer(),
              // Displays the service description if available, centered in the available space
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
                      overflow: TextOverflow
                          .ellipsis, // Truncates long service descriptions
                    ),
                  ),
                ),
              // Adds flexible space to balance the layout between service description and user greeting
              const Spacer(),
              // Displays user greeting with username, limited to a fixed width to prevent overflow
              ConstrainedBox(
                constraints: const BoxConstraints(
                    maxWidth: 100), // Limits width for long usernames
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Displays "Hi" greeting text
                    // Text(
                    //   'app_bar.hi_txt'.tr,
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     color: primaryColor,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // Displays the username, truncated with ellipses if too long
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow:
                          TextOverflow.ellipsis, // Truncates long usernames
                    ),
                  ],
                ),
              ),
            ],
          )),
      // Main body with search bar, filters, and station list
      body: Column(
        children: [
          // Search bar for filtering stations by name
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
          // Dropdown filters for governorate and city
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                // Governorate dropdown filter
                Expanded(
                  child: DropdownButtonFormField<GovernorateModel>(
                    decoration: InputDecoration(
                      labelText: "Select governorate",
                      border: const OutlineInputBorder(),
                    ),
                    isExpanded: true,
                    value: _selectedGovernorate,
                    hint: Text("Choose gov"),
                    items: [
                      DropdownMenuItem<GovernorateModel>(
                        value: null,
                        child: Text(
                          "Choose gov",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
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
                // City dropdown filter, showing cities for selected governorate
                Expanded(
                  child: DropdownButtonFormField<CityModel>(
                    decoration: InputDecoration(
                      labelText: "Select region",
                      border: const OutlineInputBorder(),
                    ),
                    isExpanded: true,
                    value: _selectedCity,
                    hint: Text("Choose region"),
                    items: [
                      DropdownMenuItem<CityModel>(
                        value: null,
                        child: Text(
                          "Choose region",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
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
          // Station list display with loading and error handling
          Expanded(
            child: FutureBuilder<List<StationModel>>(
              future: _stationsFuture,
              builder: (context, snapshot) {
                // Show loading screen while fetching data
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                } else if (snapshot.hasError) {
                  // Display error message if data fetch fails
                  return Center(child: Text('stations_page.failed_load'.tr));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // Display message if no stations are found
                  return Center(child: Text('stations_page.no_stations'.tr));
                }

                // Filter stations by search query (station name or Arabic name)
                var stations = snapshot.data!.where((station) {
                  final stationName = station.stationName.toLowerCase();
                  final stationArabicName =
                      station.stationArabicName.toLowerCase();
                  return stationName.contains(_searchQuery) ||
                      stationArabicName.contains(_searchQuery);
                }).toList();

                // Apply governorate filter if selected
                if (_selectedGovernorate != null) {
                  stations = stations
                      .where((station) =>
                          station.governorateId ==
                          _selectedGovernorate!.governorateId)
                      .toList();
                }

                // Apply city filter if selected
                if (_selectedCity != null) {
                  stations = stations
                      .where(
                          (station) => station.cityId == _selectedCity!.cityId)
                      .toList();
                }

                // Build list of station cards
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: stations.length,
                  itemBuilder: (context, index) {
                    final station = stations[index];
                    // Get governorate and city names for subtitle (Arabic for RTL, English for LTR)
                    final govName =
                        getGovernorateNameById(station.governorateId, isRTL) ??
                            station.stationGovernment ??
                            'stations_page.station_address'.tr;
                    final cityName = getCityNameById(station.cityId, isRTL) ??
                        'Unknown City';
                    final subtitle = '$govName, $cityName';

                    // Station card with tap navigation to details
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
