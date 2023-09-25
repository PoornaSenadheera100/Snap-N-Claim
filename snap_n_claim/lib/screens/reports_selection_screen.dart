import 'package:flutter/material.dart';

import 'finance_admin_menu_drawer.dart';

class ReportsSelectionScreen extends StatelessWidget {
   ReportsSelectionScreen(this._width, this._height, {super.key});

  double _width;
  double _height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports"),
      ),
      drawer: FinanceAdminMenuDrawer(_width, _height, "Reports"),
    );
  }
}
