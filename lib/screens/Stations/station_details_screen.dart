// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/get_navigation.dart';
// import 'package:get/get_utils/get_utils.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/service_model.dart';
// import 'package:total_energies/models/stations_model.dart';
// import 'package:total_energies/models/promotions_model.dart';
// import 'package:total_energies/models/governorate_model.dart';
// import 'package:total_energies/models/city_model.dart';
// import 'package:total_energies/screens/Promotions/apply_to_promo_det.dart';
// import 'package:total_energies/screens/Stations/stations_screen.dart';
// import 'package:total_energies/screens/loading_screen.dart';
// import 'package:total_energies/services/service_service.dart';
// import 'package:total_energies/services/promotions_service.dart';
// import 'package:total_energies/services/governorate_service.dart';
// import 'package:total_energies/services/city_service.dart';
// import 'package:total_energies/services/station_service.dart';
// import 'package:total_energies/services/get_curr_promo_service.dart';
// import 'package:total_energies/services/get_exp_promo_service.dart';
// import 'package:total_energies/widgets/global/app_bar_logos.dart';
// import 'package:total_energies/widgets/Promotions/all_promo_card.dart';
// import 'package:total_energies/widgets/stations/maps.dart';

// class StationDetailsScreen extends StatefulWidget {
//   final StationModel station;

//   const StationDetailsScreen({super.key, required this.station});

//   @override
//   State<StationDetailsScreen> createState() => _StationDetailsScreenState();
// }

// class _StationDetailsScreenState extends State<StationDetailsScreen> {
//   final PromotionsService _promotionsService = PromotionsService();
//   final GovernorateService _governorateService = GovernorateService();
//   final CityService _cityService = CityService();
//   final StationService _stationService = StationService();
//   late Future<List<ServiceModel>> _servicesFuture;
//   late Future<void> _loadDataFuture;
//   List<PromotionsModel> _promotions = [];
//   List<PromotionsModel> _filteredPromotions = [];
//   Set<int> _currPromoSerials = {};
//   Set<int> _expPromoSerials = {};
//   String _filter = 'All';
//   List<GovernorateModel> _governorates = [];
//   List<CityModel> _cities = [];
//   List<StationModel> _stations = [];
//   List<CityModel> _filteredCities = [];
//   GovernorateModel? _selectedGovernorate;
//   CityModel? _selectedCity;
//   String? filterError;
//   bool isLoadingFilters = true;

//   @override
//   void initState() {
//     super.initState();
//     _servicesFuture = GetAllServicesService.fetchAllServices();
//     _loadDataFuture = _loadData();
//   }

//   Future<void> _loadData() async {
//     try {
//       // Load promotions and related data
//       _promotions = await _promotionsService.getPromotions(context);
//       final currPromos = await GetCurrPromoService().getCurrPromotions(context);
//       _currPromoSerials = currPromos.map((e) => e.serial).toSet();
//       final expPromos = await GetExpPromoService().getExpPromotions(context);
//       _expPromoSerials = expPromos.map((e) => e.serial).toSet();

//       // Load filter data
//       _governorates = await GovernorateService.getAllGovernorates();
//       _cities = await _cityService.getCities();
//       _stations = await _stationService.getStations(context);

//       setState(() {
//         _filteredCities = _cities;
//         isLoadingFilters = false;
//         _applyFilter();
//       });
//     } catch (e) {
//       print("Error loading data: $e");
//       setState(() {
//         filterError = e.toString();
//         isLoadingFilters = false;
//       });
//       rethrow; // Let FutureBuilder handle the error
//     }
//   }

//   void _applyFilter() {
//     _filteredPromotions = _promotions.where((promo) {
//       // Filter by station
//       bool passesStationFilter =
//           promo.stations!.contains(widget.station.serial);
//       if (!passesStationFilter) return false;

//       // Filter by status (only Available and Ongoing)
//       final isCurr = _currPromoSerials.contains(promo.serial);
//       final isExp = _expPromoSerials.contains(promo.serial);
//       final isAvailable = !isCurr && !isExp;

//       bool passesStatusFilter = true;
//       switch (_filter) {
//         case 'Available':
//           passesStatusFilter = isAvailable;
//           break;
//         case 'Ongoing':
//           passesStatusFilter = isCurr;
//           break;
//         default: // 'All' includes only Available and Ongoing
//           passesStatusFilter = isAvailable || isCurr;
//       }

//       // Apply governorate and city filter
//       bool passesLocationFilter = true;
//       if (_selectedGovernorate != null || _selectedCity != null) {
//         final promoStations = _stations
//             .where(
//                 (station) => promo.stations?.contains(station.serial) ?? false)
//             .toList();
//         if (_selectedGovernorate != null) {
//           passesLocationFilter = promoStations.any((station) =>
//               station.governorateId == _selectedGovernorate!.governorateId);
//         }
//         if (_selectedCity != null) {
//           passesLocationFilter = passesLocationFilter &&
//               promoStations
//                   .any((station) => station.cityId == _selectedCity!.cityId);
//         }
//       }

//       return passesStatusFilter && passesLocationFilter;
//     }).toList();

//     setState(() {});
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
//       _applyFilter();
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
//               widget.station.stationName,
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
//             // Station Details Section
//             _buildStationDetails(),
//             const SizedBox(height: 30),
//             // Services Section
//             _buildAvailableServices(context),
//             const SizedBox(height: 30),
//             // Promotions Section
//             _buildRelatedPromotions(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStationDetails() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Station Name: ${widget.station.stationName ?? 'N/A'}",
//           style: const TextStyle(fontSize: 18),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           "Address: ${widget.station.stationAdress ?? 'N/A'}",
//           style: const TextStyle(fontSize: 18),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           "Government: ${widget.station.stationGovernment ?? 'N/A'}",
//           style: const TextStyle(fontSize: 18),
//         ),
//         const SizedBox(height: 8),
//         OpenMapLinkButton(
//           mapUrl: widget.station.stationAdress ?? '',
//         ),
//       ],
//     );
//   }

//   Widget _buildAvailableServices(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Available Services',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: 160, // Fixed height to prevent shrinking
//           child: FutureBuilder<List<ServiceModel>>(
//             future: _servicesFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: LoadingScreen());
//               } else if (snapshot.hasError) {
//                 return Center(
//                   child: Column(
//                     children: [
//                       Text(
//                         'Check internet connection',
//                         style: const TextStyle(
//                             color: Colors.redAccent, fontSize: 16),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             // isLoadingFilters = true;
//                             // filterError = null;
//                             _loadDataFuture = _loadData();
//                             // _servicesFuture;
//                           });
//                         },
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: primaryColor),
//                         child: const Text(
//                           'Retry',
//                           style: TextStyle(color: btntxtColors, fontSize: 16),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }

//               final services = snapshot.data!.where((s) => s.activeYN).toList();

//               if (services.isEmpty) {
//                 return const Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Text('No active services available.'),
//                 );
//               }

//               return ListView.separated(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: services.length,
//                 separatorBuilder: (context, index) => const SizedBox(width: 20),
//                 itemBuilder: (context, index) {
//                   final service = services[index];
//                   return InkWell(
//                     onTap: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: Text(
//                             'Explore Service',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: primaryColor,
//                             ),
//                           ),
//                           content: Text(
//                             'Explore service in other stations?',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.pop(context); // Dismiss dialog
//                               },
//                               child: Text(
//                                 'No',
//                                 style: TextStyle(color: Colors.redAccent),
//                               ),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.pop(context); // Dismiss dialog
//                                 // Pop until dashboard or root, then push StationListScreen
//                                 Navigator.popUntil(
//                                   context,
//                                   (route) =>
//                                       route.isFirst ||
//                                       route.settings.name == '/dashboard',
//                                 );
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         StationListScreen(service: service),
//                                   ),
//                                 );
//                               },
//                               child: Text(
//                                 'Yes',
//                                 style: TextStyle(color: primaryColor),
//                               ),
//                             ),
//                           ],
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
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildRelatedPromotions() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Promotions at This Station',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         FutureBuilder<void>(
//           future: _loadDataFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const SizedBox(
//                 height: 200, // Reserve space for loading
//                 child: Center(child: CircularProgressIndicator()),
//               );
//             } else if (snapshot.hasError) {
//               return SizedBox(
//                 height: 200, // Reserve space for error
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Check internet connection',
//                         style: const TextStyle(
//                             color: Colors.redAccent, fontSize: 16),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             _loadDataFuture = _loadData();
//                           });
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: primaryColor,
//                         ),
//                         child: const Text(
//                           "Retry",
//                           style: TextStyle(color: btntxtColors, fontSize: 16),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                   child: Row(
//                     children: ['All', 'Available', 'Ongoing']
//                         .map((label) => Padding(
//                               padding: const EdgeInsets.only(right: 8.0),
//                               child: ChoiceChip(
//                                 label: Text(label),
//                                 selected: _filter == label,
//                                 onSelected: (_) => setState(() {
//                                   _filter = label;
//                                   _applyFilter();
//                                 }),
//                                 selectedColor: primaryColor,
//                               ),
//                             ))
//                         .toList(),
//                   ),
//                 ),
//                 if (isLoadingFilters)
//                   const SizedBox(
//                     height: 100, // Reserve space for filter loading
//                     child: Center(child: CircularProgressIndicator()),
//                   )
//                 else if (filterError != null)
//                   SizedBox(
//                     height: 100, // Reserve space for filter error
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Check internet connection',
//                             style: const TextStyle(
//                                 color: Colors.redAccent, fontSize: 16),
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 10),
//                           ElevatedButton(
//                             onPressed: () {
//                               setState(() {
//                                 isLoadingFilters = true;
//                                 filterError = null;
//                                 _loadDataFuture = _loadData();
//                               });
//                             },
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: primaryColor),
//                             child: const Text(
//                               'Retry',
//                               style:
//                                   TextStyle(color: btntxtColors, fontSize: 16),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 else
//                   Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: DropdownButtonFormField<GovernorateModel>(
//                             decoration: InputDecoration(
//                               labelText: "Select governorate".tr,
//                               border: const OutlineInputBorder(),
//                               prefixIcon: const Icon(Icons.filter_alt),
//                             ),
//                             isExpanded: true,
//                             value: _selectedGovernorate,
//                             hint: Text("Choose governorate".tr),
//                             items: [
//                               DropdownMenuItem<GovernorateModel>(
//                                 value: null,
//                                 child: Text("Choose governorate".tr),
//                               ),
//                               ..._governorates.map(
//                                   (gov) => DropdownMenuItem<GovernorateModel>(
//                                         value: gov,
//                                         child: Text(gov.governorateLatName),
//                                       )),
//                             ],
//                             onChanged: (GovernorateModel? newValue) {
//                               setState(() {
//                                 _selectedGovernorate = newValue;
//                                 _filterCitiesByGovernorate(
//                                     newValue?.governorateId);
//                               });
//                             },
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: DropdownButtonFormField<CityModel>(
//                             decoration: InputDecoration(
//                               labelText: "Select city".tr,
//                               border: const OutlineInputBorder(),
//                               prefixIcon: const Icon(Icons.filter_alt),
//                             ),
//                             isExpanded: true,
//                             value: _selectedCity,
//                             hint: Text("Choose city".tr),
//                             items: [
//                               DropdownMenuItem<CityModel>(
//                                 value: null,
//                                 child: Text("Choose city".tr),
//                               ),
//                               ..._filteredCities
//                                   .map((city) => DropdownMenuItem<CityModel>(
//                                         value: city,
//                                         child: Text(city.cityLatName),
//                                       )),
//                             ],
//                             onChanged: (CityModel? newValue) {
//                               setState(() {
//                                 _selectedCity = newValue;
//                                 _applyFilter();
//                               });
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 const SizedBox(height: 10),
//                 _filteredPromotions.isEmpty
//                     ? const SizedBox(
//                         height: 100, // Reserve space for empty state
//                         child: Center(
//                           child: Text(
//                             'No promotions available for this station.',
//                             style: TextStyle(
//                               color: Colors.red,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       )
//                     : ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: _filteredPromotions.length,
//                         itemBuilder: (context, index) {
//                           final promo = _filteredPromotions[index];
//                           final isCurr =
//                               _currPromoSerials.contains(promo.serial);
//                           final isExp = _expPromoSerials.contains(promo.serial);
//                           final isBlocked = isCurr || isExp;

//                           String statusLabel = 'Available';
//                           Color statusColor = Colors.green;
//                           if (isCurr) {
//                             statusLabel = 'Ongoing';
//                             statusColor = Colors.orange;
//                           } else if (isExp) {
//                             statusLabel = 'Expired';
//                             statusColor = Colors.grey;
//                           }

//                           return Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 6),
//                             child: AllPromoCard(
//                               serial: promo.serial,
//                               imagepath: promo.imagePath ?? '',
//                               title: promo.eventTopic ?? '',
//                               description: promo.eventDescription ?? '',
//                               startDate: promo.startDate,
//                               endDate: promo.endDate,
//                               total: promo.qrMaxUsage,
//                               used: promo.usedTimes,
//                               isBlocked: isBlocked,
//                               statusLabel: statusLabel,
//                               statusColor: statusColor,
//                               onTap: () {
//                                 if (!isBlocked) {
//                                   Get.to(
//                                       () => ApplyToPromoDet(promotion: promo));
//                                 }
//                               },
//                             ),
//                           );
//                         },
//                       ),
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/service_model.dart';
import 'package:total_energies/models/service_station_model.dart';
import 'package:total_energies/models/promotions_model.dart';
import 'package:total_energies/models/governorate_model.dart';
import 'package:total_energies/models/city_model.dart';
import 'package:total_energies/screens/Promotions/apply_to_promo_det.dart';
import 'package:total_energies/screens/Stations/stations_screen.dart';
import 'package:total_energies/screens/loading_screen.dart';
import 'package:total_energies/services/get_stations_by_service_code_service.dart';
import 'package:total_energies/services/service_service.dart';
import 'package:total_energies/services/promotions_service.dart';
import 'package:total_energies/services/governorate_service.dart';
import 'package:total_energies/services/city_service.dart';
import 'package:total_energies/services/get_curr_promo_service.dart';
import 'package:total_energies/services/get_exp_promo_service.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';
import 'package:total_energies/widgets/Promotions/all_promo_card.dart';
import 'package:total_energies/widgets/stations/maps.dart';

class StationDetailsScreen extends StatefulWidget {
  final ServiceStationModel station;

  const StationDetailsScreen({super.key, required this.station});

  @override
  State<StationDetailsScreen> createState() => _StationDetailsScreenState();
}

class _StationDetailsScreenState extends State<StationDetailsScreen> {
  final PromotionsService _promotionsService = PromotionsService();
  final GovernorateService _governorateService = GovernorateService();
  final CityService _cityService = CityService();
  late Future<List<ServiceModel>> _servicesFuture;
  late Future<void> _loadDataFuture;
  List<PromotionsModel> _promotions = [];
  List<PromotionsModel> _filteredPromotions = [];
  Set<int> _currPromoSerials = {};
  Set<int> _expPromoSerials = {};
  String _filter = 'All';
  List<GovernorateModel> _governorates = [];
  List<CityModel> _cities = [];
  List<ServiceStationModel> _stations = [];
  List<CityModel> _filteredCities = [];
  GovernorateModel? _selectedGovernorate;
  CityModel? _selectedCity;
  String? filterError;
  bool isLoadingFilters = true;

  @override
  void initState() {
    super.initState();
    _servicesFuture = GetAllServicesService.fetchAllServices();
    _loadDataFuture = _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Load promotions and related data
      _promotions = await _promotionsService.getPromotions(context);
      final currPromos = await GetCurrPromoService().getCurrPromotions(context);
      _currPromoSerials = currPromos.map((e) => e.serial).toSet();
      final expPromos = await GetExpPromoService().getExpPromotions(context);
      _expPromoSerials = expPromos.map((e) => e.serial).toSet();

      // Load filter data
      _governorates = await GovernorateService.getAllGovernorates();
      _cities = await _cityService.getCities();
      _stations =
          await GetStationsByServiceCodeService.fetchStationsByServiceCode(
              widget.station.serial); // Use service code from station serial

      setState(() {
        _filteredCities = _cities;
        isLoadingFilters = false;
        _applyFilter();
      });
    } catch (e) {
      print("Error loading data: $e");
      setState(() {
        filterError = e.toString();
        isLoadingFilters = false;
      });
      rethrow;
    }
  }

  void _applyFilter() {
    _filteredPromotions = _promotions.where((promo) {
      bool passesStationFilter =
          promo.stations!.contains(widget.station.serial);
      if (!passesStationFilter) return false;

      final isCurr = _currPromoSerials.contains(promo.serial);
      final isExp = _expPromoSerials.contains(promo.serial);
      final isAvailable = !isCurr && !isExp;

      bool passesStatusFilter = true;
      switch (_filter) {
        case 'Available':
          passesStatusFilter = isAvailable;
          break;
        case 'Ongoing':
          passesStatusFilter = isCurr;
          break;
        default:
          passesStatusFilter = isAvailable || isCurr;
      }

      bool passesLocationFilter = true;
      if (_selectedGovernorate != null || _selectedCity != null) {
        final promoStations = _stations
            .where(
                (station) => promo.stations?.contains(station.serial) ?? false)
            .toList();
        if (_selectedGovernorate != null) {
          passesLocationFilter = promoStations.any((station) =>
              station.governorateId == _selectedGovernorate!.governorateId);
        }
        if (_selectedCity != null) {
          passesLocationFilter = passesLocationFilter &&
              promoStations
                  .any((station) => station.cityId == _selectedCity!.cityId);
        }
      }

      return passesStatusFilter && passesLocationFilter;
    }).toList();

    setState(() {});
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
      _applyFilter();
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
            _buildStationDetails(),
            const SizedBox(height: 30),
            _buildAvailableServices(context),
            const SizedBox(height: 30),
            _buildRelatedPromotions(),
          ],
        ),
      ),
    );
  }

  Widget _buildStationDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Station Name: ${widget.station.stationName ?? 'N/A'}",
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          "Address: ${widget.station.stationAddress ?? 'N/A'}",
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          "Government: ${widget.station.stationGovernment ?? 'N/A'}",
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 8),
        OpenMapLinkButton(
          mapUrl: widget.station.stationAddress ?? '',
        ),
      ],
    );
  }

  Widget _buildAvailableServices(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Services',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 160,
          child: FutureBuilder<List<ServiceModel>>(
            future: _servicesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: LoadingScreen());
              } else if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    children: [
                      Text(
                        'No services available for this station',
                        style: const TextStyle(
                            color: Colors.redAccent, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      Text(
                        'Check internet connection',
                        style: const TextStyle(
                            color: Colors.redAccent, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _servicesFuture =
                                GetAllServicesService.fetchAllServices();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        child: const Text(
                          'Retry',
                          style: TextStyle(color: btntxtColors, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final services = snapshot.data!.where((s) => s.activeYN).toList();

              if (services.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No active services available.'),
                );
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: services.length,
                separatorBuilder: (context, index) => const SizedBox(width: 20),
                itemBuilder: (context, index) {
                  final service = services[index];
                  return InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            'Explore Service',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          content: Text(
                            'Explore service in other stations?',
                            style: TextStyle(fontSize: 16),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'No',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.popUntil(
                                  context,
                                  (route) =>
                                      route.isFirst ||
                                      route.settings.name == '/dashboard',
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        StationListScreen(service: service),
                                  ),
                                );
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ],
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
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedPromotions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Promotions at This Station',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        FutureBuilder<void>(
          future: _loadDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 200,
                child: Center(child: LoadingScreen()),
              );
            } else if (!snapshot.hasData) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No promotions available in this station',
                        style: const TextStyle(
                            color: Colors.redAccent, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Check Internet Connection',
                        style: const TextStyle(
                            color: Colors.redAccent, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _loadDataFuture = _loadData();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                        ),
                        child: const Text(
                          "Retry",
                          style: TextStyle(color: btntxtColors, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    children: ['All', 'Available', 'Ongoing']
                        .map((label) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(label),
                                selected: _filter == label,
                                onSelected: (_) => setState(() {
                                  _filter = label;
                                  _applyFilter();
                                }),
                                selectedColor: primaryColor,
                              ),
                            ))
                        .toList(),
                  ),
                ),
                if (isLoadingFilters)
                  const SizedBox(
                    height: 100,
                    child: Center(child: LoadingScreen()),
                  )
                else if (filterError != null)
                  SizedBox(
                    height: 100,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Check internet connection',
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
                                _loadDataFuture = _loadData();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor),
                            child: const Text(
                              'Retry',
                              style:
                                  TextStyle(color: btntxtColors, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<GovernorateModel>(
                            decoration: InputDecoration(
                              labelText: "Select governorate".tr,
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.filter_alt),
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
                                        child: Text(gov.governorateLatName),
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
                              prefixIcon: const Icon(Icons.filter_alt),
                            ),
                            isExpanded: true,
                            value: _selectedCity,
                            hint: Text("Choose city".tr),
                            items: [
                              DropdownMenuItem<CityModel>(
                                value: null,
                                child: Text("Choose city".tr),
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
                                _applyFilter();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
                _filteredPromotions.isEmpty
                    ? const SizedBox(
                        height: 100,
                        child: Center(
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
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredPromotions.length,
                        itemBuilder: (context, index) {
                          final promo = _filteredPromotions[index];
                          final isCurr =
                              _currPromoSerials.contains(promo.serial);
                          final isExp = _expPromoSerials.contains(promo.serial);
                          final isBlocked = isCurr || isExp;

                          String statusLabel = 'Available';
                          Color statusColor = Colors.green;
                          if (isCurr) {
                            statusLabel = 'Ongoing';
                            statusColor = Colors.orange;
                          } else if (isExp) {
                            statusLabel = 'Expired';
                            statusColor = Colors.grey;
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: AllPromoCard(
                              serial: promo.serial,
                              imagepath: promo.imagePath ?? '',
                              title: promo.eventTopic ?? '',
                              description: promo.eventDescription ?? '',
                              startDate: promo.startDate,
                              endDate: promo.endDate,
                              total: promo.qrMaxUsage,
                              used: promo.usedTimes,
                              isBlocked: isBlocked,
                              statusLabel: statusLabel,
                              statusColor: statusColor,
                              onTap: () {
                                if (!isBlocked) {
                                  Get.to(
                                      () => ApplyToPromoDet(promotion: promo));
                                }
                              },
                            ),
                          );
                        },
                      ),
              ],
            );
          },
        ),
      ],
    );
  }
}
