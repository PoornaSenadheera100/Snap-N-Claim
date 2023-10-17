import 'package:flutter/material.dart';
import 'package:snap_n_claim/models/employee.dart';
import 'package:snap_n_claim/screens/finance_admin/finance_admin_menu_drawer.dart';

class FinanceAdminHomeScreen extends StatefulWidget {
  const FinanceAdminHomeScreen(this._width, this._height, this.user, {super.key});

  final double _width;
  final double _height;
  final Employee user;

  @override
  State<FinanceAdminHomeScreen> createState() => _FinanceAdminHomeScreenState();
}

class _FinanceAdminHomeScreenState extends State<FinanceAdminHomeScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Finance Pending Claims"),
      ),
      drawer: FinanceAdminMenuDrawer(widget._width, widget._height, "Finance Pending Claims", widget.user),
    );
  }
}
