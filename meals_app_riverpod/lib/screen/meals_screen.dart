import 'package:flutter/material.dart';
import 'package:meals_app_riverpod/models/meal.dart';
import 'package:meals_app_riverpod/screen/meal_detail_screen.dart';
import 'package:meals_app_riverpod/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({
    super.key,
    this.title,
    required this.meals,
  });

  final List<Meal> meals;
  final String? title;

  void onMealItemClick(BuildContext context, Meal meal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MealDetailScreen(meal: meal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("No Data"),
    );

    if (meals.isNotEmpty) {
      content = ListView.builder(
        itemCount: meals.length,
        itemBuilder: (context, index) =>
            MealItem(meal: meals[index], onMealItemClick: onMealItemClick),
      );
    }

    if (title == null) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: content,
    );
  }
}
