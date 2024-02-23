import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app_riverpod/enums/filter.dart';
import 'package:meals_app_riverpod/provider/meals_provider.dart';

class FiltersProvider extends StateNotifier<Map<Filter, bool>> {
  FiltersProvider()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegan: false,
          Filter.vegetarian: false,
        });

  void setFilter(Filter filter, bool value) {
    state = {
      ...state,
      filter: value,
    };
  }

  void setFilters(
    Map<Filter, bool> data,
  ) {
    state = {
      ...data,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersProvider, Map<Filter, bool>>(
        (ref) => FiltersProvider());

final filterMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);
  return meals.where((element) {
    if (activeFilters[Filter.glutenFree]! && !element.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !element.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !element.isVegan) {
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && !element.isVegetarian) {
      return false;
    }
    return true;
  }).toList();
});
