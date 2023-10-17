import 'package:flutter/material.dart';
import 'package:snap_n_claim/models/employee.dart';
import 'finance_admin_menu_drawer.dart';
import 'finance_admin_reporting_screen.dart';

class FinanceAdminReportsSelectionScreen extends StatelessWidget {
  const FinanceAdminReportsSelectionScreen(this._width, this._height, this.user,
      {super.key});

  final double _width;
  final double _height;
  final Employee user;

  void _onTapReportingAndAnalyticsBtn(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            FinanceAdminReportingScreen(_width, _height, user)));
  }

  void _onTapViewClaimStatusBtn(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
      ),
      drawer: FinanceAdminMenuDrawer(_width, _height, "Reports", user),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: _width / 1.190082644628099,
              height: _height / 6.176223776223776,
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: Ink.image(
                  image: const AssetImage('assets/reporting_btn.png'),
                  fit: BoxFit.fill,
                  child: InkWell(
                    onTap: () {
                      _onTapReportingAndAnalyticsBtn(context);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              width: _width / 1.190082644628099,
              height: _height / 6.176223776223776,
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: Ink.image(
                  image: const AssetImage('assets/claim_status_btn.png'),
                  fit: BoxFit.fill,
                  child: InkWell(
                    onTap: () {
                      _onTapViewClaimStatusBtn(context);
                    },
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
