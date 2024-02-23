import 'package:flutter/material.dart';
import 'package:meals_app_riverpod/data/dummy_data.dart';
import 'package:meals_app_riverpod/models/category.dart';
import 'package:meals_app_riverpod/models/meal.dart';
import 'package:meals_app_riverpod/screen/meals_screen.dart';
import 'package:meals_app_riverpod/widgets/category_grid_items.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
    required this.availableMeals,
  });

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final List<Meal> filteredMeals = widget.availableMeals
        .where((element) => element.categories.contains(category.id))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        children: [
          for (final element in availableCategories)
            CategoryGridItems(
              category: element,
              onSelectCategory: _selectCategory,
            )
        ],
      ),
      builder: (context, child) {
        return Padding(
          padding:
              EdgeInsets.only(top: 1000 - _animationController.value * 1000),
          child: child,
        );
      },
    );
  }
}
