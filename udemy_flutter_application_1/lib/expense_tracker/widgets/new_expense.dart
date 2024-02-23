import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:udemy_flutter_application_1/expense_tracker/models/expense.dart'
    as expenseModel;

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(expenseModel.Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _amountTextController = TextEditingController();
  DateTime? _selectedDate;
  expenseModel.Category? _selectedCategory;

  void _openDatePicker() async {
    final DateTime now = DateTime.now();
    final DateTime firstDate =
        DateTime(now.year - 1, now.month - 1, now.day - 1);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountTextController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleTextController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null ||
        _selectedCategory == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Enter all detials"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Okay"),
            )
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(expenseModel.Expense(
      title: _titleTextController.text.trim(),
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory!,
    ));
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _amountTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            16, MediaQuery.of(context).padding.top + 36, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleTextController,
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Title:'),
                counterText: "",
              ),
            ),
            const Gap(20),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _amountTextController,
                    decoration: const InputDecoration(
                        label: Text('Amount:'),
                        counterText: "",
                        prefixText: "\$"),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const Gap(20),
                Flexible(
                  flex: 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                          child: Text(_selectedDate == null
                              ? "No Date Selected"
                              : "Selected Date: ${formatter.format(_selectedDate!)}")),
                      IconButton(
                          onPressed: _openDatePicker,
                          icon: const Icon(Icons.calendar_month))
                    ],
                  ),
                )
              ],
            ),
            const Gap(20),
            Row(
              children: [
                DropdownButton(
                  value: _selectedCategory,
                  items: expenseModel.Category.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            category.name.toUpperCase(),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (kDebugMode) {
                      print(_titleTextController.text);
                      print(_amountTextController.text);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                const Gap(20),
                ElevatedButton(
                  onPressed: _submitExpenseData,
                  child: const Text("Save"),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
