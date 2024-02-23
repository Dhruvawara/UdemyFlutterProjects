import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/enums/filter.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screen/categories_screen.dart';
import 'package:meals_app/screen/filter_screen.dart';
import 'package:meals_app/screen/meals_screen.dart';
import 'package:meals_app/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegetarian: false,
};

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int selectedPageIndex = 0;

  final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> _selectedFilter = kInitialFilters;

  void setScreen(String identifier) async {
    // close drawer
    Navigator.pop(context);
    if (identifier == 'filters') {
      // Navigator.of(context).pushReplacement(
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (context) => FilterScreen(currentFilters: _selectedFilter),
        ),
      );
      setState(() {
        _selectedFilter = result ?? kInitialFilters;
      });
    }
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);
    setState(() {
      if (isExisting) {
        _favoriteMeals.remove(meal);
        _showInfoMessage("Removed From Favorites");
      } else {
        _favoriteMeals.add(meal);
        _showInfoMessage("Added To Favorites");
      }
    });
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _selectPage(int index) => setState(() {
        selectedPageIndex = index;
      });

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((element) {
      if (_selectedFilter[Filter.glutenFree]! && !element.isGlutenFree) {
        return false;
      }
      if (_selectedFilter[Filter.lactoseFree]! && !element.isLactoseFree) {
        return false;
      }
      if (_selectedFilter[Filter.vegan]! && !element.isVegan) {
        return false;
      }
      if (_selectedFilter[Filter.vegetarian]! && !element.isVegetarian) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );
    String activePageTitle = 'Categories';

    if (selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(onSelectScreen: setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Favorites",
          ),
        ],
      ),
    );
  }
}
