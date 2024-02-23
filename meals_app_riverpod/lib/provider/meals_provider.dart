import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app_riverpod/data/dummy_data.dart';

final mealsProvider = Provider((ref) {
  return dummyMeals;
});
