import 'package:flutter/material.dart';

class Category {
  final String name;
  final Color color;
  Category(
    this.name,
    this.color,
  );

  @override
  String toString() => 'Category(name: $name, color: $color)';

  @override
  bool operator ==(covariant Category other) {
    if (identical(this, other)) return true;

    return other.name == name && other.color == color;
  }

  @override
  int get hashCode => name.hashCode ^ color.hashCode;
}
