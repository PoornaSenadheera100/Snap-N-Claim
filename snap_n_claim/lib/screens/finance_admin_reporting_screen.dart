import 'package:flutter/material.dart';

class FinanceAdminReportingScreen extends StatefulWidget {
  const FinanceAdminReportingScreen({super.key});

  @override
  State<FinanceAdminReportingScreen> createState() =>
      _FinanceAdminReportingScreenState();
}

class _FinanceAdminReportingScreenState
    extends State<FinanceAdminReportingScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Reporting and Analytics"),
          bottom: TabBar(tabs: [
            Text(
              "Employee\nReport",
              textAlign: TextAlign.center,
            ),
            Text("Departments\nReport", textAlign: TextAlign.center,),
            Text("Expense Report", textAlign: TextAlign.center,),
          ]),
        ),
        body: TabBarView(children: [
          Container(),
          Container(),
          Container(),
        ]),
      ),
    );
  }
}
