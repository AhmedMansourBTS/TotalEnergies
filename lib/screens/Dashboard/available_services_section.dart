import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/service_model.dart';
import 'package:total_energies/screens/Stations/stations_screen.dart';
import 'package:total_energies/screens/loading_screen.dart';
import 'package:total_energies/services/service_service.dart';

class AvailableServices extends StatelessWidget {
  const AvailableServices({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ServiceModel>>(
      future: GetAllServicesService.fetchAllServices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 160,
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: const LoadingScreen(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Check internet connection',
                  style: TextStyle(color: Colors.redAccent, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Trigger a rebuild to retry fetching services
                    (context as Element).markNeedsBuild();
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

        final services = snapshot.data!.where((s) => s.activeYN).toList();

        if (services.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No active services available.'),
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Services',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: services.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 20),
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StationListScreen(service: service),
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
