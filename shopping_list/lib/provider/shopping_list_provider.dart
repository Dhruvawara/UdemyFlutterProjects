import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/data/dummy_items.dart';

class ShoppingListProvider extends StateNotifier<List<GroceryItem>> {
  ShoppingListProvider() : super(groceryItems);

  void addItem(GroceryItem groceryItem) {
    state = [...state, groceryItem];
  }

  void removeItem(GroceryItem groceryItem) {
    bool isItemPresent = state.contains(groceryItem);
    if (isItemPresent) {
      var tempState = state;
      tempState.remove(groceryItem);
      state = tempState;
    }
  }
}

final shoppingListProvider =
    StateNotifierProvider<ShoppingListProvider, List<GroceryItem>>(
        (ref) => ShoppingListProvider());
