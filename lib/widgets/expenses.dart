import 'package:expense_tracker/widgets/chart/charts.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registerExpenses = [
    Expense(
        title: 'Flutter Course',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Game',
        amount: 22.11,
        date: DateTime.now(),
        category: Category.leisure),
    Expense(
        title: 'Art Museum',
        amount: 100.99,
        date: DateTime.now(),
        category: Category.travel),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(onAddExpense: _addExpense));
  }

  void _addExpense(Expense exp) {
    setState(() {
      _registerExpenses.add(exp);
    });
  }

  void _removeExpense(Expense exp) {
    final currentItemIndex = _registerExpenses.indexOf(exp);
    setState(() {
      _registerExpenses.remove(exp);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Expense Deleted'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'undo',
        onPressed: () {
          setState(() {
            _registerExpenses.insert(currentItemIndex, exp);
          });
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget displayWig = const Text('No Expenses Found create One ');

    if (_registerExpenses.isNotEmpty) {
      displayWig = Expanded(
          child: ExpensesList(
        expenses: _registerExpenses,
        onRemoveExpense: _removeExpense,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expenses Tracker'),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [Chart(expenses: _registerExpenses), displayWig],
      ),
    );
  }
}
