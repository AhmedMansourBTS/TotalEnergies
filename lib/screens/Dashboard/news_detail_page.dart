// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/news_model.dart';
// import 'package:total_energies/widgets/global/app_bar_logos.dart';

// class NewsDetailPage extends StatelessWidget {
//   final NewsModel news;

//   const NewsDetailPage({super.key, required this.news});

//   @override
//   Widget build(BuildContext context) {
//     final formattedDate =
//         DateFormat('yyyy-MM-dd – kk:mm').format(news.newsDate);

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         title: Row(
//           children: [
//             LogoRow(),
//             Spacer(),
//             Expanded(
//                 child: Text(news.newsTitle, overflow: TextOverflow.ellipsis))
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Description",
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     // color: const Color.fromARGB(255, 158, 158, 158),
//                     color: Colors.transparent,
//                     border: Border.all(color: Colors.black, width: 1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Text(
//                     news.newsDescription,
//                     style: const TextStyle(
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Container(
//               padding: EdgeInsets.all(12),
//               child: Text(
//                 'Date: $formattedDate',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             if (!news.isActive)
//               Center(
//                 child: const Padding(
//                   padding: EdgeInsets.only(top: 10),
//                   child: Text(
//                     'This news is not active.',
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/news_model.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsModel news;

  const NewsDetailPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('MMMM d, yyyy • hh:mm a').format(news.newsDate);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Row(
          children: [
            LogoRow(),
            const Spacer(),
            Expanded(
              child: Text(
                "News Detail",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              news.newsTitle,
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                  color: primaryColor),
            ),

            const SizedBox(height: 10),

            // Date
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Image from assets
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/images/logo.png", // your asset path
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width *
                      0.8, // 16 padding on each side,
                  // height: 100,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  )),
              child: Text(
                news.newsDescription,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Inactive status
            if (!news.isActive)
              Center(
                child: Text(
                  'This news is not active.',
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
