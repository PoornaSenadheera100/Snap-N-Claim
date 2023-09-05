import 'package:flutter/material.dart';
import 'package:snap_n_claim/screens/finance_admin_expense_mapping_selection_screen.dart';

class FinanceAdminBudgetAllocationSelectionScreen extends StatelessWidget {
  const FinanceAdminBudgetAllocationSelectionScreen({super.key});

  void _onTapExpenseMappingBtn(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            FinanceAdminExpenseMappingSelectionScreen()));
  }

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
              onPressed: () {
                _onTapExpenseMappingBtn(context);
              },
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
