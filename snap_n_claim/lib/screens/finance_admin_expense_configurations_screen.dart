import 'package:flutter/material.dart';

class FinanceAdminExpenseConfigurationsScreen extends StatefulWidget {
  const FinanceAdminExpenseConfigurationsScreen(this._width, this._height,
      {super.key});

  final double _width;
  final double _height;

  @override
  State<FinanceAdminExpenseConfigurationsScreen> createState() =>
      _FinanceAdminExpenseConfigurationsScreenState();
}

class _FinanceAdminExpenseConfigurationsScreenState
    extends State<FinanceAdminExpenseConfigurationsScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget._width);
    print(widget._height);
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Configurations"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(
                  width: widget._width / 3.2,
                  child: Center(
                      child: Text(
                    "GL Code",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ))),
              SizedBox(
                  width: widget._width / 3.2,
                  child: Center(
                      child: Text(
                    "Transaction Limit (Rs.)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ))),
              SizedBox(
                  width: widget._width / 3.2,
                  child: Center(
                      child: Text(
                    "Monthly Limit (Rs.)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ))),
            ],
          ),
        ],
      ),
    );
  }
}
