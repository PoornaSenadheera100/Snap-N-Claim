import 'package:flutter/material.dart';

class FinanceAdminExpenseConfigurationsScreen extends StatefulWidget {
  const FinanceAdminExpenseConfigurationsScreen(this._width, this._height, {super.key});

  final double _width;
  final double _height;

  @override
  State<FinanceAdminExpenseConfigurationsScreen> createState() => _FinanceAdminExpenseConfigurationsScreenState();
}

class _FinanceAdminExpenseConfigurationsScreenState extends State<FinanceAdminExpenseConfigurationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Expense Configurations"),),
    );
  }
}
