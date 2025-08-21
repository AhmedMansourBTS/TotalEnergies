// import 'package:flutter/material.dart';

// class ProfileInfoTile extends StatelessWidget {
//   final String labelText;
//   final String valueText;
//   final IconData icon;

//   const ProfileInfoTile({
//     super.key,
//     required this.labelText,
//     required this.valueText,
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(labelText, style: TextStyle(fontSize: 18)),
//         SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(valueText, style: TextStyle(fontSize: 18)),
//             Icon(icon),
//           ],
//         ),
//         Divider(color: Colors.grey.shade300, thickness: 3, height: 3),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class ProfileInfoTile extends StatelessWidget {
  final String labelText;
  final String valueText;
  final IconData icon;

  const ProfileInfoTile({
    super.key,
    required this.labelText,
    required this.valueText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0), // space after widget
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            labelText,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),

          // Value + Icon Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.transparent, // subtle background
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    valueText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(icon, color: Colors.grey.shade700),
              ],
            ),
          ),
          Divider(color: Colors.grey.shade300, thickness: 1, height: 1),
        ],
      ),
    );
  }
}
