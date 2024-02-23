import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list_firebase/data/categories.dart';
import 'package:shopping_list_firebase/models/grocery_item.dart';
import 'package:http/http.dart' as http;

class ShoppingListProvider extends StateNotifier<List<GroceryItem>> {
  ShoppingListProvider() : super([]);

  Future<bool> addItem(GroceryItem groceryItem) async {
    state = [...state, groceryItem];

    final url = Uri.https(
      'udemy-shopping-list-d64b6-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );

    var httpResponse = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          'name': groceryItem.name,
          'quantity': groceryItem.quantity,
          'category': groceryItem.category.name.toString(),
        },
      ),
    );

    if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
      return await getDataFromFireBase();
    } else {
      return false;
    }
  }

  Future<bool> getDataFromFireBase() async {
    final url = Uri.https(
      'udemy-shopping-list-d64b6-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );

    var httpResponse = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
      if (httpResponse.body == 'null') {
        return false;
      }
      final Map<String, dynamic> tempResponseListData =
          jsonDecode(httpResponse.body);
      final List<GroceryItem> tempListData = [];
      for (var element in tempResponseListData.entries) {
        tempListData.add(
          GroceryItem(
            id: element.key,
            name: element.value['name'],
            quantity: element.value['quantity'],
            category: getCategory(element.value['category']),
          ),
        );
      }
      state = tempListData;
      return true;
    } else {
      return false;
    }
  }

  void removeItem(GroceryItem groceryItem) {
    bool isItemPresent = state.contains(groceryItem);
    if (isItemPresent) {
      deleteDataFromFireBase(groceryItem.id);
      var tempState = state;
      tempState.remove(groceryItem);
      state = tempState;
    }
  }

  Future<bool> deleteDataFromFireBase(String id) async {
    final url = Uri.https(
      'udemy-shopping-list-d64b6-default-rtdb.firebaseio.com',
      'shopping-list/$id.json',
    );

    var httpResponse = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
      return await getDataFromFireBase();
    } else {
      return false;
    }
  }
}

final shoppingListProvider =
    StateNotifierProvider<ShoppingListProvider, List<GroceryItem>>(
        (ref) => ShoppingListProvider());
