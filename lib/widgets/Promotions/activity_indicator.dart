// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:total_energies/core/constant/colors.dart';

// class ActivityIndicator extends StatelessWidget {
//   final int left;
//   final int total;

//   const ActivityIndicator({
//     super.key,
//     required this.left,
//     required this.total,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // margin: EdgeInsets.symmetric(horizontal: 100),
//       padding: EdgeInsets.symmetric(vertical: 20),
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(12),
//         // boxShadow: [
//         //   BoxShadow(
//         //     color: Colors.black26,
//         //     blurRadius: 6,
//         //     offset: Offset(0, 3),
//         //   ),
//         // ],
//       ),
//       child: Center(
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'promotion_det_page.activity'.tr,
//               style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black),
//             ),
//             Text(
//               '$left / $total',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: primaryColor,
//               ),
//             ),
//             // SizedBox(width: 8),
//             // Icon(
//             //   left == total ? Icons.check_circle : Icons.timelapse,
//             //   color: left == total ? Colors.green : Colors.orange,
//             //   size: 20,
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:total_energies/core/constant/colors.dart';

class ActivityIndicator extends StatelessWidget {
  final int left;
  final int total;
  final String title; // ⬅️ New title variable

  const ActivityIndicator({
    super.key,
    required this.left,
    required this.total,
    required this.title, // ⬅️ Default value
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title.tr, // ⬅️ Use variable instead of hardcoded text
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$left / $total',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
