import 'package:udemy_flutter_application_1/expense_tracker/widgets/chart/chart.dart';
import 'package:udemy_flutter_application_1/expense_tracker/widgets/expense_list/expenses_list.dart';
import 'package:udemy_flutter_application_1/expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:udemy_flutter_application_1/expense_tracker/models/expense.dart';

class Expenses extends StatefulWidget {
  static const String routeName = '/Expenses';

  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpense = [
    Expense(
      title: 'Flutter Curse',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Movie',
      amount: 10.99,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return NewExpense(
          onAddExpense: _addExpense,
        );
      },
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpense.add(expense);
    });
    Navigator.pop(context);
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpense.indexOf(expense);
    setState(() {
      _registeredExpense.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _registeredExpense.insert(expenseIndex, expense);
            });
          },
        ),
        content: const Text("Removed Element"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        Chart(expenses: _registeredExpense),
        Expanded(
          child: ExpensesList(
              listOfExpenses: _registeredExpense,
              removeExpense: _removeExpense),
        ),
      ],
    );
    if (_registeredExpense.isEmpty) {
      content = const Center(
        child: Text("Empty"),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
