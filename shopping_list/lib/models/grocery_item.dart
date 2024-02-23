import 'package:shopping_list/models/category.dart';

class GroceryItem {
  GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });

  final Category category;
  final String id;
  final String name;
  final int quantity;

  @override
  bool operator ==(covariant GroceryItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.quantity == quantity &&
        other.category == category;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ quantity.hashCode ^ category.hashCode;
  }

  @override
  String toString() {
    return 'GroceryItem(id: $id, name: $name, quantity: $quantity, category: $category)';
  }

  GroceryItem copyWith({
    String? id,
    String? name,
    int? quantity,
    Category? category,
  }) {
    return GroceryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
    );
  }
}
