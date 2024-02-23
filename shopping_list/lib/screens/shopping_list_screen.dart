import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list/provider/shopping_list_provider.dart';
import 'package:shopping_list/screens/new_item_screen.dart';
import 'package:shopping_list/widgets/shopping_list_widget.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  void _openAddItem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewItemScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shoppingList = ref.watch(shoppingListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: () => _openAddItem(context),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: shoppingList.isEmpty
          ? const Center(
              child: Text('No Data'),
            )
          : ListView.builder(
              itemCount: shoppingList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(shoppingList[index]),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    ref
                        .read(shoppingListProvider.notifier)
                        .removeItem(shoppingList[index]);
                  },
                  child: ShoppingListWidget(
                    groceryItem: shoppingList[index],
                  ),
                );
              },
            ),
    );
  }
}
