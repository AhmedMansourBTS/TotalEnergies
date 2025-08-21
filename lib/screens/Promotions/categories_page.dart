// import 'package:flutter/material.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/categories_model.dart';
// import 'package:total_energies/screens/Promotions/category_promo_page.dart';
// import 'package:total_energies/screens/loading_screen.dart';
// import 'package:total_energies/services/get_categ_service.dart';
// import 'package:total_energies/widgets/Promotions/categories_card.dart';

// class CategoriesPage extends StatefulWidget {
//   const CategoriesPage({super.key});

//   @override
//   State<CategoriesPage> createState() => _CategoriesPageState();
// }

// class _CategoriesPageState extends State<CategoriesPage> {
//   late Future<List<CategoryModel>> _futureCategories;

//   @override
//   void initState() {
//     super.initState();
//     _futureCategories = CategoryService.fetchCategories(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: FutureBuilder<List<CategoryModel>>(
//         future: _futureCategories,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: LoadingScreen());
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Check internet connection',
//                     style:
//                         const TextStyle(color: Colors.redAccent, fontSize: 16),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _futureCategories =
//                             CategoryService.fetchCategories(context);
//                       });
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: primaryColor,
//                     ),
//                     child: const Text(
//                       "Retry",
//                       style: TextStyle(color: btntxtColors, fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(
//               child: Text(
//                 'No categories found.',
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             );
//           }

//           final categories = snapshot.data!;
//           return Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: GridView.builder(
//               itemCount: categories.length,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 1, // one per row
//                 mainAxisExtent: MediaQuery.of(context).size.height * 0.4,
//                 // 👆 each card takes half screen height
//               ),
//               itemBuilder: (context, index) {
//                 final category = categories[index];
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => CategoryDetailsPage(
//                           categoryId: category.categoryId,
//                           categoryTitle: category.categoryLatName,
//                         ),
//                       ),
//                     );
//                   },
//                   child: CategoryCard(
//                     imagePath: 'assets/images/logo1.1.png',
//                     category: category,
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/categories_model.dart';
import 'package:total_energies/screens/Promotions/category_promo_page.dart';
import 'package:total_energies/screens/loading_screen.dart';
import 'package:total_energies/services/get_categ_service.dart';
import 'package:total_energies/widgets/Promotions/categories_card.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Future<List<CategoryModel>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureCategories = CategoryService.fetchCategories(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: RefreshIndicator(
        color: primaryColor, // Refresh progress indicator color
        onRefresh: () async {
          setState(() {
            _futureCategories = CategoryService.fetchCategories(context);
          });
          await _futureCategories; // Wait until refresh is done
        },
        child: FutureBuilder<List<CategoryModel>>(
          future: _futureCategories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingScreen());
            } else if (snapshot.hasError) {
              return ListView(
                // Wrap Column in ListView to allow pull gesture
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                  Column(
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
                          setState(() {
                            _futureCategories =
                                CategoryService.fetchCategories(context);
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
                ],
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return ListView(
                // Also wrap in ListView for RefreshIndicator
                children: const [
                  SizedBox(height: 300),
                  Center(
                    child: Text(
                      'No categories found.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              );
            }

            final categories = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisExtent: MediaQuery.of(context).size.height * 0.4,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryDetailsPage(
                            categoryId: category.categoryId,
                            categoryTitle: category.categoryLatName,
                          ),
                        ),
                      );
                    },
                    child: CategoryCard(
                      imagePath: 'assets/images/logo1.1.png',
                      category: category,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
