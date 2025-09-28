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

class AllPromoPage extends StatefulWidget {
  const AllPromoPage({super.key});

  @override
  State<AllPromoPage> createState() => _AllPromoPageState();
}

class _AllPromoPageState extends State<AllPromoPage> {
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
        case 'Used':
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
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Scaffold(
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
                // Filters or Loader/Error
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
                                  List<GovernorateModel> filteredGovernorates =
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
                                                prefixIcon: Icon(Icons.search),
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
                                              child: filteredGovernorates.isEmpty
                                                  ? Center(
                                                      child:
                                                          Text("No results".tr))
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
                        const SizedBox(width: 10),
                        // Not a drop down this displays pop up menu in the middle of the page
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              CityModel? selected = await showDialog<CityModel>(
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
                                                prefixIcon: Icon(Icons.search),
                                                hintText: "Search city...".tr,
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
                                                      child:
                                                          Text("No results".tr))
                                                  : ListView.builder(
                                                      itemCount:
                                                          filteredCities.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final city =
                                                            filteredCities[index];
                                                        return ListTile(
                                                          title: Text(
                                                              city.cityLatName),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context, city);
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
                                _selectedCity?.cityLatName ?? "Select area".tr,
                                style: TextStyle(
                                  color: _selectedCity == null
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
      
                // ✅ Add RefreshIndicator here
                Expanded(
                  child: RefreshIndicator(
                    color: primaryColor,
                    onRefresh: () async {
                      setState(() {
                        _loadDataFuture = _loadData();
                      });
                      await _loadDataFuture;
                    },
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
                              final isExp =
                                  _expPromoSerials.contains(promo.serial);
                              final isBlocked = isCurr || isExp;
      
                              String statusLabel = 'Available';
                              Color statusColor = Colors.green;
                              if (isCurr) {
                                statusLabel = 'Ongoing';
                                statusColor = Colors.orange;
                              } else if (isExp) {
                                statusLabel = 'Used';
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
                                      Get.to(() =>
                                          ApplyToPromoDet(promotion: promo));
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}