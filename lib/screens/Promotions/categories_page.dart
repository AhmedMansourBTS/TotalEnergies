import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/categories_model.dart';
import 'package:total_energies/screens/loading_screen.dart';
import 'package:total_energies/services/get_categ_service.dart';
import 'package:total_energies/widgets/Promotions/categories_card.dart';

class CategoriesPage extends StatefulWidget {
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Future<List<CategoryModel>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureCategories = CategoryService.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<List<CategoryModel>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingScreen());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories found.'));
          }

          final categories = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  imagePath: 'assets/images/logo1.1.png',
                  category: category,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
