import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final dateFormatter = DateFormat.yMd();

enum Category {
  food,
  travel,
  leisure,
  work,
}

const Map<Category, IconData> categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return dateFormatter.format(date);
  }
}

class ExpenseBucket {
  final Category category;
  final List<Expense> expenseList;

  ExpenseBucket({required this.category, required this.expenseList});

  ExpenseBucket.forCategory(List<Expense> allExpense, this.category)
      : expenseList = allExpense
            .where((element) => category == element.category)
            .toList();

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenseList) {
      sum += expense.amount;
    }
    return sum;
  }
}
