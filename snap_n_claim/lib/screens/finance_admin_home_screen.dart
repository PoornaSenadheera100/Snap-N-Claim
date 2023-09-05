import 'package:flutter/material.dart';
import 'package:snap_n_claim/screens/finance_admin_budget_allocation_selection_screen.dart';
import 'package:snap_n_claim/screens/finance_admin_reporting_screen.dart';

class FinanceAdminHomeScreen extends StatelessWidget {
  FinanceAdminHomeScreen(this._width, this._height, {super.key});

  double _width;
  double _height;

  void _onTapReportingAndAnalyticsBtn(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => FinanceAdminReportingScreen(_width, _height)));
  }

  void _onTapBudgetAllocationBtn(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            FinanceAdminBudgetAllocationSelectionScreen(_width, _height)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome !"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  _onTapReportingAndAnalyticsBtn(context);
                },
                child: Text("Reporting and Analytics")),
            ElevatedButton(
                onPressed: () {
                  _onTapBudgetAllocationBtn(context);
                },
                child: Text("Budget Allocation")),
            ElevatedButton(
                onPressed: () {}, child: Text("Account Creation & Management")),
          ],
        ),
      ),
    );
  }
}
