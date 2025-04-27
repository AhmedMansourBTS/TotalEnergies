import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';

class DashboardPage extends StatelessWidget {
  final double adsHeight;
  final double newsHeight;

  const DashboardPage({
    super.key,
    this.adsHeight = 150,
    this.newsHeight = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            LogoRow(),
            Spacer(),
            Icon(
              Icons.notifications,
              size: 28,
              color: primaryColor,
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Part 1 - Ads
            _buildAdsSection(),

            const SizedBox(height: 20),

            // Part 2 - News
            _buildNewsSection(),

            const SizedBox(height: 20),

            // Part 3 - Available Services
            _buildAvailableServices(),

            // Part 4 - Latest Promotions
            _buildLatestPromos(),
          ],
        ),
      ),
    );
  }

  // PART 1: Ads Section
  Widget _buildAdsSection() {
    final List<String> ads = [
      'assets/images/logo.png',
      'assets/images/logo.png',
      'assets/images/logo.png',
      'assets/images/logo.png',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: adsHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: ads.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: primaryColor, // Change to your desired border color
                    width: 1.0, // Change to your desired border width
                  ),
                  borderRadius: BorderRadius.circular(
                      10), // Match the ClipRRect border radius
                ),
                child: Image.asset(
                  ads[index],
                  width: 250,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // PART 2: News Section
  Widget _buildNewsSection() {
    final List<String> newsList = [
      'Breaking News 1',
      'Event Announcement 2',
      'Important Update 3',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Latest News',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: newsHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: newsList.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return Container(
                  width: 250,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      newsList[index],
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // PART 3: Available Services
  Widget _buildAvailableServices() {
    final List<Map<String, dynamic>> services = [
      {'icon': Icons.local_gas_station, 'title': 'Fuel'},
      {'icon': Icons.local_car_wash, 'title': 'Car Wash'},
      {'icon': Icons.store, 'title': 'Mini Market'},
      {'icon': Icons.build, 'title': 'Maintenance'},
      {'icon': Icons.ev_station, 'title': 'EV Charge'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Services',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: services.length,
              separatorBuilder: (context, index) => const SizedBox(width: 20),
              itemBuilder: (context, index) {
                final service = services[index];
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: primaryColor,
                      child: Icon(
                        service['icon'],
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service['title'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // PART 4: Latest Promotions
  Widget _buildLatestPromos() {
    final List<String> promos = [
      'Promo 1: 20% off fuel',
      'Promo 2: Free coffee with car wash',
      'Promo 3: Loyalty rewards',
      'Promo 4: 20% off fuel',
      'Promo 5: Free coffee with car wash',
      'Promo 6: Loyalty rewards',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Latest Promotions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: promos.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.lightBlue,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.local_offer,
                    color: Colors.white,
                  ),
                  title: Text(
                    promos[index],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
