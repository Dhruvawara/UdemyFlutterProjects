import 'package:udemy_flutter_application_1/expense_tracker/widgets/expense_list/expense_item.dart';
import 'package:flutter/material.dart';

import 'package:udemy_flutter_application_1/expense_tracker/models/expense.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({super.key, required this.listOfExpenses, required this.removeExpense});
  final List<Expense> listOfExpenses;
  final Function(Expense expense) removeExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listOfExpenses.length,
      itemBuilder: (context, index) {
        return Dismissible(
          onDismissed: (direction) => removeExpense(listOfExpenses[index]),
          key: UniqueKey(),
          child: ExpenseItem(
            expense: listOfExpenses[index],
          ),
        );
      },
    );
  }
}
