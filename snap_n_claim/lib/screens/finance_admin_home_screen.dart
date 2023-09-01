import 'package:flutter/material.dart';

class FinanceAdminHomeScreen extends StatelessWidget {
  FinanceAdminHomeScreen(this._width, this._height, {super.key});

  double _width;
  double _height;

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
            ElevatedButton(onPressed: (){}, child: Text("Reporting and Analytics")),
            ElevatedButton(onPressed: (){}, child: Text("Budget Allocation"))
          ],
        ),
      ),
    );
  }
}
