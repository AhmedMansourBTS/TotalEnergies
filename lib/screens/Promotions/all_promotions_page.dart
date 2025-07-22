import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/promotions_model.dart';
import 'package:total_energies/screens/Promotions/apply_to_promo_det.dart';
import 'package:total_energies/screens/loading_screen.dart';
import 'package:total_energies/services/get_curr_promo_service.dart';
import 'package:total_energies/services/get_exp_promo_service.dart';
import 'package:total_energies/services/promotions_service.dart';
import 'package:total_energies/models/governorate_model.dart';
import 'package:total_energies/models/city_model.dart';
import 'package:total_energies/models/stations_model.dart';
import 'package:total_energies/services/governorate_service.dart';
import 'package:total_energies/services/city_service.dart';
import 'package:total_energies/services/station_service.dart';
import 'package:total_energies/widgets/Promotions/all_promo_card.dart';

class AllPromotionsPage extends StatefulWidget {
  const AllPromotionsPage({super.key});

  @override
  State<AllPromotionsPage> createState() => _AllPromotionsPageState();
}

class _AllPromotionsPageState extends State<AllPromotionsPage> {
  final PromotionsService _promotionsService = PromotionsService();
  final GovernorateService _governorateService = GovernorateService();
  final CityService _cityService = CityService();
  final StationService _stationService = StationService();

  late Future<void> _loadDataFuture;
  List<PromotionsModel> _promotions = [];
  List<PromotionsModel> _filteredPromotions = [];
  Set<int> _currPromoSerials = {};
  Set<int> _expPromoSerials = {};
  String _filter = 'All';
  List<GovernorateModel> _governorates = [];
  List<CityModel> _cities = [];
  List<CityModel> _filteredCities = [];
  List<StationModel> _stations = [];
  GovernorateModel? _selectedGovernorate;
  CityModel? _selectedCity;
  String? filterError;
  bool isLoadingFilters = true;

  @override
  void initState() {
    super.initState();
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
      _stations = await _stationService.getStations(context);

      setState(() {
        _filteredCities = _cities;
        isLoadingFilters = false;
      });

      _applyFilter();
    } catch (e) {
      print("Error loading data: $e");
      setState(() {
        filterError = e.toString();
        isLoadingFilters = false;
      });
      rethrow; // Let FutureBuilder handle the error
    }
  }

  void _applyFilter() {
    _filteredPromotions = _promotions.where((promo) {
      final isCurr = _currPromoSerials.contains(promo.serial);
      final isExp = _expPromoSerials.contains(promo.serial);
      final isAvailable = !isCurr && !isExp;

      // Apply status filter
      bool passesStatusFilter = true;
      switch (_filter) {
        case 'Available':
          passesStatusFilter = isAvailable;
          break;
        case 'Ongoing':
          passesStatusFilter = isCurr;
          break;
        case 'Consumed':
          passesStatusFilter = isExp;
          break;
        default:
          passesStatusFilter = true;
      }

      // Apply governorate and city filter
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

  void _onFilterChanged(String filter) {
    setState(() {
      _filter = filter;
      _applyFilter();
    });
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
      body: FutureBuilder<void>(
        future: _loadDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingScreen());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Check internet connection',
                    style:
                        const TextStyle(color: Colors.redAccent, fontSize: 16),
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
            );
          }

          return Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: ['All', 'Available', 'Ongoing', 'Consumed']
                      .map((label) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(label),
                              selected: _filter == label,
                              onSelected: (_) => _onFilterChanged(label),
                              selectedColor: primaryColor,
                            ),
                          ))
                      .toList(),
                ),
              ),
              if (isLoadingFilters)
                const Center(child: CircularProgressIndicator())
              else if (filterError != null)
                Center(
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
                        child: Text(
                          'Retry'.tr,
                          style: const TextStyle(
                              color: btntxtColors, fontSize: 16),
                        ),
                      ),
                    ],
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
              Expanded(
                child: _filteredPromotions.isEmpty
                    ? const Center(
                        child: Text(
                          'No promotions found.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
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
                            statusLabel = 'Consumed';
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
              ),
            ],
          );
        },
      ),
    );
  }
}
