import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:shopping_list_firebase/data/categories.dart';
import 'package:shopping_list_firebase/models/category.dart';
import 'package:shopping_list_firebase/models/grocery_item.dart';
import 'package:shopping_list_firebase/provider/shopping_list_provider.dart';

class NewItemScreen extends ConsumerStatefulWidget {
  const NewItemScreen({super.key});

  @override
  ConsumerState<NewItemScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends ConsumerState<NewItemScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  int quantity = 1;
  Category category = categories.entries.first.value;

  void _resetItem() {
    _formKey.currentState!.reset();
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool isSuccess =
          await ref.read(shoppingListProvider.notifier).addItem(GroceryItem(
                id: const Uuid().v4(),
                name: name,
                quantity: quantity,
                category: category,
              ));
              
      if (!context.mounted) return;

      if (isSuccess) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Success')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Name"),
                  counterText: "",
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Error Boi';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  name = newValue!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text("Quantity"),
                      ),
                      initialValue: '$quantity',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Error Boi';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        quantity = int.tryParse(newValue!)!;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      items: [
                        for (final entry in categories.entries)
                          DropdownMenuItem(
                            value: entry.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: entry.value.color,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  entry.value.name,
                                ),
                              ],
                            ),
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          category = value!;
                        });
                      },
                      value: category,
                      validator: (value) {
                        if (value == null) {
                          return "Select Boi";
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _resetItem,
                    child: const Text("Rest"),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text("Add Item"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
