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
// import 'package:geolocator/geolocator.dart';

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
//   List<CityModel> _filteredCities = [];
//   String _searchQuery = "";
//   String name = "";
//   GovernorateModel? _selectedGovernorate;
//   CityModel? _selectedCity;
//   String? locationError;

//   @override
//   void initState() {
//     super.initState();
//     _stationsFuture = _loadStations();
//     loadGovernorates();
//     loadCities();
//     loadUserData();
//   }

//   Future<List<StationModel>> _loadStations() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }

//       if (!serviceEnabled ||
//           permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever) {
//         setState(() {
//           locationError = 'Location permission denied or service is off.';
//         });
//         return await _stationService.getStations(context);
//       }

//       Position userPos = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);

//       List<StationModel> stations = await _stationService.getStations(context);

//       for (var station in stations) {
//         if (station.stationAdress != null) {
//           final match =
//               RegExp(r'([-]?[0-9]+(?:\.[0-9]+)?),([-]?[0-9]+(?:\.[0-9]+)?)')
//                   .firstMatch(station.stationAdress!);
//           if (match != null) {
//             double lat = double.tryParse(match.group(1) ?? '') ?? 0;
//             double lng = double.tryParse(match.group(2) ?? '') ?? 0;
//             double dist = Geolocator.distanceBetween(
//                 userPos.latitude, userPos.longitude, lat, lng);
//             station.distance = dist;
//           } else {
//             station.distance = double.infinity;
//           }
//         } else {
//           station.distance = double.infinity;
//         }
//       }

//       stations.sort((a, b) => (a.distance ?? double.infinity)
//           .compareTo(b.distance ?? double.infinity));

//       return stations;
//     } catch (e) {
//       setState(() {
//         locationError = 'Failed to load stations: $e';
//       });
//       return await _stationService.getStations(context);
//     }
//   }

//   void loadGovernorates() async {
//     try {
//       final result = await GovernorateService.getAllGovernorates();
//       setState(() {
//         _governorates = result;
//       });
//     } catch (e) {
//       print("Error loading governorates: $e");
//       setState(() {
//         locationError = 'Failed to load governorates: $e';
//       });
//     }
//   }

//   void loadCities() async {
//     try {
//       final result = await _cityService.getCities();
//       setState(() {
//         _cities = result;
//         _filteredCities = result;
//       });
//     } catch (e) {
//       print("Error loading cities: $e");
//       setState(() {
//         locationError = 'Failed to load cities: $e';
//       });
//     }
//   }

//   void _filterCitiesByGovernorate(int? governorateId) {
//     setState(() {
//       if (governorateId == null) {
//         _filteredCities = _cities;
//         _selectedCity = null;
//       } else {
//         _filteredCities = _cities
//             .where((city) => city.governorateId == governorateId)
//             .toList();
//         _selectedCity = null;
//       }
//     });
//   }

//   String? getGovernorateNameById(int? id) {
//     final match = _governorates.firstWhere(
//       (gov) => gov.governorateId == id,
//       orElse: () => GovernorateModel(
//           governorateId: 0, governorateName: '', governorateLatName: ''),
//     );
//     final name = match.governorateLatName;
//     return name.isNotEmpty ? name : 'Unknown';
//   }

//   String? getCityNameById(int? id) {
//     final match = _cities.firstWhere(
//       (city) => city.cityId == id,
//       orElse: () =>
//           CityModel(cityId: 0, cityLatName: '', cityName: '', governorateId: 0),
//     );
//     final name = match.cityLatName;
//     return name.isNotEmpty ? name : 'Unknown';
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
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           '/dashboard', // Replace with your dashboard route
//           (route) => false, // Clear entire stack
//         );
//         return false; // Prevent default pop
//       },
//       child: Scaffold(
//         backgroundColor: backgroundColor,
//         appBar: AppBar(
//           backgroundColor: backgroundColor,
//           title: Row(
//             children: [
//               LogoRow(),
//               const Spacer(),
//               if (widget.service != null)
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       widget.service!.serviceLatDescription,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ),
//               const Spacer(),
//               ConstrainedBox(
//                 constraints: const BoxConstraints(maxWidth: 100),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       name,
//                       style: TextStyle(
//                         fontSize: 20,
//                         color: primaryColor,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(10),
//               child: TextField(
//                 decoration: InputDecoration(
//                   labelText: 'stations_page.search'.tr,
//                   border: const OutlineInputBorder(),
//                   prefixIcon: const Icon(Icons.search),
//                 ),
//                 textAlign: TextAlign.left,
//                 onChanged: (value) {
//                   setState(() {
//                     _searchQuery = value.toLowerCase();
//                   });
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: DropdownButtonFormField<GovernorateModel>(
//                       decoration: InputDecoration(
//                         labelText: "Select governorate".tr,
//                         border: const OutlineInputBorder(),
//                         prefixIcon: const Icon(Icons.filter_alt),
//                       ),
//                       isExpanded: true,
//                       value: _selectedGovernorate,
//                       hint: Text("Choose governorate".tr),
//                       items: [
//                         DropdownMenuItem<GovernorateModel>(
//                           value: null,
//                           child: Text("Choose governorate".tr),
//                         ),
//                         ..._governorates
//                             .map((gov) => DropdownMenuItem<GovernorateModel>(
//                                   value: gov,
//                                   child: Text(gov.governorateLatName),
//                                 )),
//                       ],
//                       onChanged: (GovernorateModel? newValue) {
//                         setState(() {
//                           _selectedGovernorate = newValue;
//                           _filterCitiesByGovernorate(newValue?.governorateId);
//                         });
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: DropdownButtonFormField<CityModel>(
//                       decoration: InputDecoration(
//                         labelText: "Select city".tr,
//                         border: const OutlineInputBorder(),
//                         prefixIcon: const Icon(Icons.filter_alt),
//                       ),
//                       isExpanded: true,
//                       value: _selectedCity,
//                       hint: Text("Choose city".tr),
//                       items: [
//                         DropdownMenuItem<CityModel>(
//                           value: null,
//                           child: Text("Choose city".tr),
//                         ),
//                         ..._filteredCities
//                             .map((city) => DropdownMenuItem<CityModel>(
//                                   value: city,
//                                   child: Text(city.cityLatName),
//                                 )),
//                       ],
//                       onChanged: (CityModel? newValue) {
//                         setState(() {
//                           _selectedCity = newValue;
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (locationError != null)
//               Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Text(
//                   locationError!,
//                   style: const TextStyle(color: Colors.redAccent, fontSize: 14),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             Expanded(
//               child: FutureBuilder<List<StationModel>>(
//                 future: _stationsFuture,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const LoadingScreen();
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('stations_page.failed_load'.tr));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return Center(child: Text('stations_page.no_stations'.tr));
//                   }

//                   var stations = snapshot.data!.where((station) {
//                     final stationName = station.stationName.toLowerCase();
//                     return stationName.contains(_searchQuery);
//                   }).toList();

//                   if (_selectedGovernorate != null) {
//                     stations = stations
//                         .where((station) =>
//                             station.governorateId ==
//                             _selectedGovernorate!.governorateId)
//                         .toList();
//                   }

//                   if (_selectedCity != null) {
//                     stations = stations
//                         .where((station) =>
//                             station.cityId == _selectedCity!.cityId)
//                         .toList();
//                   }

//                   return ListView.builder(
//                     padding: const EdgeInsets.all(10),
//                     itemCount: stations.length,
//                     itemBuilder: (context, index) {
//                       final station = stations[index];
//                       final govName =
//                           getGovernorateNameById(station.governorateId) ??
//                               station.stationGovernment ??
//                               'stations_page.station_address'.tr;
//                       final cityName =
//                           getCityNameById(station.cityId) ?? 'Unknown City';
//                       final distance = station.distance != null &&
//                               station.distance != double.infinity
//                           ? '${(station.distance! / 1000).toStringAsFixed(2)} km'
//                           : 'Unknown distance';
//                       final subtitle = '$govName, $cityName ($distance)';

//                       return GestureDetector(
//                         onTap: () => _navigateToDetails(context, station),
//                         child: Card(
//                           color: Colors.white,
//                           margin: const EdgeInsets.only(bottom: 15),
//                           elevation: 5,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: ListTile(
//                             leading: const Icon(Icons.location_on,
//                                 color: primaryColor),
//                             title: Text(station.stationName),
//                             subtitle: Text(subtitle),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/governorate_model.dart';
import 'package:total_energies/models/service_model.dart';
import 'package:total_energies/models/service_station_model.dart';
import 'package:total_energies/models/city_model.dart';
import 'package:total_energies/screens/Stations/station_details_screen.dart';
import 'package:total_energies/screens/loading_screen.dart';
import 'package:total_energies/services/governorate_service.dart';
import 'package:total_energies/services/city_service.dart';
import 'package:total_energies/services/get_stations_by_service_code_service.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';
import 'package:geolocator/geolocator.dart';

class StationListScreen extends StatefulWidget {
  final ServiceModel service;

  const StationListScreen({super.key, required this.service});

  @override
  State<StationListScreen> createState() => _StationListScreenState();
}

class _StationListScreenState extends State<StationListScreen> {
  final GovernorateService _governorateService = GovernorateService();
  final CityService _cityService = CityService();

  late Future<List<ServiceStationModel>> _stationsFuture;
  List<GovernorateModel> _governorates = [];
  List<CityModel> _cities = [];
  List<CityModel> _filteredCities = [];
  String _searchQuery = "";
  String name = "";
  GovernorateModel? _selectedGovernorate;
  CityModel? _selectedCity;
  String? locationError;

  @override
  void initState() {
    super.initState();
    _stationsFuture = _loadStations();
    loadGovernorates();
    loadCities();
    loadUserData();
  }

  Future<List<ServiceStationModel>> _loadStations() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (!serviceEnabled ||
          permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          locationError = 'Location permission denied or service is off.';
        });
        return await GetStationsByServiceCodeService.fetchStationsByServiceCode(
            widget.service.serviceCode);
      }

      Position userPos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<ServiceStationModel> stations =
          await GetStationsByServiceCodeService.fetchStationsByServiceCode(
              widget.service.serviceCode);

      for (var station in stations) {
        if (station.stationAddress != null) {
          final match =
              RegExp(r'([-]?[0-9]+(?:\.[0-9]+)?),([-]?[0-9]+(?:\.[0-9]+)?)')
                  .firstMatch(station.stationAddress!);
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

      stations.sort((a, b) => (a.distance ?? double.infinity)
          .compareTo(b.distance ?? double.infinity));

      return stations;
    } catch (e) {
      setState(() {
        locationError = 'Failed to load stations: $e';
      });
      return await GetStationsByServiceCodeService.fetchStationsByServiceCode(
          widget.service.serviceCode);
    }
  }

  void loadGovernorates() async {
    try {
      final result = await GovernorateService.getAllGovernorates();
      setState(() {
        _governorates = result;
      });
    } catch (e) {
      print("Error loading governorates: $e");
      setState(() {
        locationError = 'Failed to load governorates: $e';
      });
    }
  }

  void loadCities() async {
    try {
      final result = await _cityService.getCities();
      setState(() {
        _cities = result;
        _filteredCities = result;
      });
    } catch (e) {
      print("Error loading cities: $e");
      setState(() {
        locationError = 'Failed to load cities: $e';
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
    });
  }

  String? getGovernorateNameById(int? id) {
    final match = _governorates.firstWhere(
      (gov) => gov.governorateId == id,
      orElse: () => GovernorateModel(
          governorateId: 0, governorateName: '', governorateLatName: ''),
    );
    final name = match.governorateLatName;
    return name.isNotEmpty ? name : 'Unknown';
  }

  String? getCityNameById(int? id) {
    final match = _cities.firstWhere(
      (city) => city.cityId == id,
      orElse: () =>
          CityModel(cityId: 0, cityLatName: '', cityName: '', governorateId: 0),
    );
    final name = match.cityLatName;
    return name.isNotEmpty ? name : 'Unknown';
  }

  void _navigateToDetails(BuildContext context, ServiceStationModel station) {
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/dashboard',
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Row(
            children: [
              LogoRow(),
              const Spacer(),
              Expanded(
                child: Center(
                  child: Text(
                    widget.service.serviceLatDescription,
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
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
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
                  prefixIcon: const Icon(Icons.search),
                ),
                textAlign: TextAlign.left,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<GovernorateModel>(
                      decoration: InputDecoration(
                        labelText: "Select city".tr,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.filter_alt),
                      ),
                      isExpanded: true,
                      value: _selectedGovernorate,
                      hint: Text("Select city".tr),
                      items: [
                        DropdownMenuItem<GovernorateModel>(
                          value: null,
                          child: Text("Select city".tr),
                        ),
                        ..._governorates
                            .map((gov) => DropdownMenuItem<GovernorateModel>(
                                  value: gov,
                                  child: Text(gov.governorateLatName),
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
                        labelText: "Select area".tr,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.filter_alt),
                      ),
                      isExpanded: true,
                      value: _selectedCity,
                      hint: Text("Select area".tr),
                      items: [
                        DropdownMenuItem<CityModel>(
                          value: null,
                          child: Text("Select area".tr),
                        ),
                        ..._filteredCities
                            .map((city) => DropdownMenuItem<CityModel>(
                                  value: city,
                                  child: Text(city.cityLatName),
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
            if (locationError != null)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  locationError!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            Expanded(
              child: FutureBuilder<List<ServiceStationModel>>(
                future: _stationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingScreen();
                  } else if (snapshot.hasError) {
                    return Center(child: Text('stations_page.failed_load'.tr));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('stations_page.no_stations'.tr));
                  }

                  var stations = snapshot.data!.where((station) {
                    final stationName = station.stationName.toLowerCase();
                    return stationName.contains(_searchQuery);
                  }).toList();

                  if (_selectedGovernorate != null) {
                    stations = stations
                        .where((station) =>
                            station.governorateId ==
                            _selectedGovernorate!.governorateId)
                        .toList();
                  }

                  if (_selectedCity != null) {
                    stations = stations
                        .where((station) =>
                            station.cityId == _selectedCity!.cityId)
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
                      final distance = station.distance != null &&
                              station.distance != double.infinity
                          ? '${(station.distance! / 1000).toStringAsFixed(2)} km'
                          : 'Unknown distance';
                      // final subtitle = '$govName, $cityName ($distance)';

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
                            leading: const Icon(
                                Icons.local_gas_station_outlined,
                                color: primaryColor),
                            title: Text(station.stationName),
                            subtitle: Row(
                              children: [
                                Text('$govName, $cityName'),
                                const SizedBox(width: 6),
                                const Icon(Icons.location_on_outlined,
                                    size: 16, color: Colors.grey), // 🏃 icon
                                const SizedBox(width: 4),
                                Text('$distance'),
                              ],
                            ),
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
      ),
    );
  }
}
