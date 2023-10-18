import 'package:flutter/material.dart';
import 'package:snap_n_claim/models/employee.dart';
import 'package:snap_n_claim/screens/finance_admin/finance_admin_expense_configurations_screen.dart';
import 'package:snap_n_claim/screens/finance_admin/finance_admin_expense_mapping_selection_screen.dart';
import 'package:snap_n_claim/screens/finance_admin/finance_admin_menu_drawer.dart';

class FinanceAdminBudgetAllocationSelectionScreen extends StatelessWidget {
  const FinanceAdminBudgetAllocationSelectionScreen(
      this._width, this._height, this._user,
      {super.key});

  final double _width;
  final double _height;
  final Employee _user;

  void _onTapExpenseMappingBtn(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            FinanceAdminExpenseMappingSelectionScreen(_width, _height, _user)));
  }

  void _onTapExpenseConfigurationsBtn(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            FinanceAdminExpenseConfigurationsScreen(_width, _height, _user)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget Allocation Menu"),
      ),
      drawer: FinanceAdminMenuDrawer(
          _width, _height, "Budget Allocation Menu", _user),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: _width / 1.309090909090909,
              height: _height / 5.352727272727273,
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: Ink.image(
                  image: const AssetImage('assets/expense_mapping_btn.png'),
                  fit: BoxFit.fill,
                  child: InkWell(
                    onTap: () {
                      _onTapExpenseMappingBtn(context);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              width: _width / 1.309090909090909,
              height: _height / 5.352727272727273,
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: Ink.image(
                  image: const AssetImage('assets/expense_config_btn.png'),
                  fit: BoxFit.fill,
                  child: InkWell(
                    onTap: () {
                      _onTapExpenseConfigurationsBtn(context);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
