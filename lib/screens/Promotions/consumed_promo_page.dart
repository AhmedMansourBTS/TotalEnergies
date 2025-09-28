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

class ConsumedPromotionsPage extends StatefulWidget {
  const ConsumedPromotionsPage({super.key});

  @override
  State<ConsumedPromotionsPage> createState() => _ConsumedPromotionsPageState();
}

class _ConsumedPromotionsPageState extends State<ConsumedPromotionsPage> {
  final PromotionsService _promotionsService = PromotionsService();
  final GovernorateService _governorateService = GovernorateService();
  final CityService _cityService = CityService();
  final StationService _stationService = StationService();

  late Future<void> _loadDataFuture;
  List<PromotionsModel> _promotions = [];
  List<PromotionsModel> _filteredPromotions = [];
  Set<int> _currPromoSerials = {};
  Set<int> _expPromoSerials = {};
  String _filter = 'Used';
  List<GovernorateModel> _governorates = [];
  List<CityModel> _cities = [];
  List<CityModel> _filteredCities = [];
  List<StationModel> _stations = [];
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

      return passesStatusFilter;
    }).toList();

    setState(() {});
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
    );
  }
}