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
      List<StationModel> allStations =
          await _stationService.getStations(context);

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
          content: Text('Failed to load stations'),
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
      final governorates = await GovernorateService.getAllGovernorates();
      final cities = await _cityService.getCities();
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
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
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
                                widget.promotion.imagePath!
                                    .replaceAll('\\', '/'),
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
                          // Not a drop down this displays pop up menu in the middle of the page
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                GovernorateModel? selected =
                                    await showDialog<GovernorateModel>(
                                  context: context,
                                  builder: (context) {
                                    TextEditingController searchController =
                                        TextEditingController();
                                    List<GovernorateModel>
                                        filteredGovernorates =
                                        List.from(_governorates);

                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          backgroundColor: Colors
                                              .white, // 👈 change popup background color here
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                12), // optional: rounded corners
                                          ),
                                          title: Text("Select city".tr),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Search box
                                              TextField(
                                                controller: searchController,
                                                decoration: InputDecoration(
                                                  prefixIcon:
                                                      Icon(Icons.search),
                                                  hintText: "Search city...".tr,
                                                  border: OutlineInputBorder(),
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    filteredGovernorates =
                                                        _governorates
                                                            .where((gov) => gov
                                                                .governorateLatName
                                                                .toLowerCase()
                                                                .contains(value
                                                                    .toLowerCase()))
                                                            .toList();
                                                  });
                                                },
                                              ),
                                              SizedBox(height: 12),

                                              // Governorates list
                                              SizedBox(
                                                width: double.maxFinite,
                                                height: 300, // scrollable list
                                                child: filteredGovernorates
                                                        .isEmpty
                                                    ? Center(
                                                        child: Text(
                                                            "No results".tr))
                                                    : ListView.builder(
                                                        itemCount:
                                                            filteredGovernorates
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final gov =
                                                              filteredGovernorates[
                                                                  index];
                                                          return ListTile(
                                                            title: Text(gov
                                                                .governorateLatName),
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context, gov);
                                                            },
                                                          );
                                                        },
                                                      ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );

                                if (selected != null) {
                                  setState(() {
                                    _selectedGovernorate = selected;
                                    _filterCitiesByGovernorate(
                                        selected.governorateId);
                                  });
                                }
                              },
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: "Select city".tr,
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.filter_alt),
                                ),
                                child: Text(
                                  _selectedGovernorate?.governorateLatName ??
                                      "Select city".tr,
                                  style: TextStyle(
                                    color: _selectedGovernorate == null
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Normal dropdown
                          // Expanded(
                          //   child: DropdownButtonFormField<GovernorateModel>(
                          //     decoration: InputDecoration(
                          //       labelText: "Select city".tr,
                          //       border: const OutlineInputBorder(),
                          //       prefixIcon: const Icon(Icons.filter_alt),
                          //     ),
                          //     isExpanded: true,
                          //     value: _selectedGovernorate,
                          //     hint: Text("Select city".tr),
                          //     items: [
                          //       DropdownMenuItem<GovernorateModel>(
                          //         value: null,
                          //         child: Text("Select city".tr),
                          //       ),
                          //       ..._governorates
                          //           .map((gov) => DropdownMenuItem<GovernorateModel>(
                          //                 value: gov,
                          //                 child: Text(gov.governorateLatName),
                          //               )),
                          //     ],
                          //     onChanged: (GovernorateModel? newValue) {
                          //       setState(() {
                          //         _selectedGovernorate = newValue;
                          //         _filterCitiesByGovernorate(newValue?.governorateId);
                          //       });
                          //     },
                          //   ),
                          // ),
                          const SizedBox(width: 10),
                          // Not a drop down this displays pop up menu in the middle of the page
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                CityModel? selected =
                                    await showDialog<CityModel>(
                                  context: context,
                                  builder: (context) {
                                    TextEditingController searchController =
                                        TextEditingController();
                                    List<CityModel> filteredCities =
                                        List.from(_filteredCities);

                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          backgroundColor: Colors
                                              .white, // 👈 change popup background color here
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                12), // optional: rounded corners
                                          ),
                                          title: Text("Select area".tr),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Search box
                                              TextField(
                                                controller: searchController,
                                                decoration: InputDecoration(
                                                  prefixIcon:
                                                      Icon(Icons.search),
                                                  hintText: "Search area...".tr,
                                                  border: OutlineInputBorder(),
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    filteredCities = _filteredCities
                                                        .where((city) => city
                                                            .cityLatName
                                                            .toLowerCase()
                                                            .contains(value
                                                                .toLowerCase()))
                                                        .toList();
                                                  });
                                                },
                                              ),
                                              SizedBox(height: 12),

                                              // City list
                                              SizedBox(
                                                width: double.maxFinite,
                                                height:
                                                    300, // set height for scroll
                                                child: filteredCities.isEmpty
                                                    ? Center(
                                                        child: Text(
                                                            "No results".tr))
                                                    : ListView.builder(
                                                        itemCount:
                                                            filteredCities
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final city =
                                                              filteredCities[
                                                                  index];
                                                          return ListTile(
                                                            title: Text(city
                                                                .cityLatName),
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context,
                                                                  city);
                                                            },
                                                          );
                                                        },
                                                      ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );

                                if (selected != null) {
                                  setState(() {
                                    _selectedCity = selected;
                                  });
                                }
                              },
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: "Select area".tr,
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.filter_alt),
                                ),
                                child: Text(
                                  _selectedCity?.cityLatName ??
                                      "Select area".tr,
                                  style: TextStyle(
                                    color: _selectedCity == null
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          )

                          // Normal dropdown
                          // Expanded(
                          //   child: DropdownButtonFormField<CityModel>(
                          //     decoration: InputDecoration(
                          //       labelText: "Select area".tr,
                          //       border: const OutlineInputBorder(),
                          //       prefixIcon: const Icon(Icons.filter_alt),
                          //     ),
                          //     isExpanded: true,
                          //     value: _selectedCity,
                          //     hint: Text("Select area".tr),
                          //     items: [
                          //       DropdownMenuItem<CityModel>(
                          //         value: null,
                          //         child: Text("Select area".tr),
                          //       ),
                          //       ..._filteredCities
                          //           .map((city) => DropdownMenuItem<CityModel>(
                          //                 value: city,
                          //                 child: Text(city.cityLatName),
                          //               )),
                          //     ],
                          //     onChanged: (CityModel? newValue) {
                          //       setState(() {
                          //         _selectedCity = newValue;
                          //       });
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Choose Nearest Station".tr,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      // DropdownButtonFormField<StationModel>(
                      //   isExpanded: true,
                      //   value: selectedStation,
                      //   hint: Text("Select nearest station".tr),
                      //   items: filteredStations.map((station) {
                      //     String subtitle = '';
                      //     final govName = getGovernorateNameById(
                      //         station.governorateId, isRTL);
                      //     final cityName =
                      //         getCityNameById(station.cityId, isRTL);
                      //     subtitle = '$govName, $cityName';
                      //     return DropdownMenuItem(
                      //       value: station,
                      //       child: Text(
                      //         "${isRTL ? station.stationArabicName : station.stationName} ($subtitle, ${(station.distance! / 1000).toStringAsFixed(2)} km)",
                      //       ),
                      //     );
                      //   }).toList(),
                      //   onChanged: (station) {
                      //     setState(() {
                      //       selectedStation = station;
                      //       selectedStationAddressUrl = station?.stationAdress;
                      //     });
                      //   },
                      // ),
                      InkWell(
                        onTap: () async {
                          final selected = await showDialog<StationModel>(
                            context: context,
                            builder: (BuildContext context) {
                              TextEditingController searchController =
                                  TextEditingController();
                              List<StationModel> filtered =
                                  List.from(filteredStations);

                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    backgroundColor: Colors
                                        .white, // 👈 change background if needed
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Select nearest station".tr),
                                        const SizedBox(height: 8),
                                        TextField(
                                          controller: searchController,
                                          decoration: InputDecoration(
                                            hintText: "Search station".tr,
                                            prefixIcon:
                                                const Icon(Icons.search),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              filtered = filteredStations
                                                  .where((station) {
                                                final name = isRTL
                                                    ? station.stationArabicName
                                                    : station.stationName;
                                                return name
                                                    .toLowerCase()
                                                    .contains(
                                                        value.toLowerCase());
                                              }).toList();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    content: SizedBox(
                                      width: double.maxFinite,
                                      height: 400,
                                      child: ListView.builder(
                                        itemCount: filtered.length,
                                        itemBuilder: (context, index) {
                                          final station = filtered[index];
                                          final govName =
                                              getGovernorateNameById(
                                                  station.governorateId, isRTL);
                                          final cityName = getCityNameById(
                                              station.cityId, isRTL);
                                          final subtitle =
                                              '$govName, $cityName';

                                          return ListTile(
                                            title: Text(isRTL
                                                ? station.stationArabicName
                                                : station.stationName),
                                            subtitle: Text(
                                              "$subtitle, ${(station.distance! / 1000).toStringAsFixed(2)} km",
                                            ),
                                            onTap: () {
                                              Navigator.pop(context, station);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );

                          if (selected != null) {
                            setState(() {
                              selectedStation = selected;
                              selectedStationAddressUrl =
                                  selected.stationAdress;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: "Select nearest station".tr,
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.local_gas_station),
                          ),
                          child: Text(
                            selectedStation == null
                                ? "Select nearest station".tr
                                : "${isRTL ? selectedStation!.stationArabicName : selectedStation!.stationName}",
                          ),
                        ),
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
                                    content: Text(
                                        'You must choose a station first.'.tr),
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
                                        "You should be in the station to use the promotion you are ${(distanceInMeters / 1000 - allowedRange / 1000).toStringAsFixed(2)} KM away"),
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
