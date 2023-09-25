import 'package:flutter/material.dart';
import 'package:snap_n_claim/screens/finance_admin_expense_mapping_selection_screen.dart';
import 'package:snap_n_claim/screens/finance_admin_menu_drawer.dart';

class FinanceAdminBudgetAllocationSelectionScreen extends StatelessWidget {
  FinanceAdminBudgetAllocationSelectionScreen(this._width, this._height, {super.key});

  double _width;
  double _height;

  void _onTapExpenseMappingBtn(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            FinanceAdminExpenseMappingSelectionScreen(_width, _height)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Budget Allocation Menu"),
      ),
      drawer: FinanceAdminMenuDrawer(_width, _height, "Budget Allocation Menu"),
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
