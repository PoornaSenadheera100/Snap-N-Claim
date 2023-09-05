import 'package:flutter/material.dart';

class FinanceAdminExpenseMappingSelectionScreen extends StatefulWidget {
  const FinanceAdminExpenseMappingSelectionScreen({super.key});

  @override
  State<FinanceAdminExpenseMappingSelectionScreen> createState() => _FinanceAdminExpenseMappingSelectionScreenState();
}

class _FinanceAdminExpenseMappingSelectionScreenState extends State<FinanceAdminExpenseMappingSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Mapping"),
      ),
    );
  }
}
