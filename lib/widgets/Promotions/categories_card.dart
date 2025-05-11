// import 'package:flutter/material.dart';

// class CategoryCard extends StatelessWidget {
//   final String imagePath;
//   final String title;

//   const CategoryCard({
//     Key? key,
//     required this.imagePath,
//     required this.title,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.grey,
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Expanded(
//             child: ClipRRect(
//               borderRadius:
//                   const BorderRadius.vertical(top: Radius.circular(12)),
//               child: Image.asset(
//                 imagePath,
//                 fit: BoxFit.contain,
//                 width: double.infinity,
//               ),
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: Colors.grey.shade400, width: 1.5),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             width: double.infinity,
//             padding: const EdgeInsets.all(8.0),
//             child: Center(
//               child: Text(
//                 title,
//                 style:
//                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:total_energies/models/categories_model.dart';
import 'package:total_energies/screens/Promotions/category_promo_page.dart';

class CategoryCard extends StatelessWidget {
  final String imagePath;
  final CategoryModel category;

  const CategoryCard({
    Key? key,
    required this.imagePath,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailsPage(
              categoryId: category.categoryId,
              categoryTitle: category.categoryName,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.grey,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  category.categoryName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
