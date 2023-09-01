import 'package:flutter/material.dart';

class FinanceAdminBudgetAllocationSelectionScreen extends StatelessWidget {
  const FinanceAdminBudgetAllocationSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Budget Allocation Menu"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text("Expense Mapping"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Expense Configurations"),
            ),
          ],
        ),
      ),
    );
  }
}
