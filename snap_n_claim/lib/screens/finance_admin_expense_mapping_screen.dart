import 'package:flutter/material.dart';

class FinanceAdminExpenseMappingScreen extends StatefulWidget {
  FinanceAdminExpenseMappingScreen(
      this._width, this._height, this._glCode,
      {super.key});

  double _width;
  double _height;
  String _glCode;

  @override
  State<FinanceAdminExpenseMappingScreen> createState() =>
      _FinanceAdminExpenseMappingSelectionScreenState();
}

class _FinanceAdminExpenseMappingSelectionScreenState
    extends State<FinanceAdminExpenseMappingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Mapping"),
      ),
      body: Column(
        children: [
          Text("Expense Info"),
          Row(
            children: [
              Text("GL Code"),
              Text("GL Name"),
              Text("Transaction Limit"),
              Text("Monthly Limit"),
            ],
          ),
          Row(
            children: [

            ],
          ),
          Text("Eligible Employees"),
        ],
      ),
    );
  }
}
