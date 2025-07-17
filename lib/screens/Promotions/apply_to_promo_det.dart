import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/promotions_model.dart';
import 'package:total_energies/services/register_to_promotion_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';
import 'package:total_energies/models/governorate_model.dart';
import 'package:total_energies/models/city_model.dart';
import 'package:total_energies/models/stations_model.dart';
import 'package:total_energies/services/governorate_service.dart';
import 'package:total_energies/services/city_service.dart';
import 'package:total_energies/services/station_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:total_energies/widgets/stations/maps.dart';

class ApplyToPromoDet extends StatefulWidget {
  final PromotionsModel promotion;

  const ApplyToPromoDet({super.key, required this.promotion});

  @override
  _ApplyToPromoDetState createState() => _ApplyToPromoDetState();
}

class _ApplyToPromoDetState extends State<ApplyToPromoDet> {
  final RegisterToPromotionService _registerService =
      RegisterToPromotionService();
  final GovernorateService _governorateService = GovernorateService();
  final CityService _cityService = CityService();
  final StationService _stationService = StationService();

  bool _isLoading = false;
  bool _isApplied = false;
  int custserial = 0;
  String? filterError;
  bool isLoadingStations = true;
  bool isLoadingFilters = true;

  List<StationModel> nearbyStations = [];
  List<StationModel> filteredStations = [];
  List<GovernorateModel> _governorates = [];
  List<CityModel> _cities = [];
  List<CityModel> _filteredCities = [];
  GovernorateModel? _selectedGovernorate;
  CityModel? _selectedCity;
  StationModel? selectedStation;
  String? selectedStationAddressUrl;

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      custserial = prefs.getInt('serial') ?? 0;
    });
  }

  Future<void> loadStations() async {
    try {
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
          .where((s) => widget.promotion.stations?.contains(s.serial) ?? false)
          .toList();

      // Calculate distance to each
      for (var station in filtered) {
        if (station.stationAdress != null) {
          final match =
              RegExp(r'([-]?[0-9]+(?:\.[0-9]+)?),([-]?[0-9]+(?:\.[0-9]+)?)')
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
  void initState() {
    super.initState();
    loadUserData();
    loadStations();
    loadFilters();
  }

  Future<void> _registerToPromo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _registerService.registerToPromo(
        custserial,
        widget.promotion.promotionDetails[0].promotionCode,
        widget.promotion.serial!,
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final success = decoded['success'] == true;
        final message = decoded['message'] ?? 'No message provided';

        if (success) {
          setState(() {
            _isApplied = true;
          });
        }

        Get.snackbar(
          success ? "Success".tr : "Failed".tr,
          message.toString(),
          duration: const Duration(seconds: 5),
          backgroundColor: success ? Colors.green : Colors.red,
          colorText: Colors.white,
          mainButton: TextButton(
            onPressed: () {
              Get.closeCurrentSnackbar();
            },
            child: const Icon(Icons.close, color: Colors.white),
          ),
        );
      } else {
        Get.snackbar(
          "Error".tr,
          response.body,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          mainButton: TextButton(
            onPressed: () {
              Get.closeCurrentSnackbar();
            },
            child: const Icon(Icons.close, color: Colors.white),
          ),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "Something went wrong!".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () {
            Get.closeCurrentSnackbar();
          },
          child: const Icon(Icons.close, color: Colors.white),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const LogoRow(),
      ),
      body: isLoadingStations || isLoadingFilters
          ? const Center(child: CircularProgressIndicator())
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
                                widget.promotion.imagePath!,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset("assets/images/logo.png",
                                        width: 200, height: 200),
                              )
                            : Image.asset("assets/images/logo.png",
                                width: 200, height: 200),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.promotion.eventTopic ?? 'No Title'.tr,
                        style: TextStyle(
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
                              widget.promotion.eventEnDescription ??
                                  'No Description'.tr,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  "all_card.start_date".tr,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  widget.promotion.startDate != null
                                      ? DateFormat('dd/MM/yyyy')
                                          .format(widget.promotion.startDate!)
                                      : 'N/A'.tr,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  "all_card.end_date".tr,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  widget.promotion.endDate != null
                                      ? DateFormat('dd/MM/yyyy')
                                          .format(widget.promotion.endDate!)
                                      : 'N/A'.tr,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  "Max number of usage",
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "${widget.promotion.qrMaxUsage ?? 'N/A'}",
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  "Number of available stations",
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "${widget.promotion.stations?.length ?? 'N/A'}",
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              ],
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
                          final govName =
                              getGovernorateNameById(station.governorateId);
                          final cityName = getCityNameById(station.cityId);
                          subtitle = '$govName, $cityName';
                          return DropdownMenuItem(
                            value: station,
                            child: Text(
                              "${station.stationName} ($subtitle, ${(station.distance! / 1000).toStringAsFixed(2)} km)",
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
                          mapUrl: selectedStationAddressUrl ?? '',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading || _isApplied
                                ? null
                                : _registerToPromo,
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                _isApplied ? Colors.grey : primaryColor,
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(
                                    "all_card.apply_btn".tr,
                                    style: const TextStyle(
                                      color: btntxtColors,
                                      fontSize: 20,
                                    ),
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
