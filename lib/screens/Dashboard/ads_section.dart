// import 'package:flutter/material.dart';
// import 'package:total_energies/core/constant/colors.dart';

// class AdsSection extends StatelessWidget {
//   final double adsHeight;

//   const AdsSection({
//     super.key,
//     this.adsHeight = 180,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final List<String> ads = [
//       'assets/images/logo.png',
//       'assets/images/logo.png',
//       'assets/images/logo.png',
//       'assets/images/logo.png',
//     ];

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: SizedBox(
//         height: adsHeight,
//         child: ListView.separated(
//           scrollDirection: Axis.horizontal,
//           itemCount: ads.length,
//           separatorBuilder: (context, index) => const SizedBox(width: 12),
//           itemBuilder: (context, index) {
//             // double screenWidth = MediaQuery.of(context).size.width;
//             // double itemWidth = screenWidth - 45; // 16 padding on each side
//             double itemWidth = MediaQuery.of(context).size.width *
//                 0.8; // 16 padding on each side
//             return ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Container(
//                 width: itemWidth, // full width inside the padding
//                 decoration: BoxDecoration(
//                   border: Border.all(color: primaryColor, width: 1.0),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Image.asset(
//                   ads[index],
//                   width: itemWidth,
//                   height: adsHeight,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/ads_model.dart';
import 'package:total_energies/services/ads_service.dart';

class AdsSection extends StatefulWidget {
  final double adsHeight;

  const AdsSection({
    super.key,
    this.adsHeight = 180,
  });

  @override
  State<AdsSection> createState() => _AdsSectionState();
}

class _AdsSectionState extends State<AdsSection> {
  late Future<List<AdvertisementModel>> _adsFuture;

  @override
  void initState() {
    super.initState();
    _adsFuture = AdvertisementService().fetchAdvertisements();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AdvertisementModel>>(
      future: _adsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Failed to load ads"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No advertisements available"));
        }

        final ads = snapshot.data!;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: widget.adsHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: ads.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                double itemWidth = MediaQuery.of(context).size.width * 0.8;

                // Build full URL from API photoPath
                final String imageUrl =
                    "https://www.besttopsystems.net:4336${ads[index].photoPath}";

                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: itemWidth,
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor, width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(
                      imageUrl,
                      width: itemWidth,
                      height: widget.adsHeight,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/logo.png", // fallback image
                          width: itemWidth,
                          height: widget.adsHeight,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
