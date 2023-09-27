import 'package:flutter/material.dart';
import 'finance_admin_menu_drawer.dart';
import 'finance_admin_reporting_screen.dart';

class FinanceAdminReportsSelectionScreen extends StatelessWidget {
  const FinanceAdminReportsSelectionScreen(this._width, this._height,
      {super.key});

  final double _width;
  final double _height;

  void _onTapReportingAndAnalyticsBtn(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            FinanceAdminReportingScreen(_width, _height)));
  }

  void _onTapViewClaimStatusBtn(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports"),
      ),
      drawer: FinanceAdminMenuDrawer(_width, _height, "Reports"),
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
                  _onTapViewClaimStatusBtn(context);
                },
                child: Text("View Claim Status")),
            Container(
              width: 100,
              height: 50,
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: Ink.image(
                  image: AssetImage('assets/avatarpic.jpg'),
                  fit: BoxFit.fill,
                  child: InkWell(
                    onTap: () {},
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
