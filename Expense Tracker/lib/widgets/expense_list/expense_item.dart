import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({super.key, required this.expense});
  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expense.title),
            const Gap(7),
            Row(
              children: [
                Text("\$${expense.amount}"),
                const Spacer(),
                Row(children: [
                  Icon(categoryIcons[expense.category]),
                  const Gap(8),
                  Text(expense.formattedDate),
                ],),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
