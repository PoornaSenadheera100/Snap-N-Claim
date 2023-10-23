import 'dart:io';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/employee.dart';
import '../common/login_screen.dart';
import '../finance_admin/finance_admin_reports_selection_screen.dart';
import 'employee_add_modify_claim_screen.dart';
import 'employee_home_screen.dart';

class EmployeeMenuDrawer extends StatelessWidget {
  const EmployeeMenuDrawer(
      this._width, this._height, this.currentPage, this.user,
      {super.key});

  //variables
  final double _width;
  final double _height;
  final String currentPage;
  final Employee user;

  final int transitionDuration = 1;

  //methods

  // handle navigation to all claims screen
  void _onTapAllClaimsBtn(BuildContext context) {
    Navigator.of(context).pop();

    if (currentPage != 'All Claims') {
      Navigator.pushReplacement(
        context,
        PageTransition(
          child: EmployeeHomeScreen(_width, _height, user),
          type: PageTransitionType.rightToLeft,
          alignment: Alignment.center,
          isIos: true,
          duration: Duration(seconds: transitionDuration),
        ),
      );
    }
  }

  // handle navigation to add new claim screen
  _onTapAddNewClaimBtn(BuildContext context){
    Navigator.of(context).pop();

    if (currentPage != 'Add New Claim') {
      Navigator.push(
        context,
        PageTransition(
          child: EmployeeAddNewClaim(_width, _height, user),
          type: PageTransitionType.rightToLeft,
          alignment: Alignment.center,
          isIos: true,
          duration: Duration(seconds: transitionDuration),
        ),
      );
    }
  }

  //handle navigation to reports screen
  void _onTapReportsBtn(BuildContext context) {
    Navigator.of(context).pop();
    if (currentPage != "Reports") {
      Navigator.pushReplacement(
        context,
        PageTransition(
          child: FinanceAdminReportsSelectionScreen(_width, _height, user),
          type: PageTransitionType.rightToLeft,
          alignment: Alignment.center,
          isIos: true,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  //handle signout
  Future<void> _onTapSignOutBtn(BuildContext context) async {
    var dialogRes = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceBetween,
          content:
          const Text('Are you sure you want to signout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                return Navigator.pop(context, true);
              },
              child: const Text('Yes'),
            ),
          ],
        ));

    if(dialogRes == true){
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      File file = File('$path/userdata.txt');
      await file.delete();

      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(_width, _height)));
    }
  }

  @override
  Widget build(BuildContext context) {
    String userType = 'Employee';
    String userEmail = user.email;
    double widthDenominator = 19.63636363636364;

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userType),
            accountEmail: Text(userEmail),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('assets/avatarpic.jpg'),
              ),
            ),
            decoration: const BoxDecoration(
                color: Colors.blueAccent,
                image: DecorationImage(
                    image: AssetImage('assets/useravatarimage.jpg'),
                    fit: BoxFit.cover)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _width / widthDenominator,
            ),
            child: ElevatedButton(
              onPressed: () {
                _onTapAllClaimsBtn(context);
              },
              child: const Text('All claims'),
            ),
          ),Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _width / widthDenominator,
            ),
            child: ElevatedButton(
              onPressed: () {
                _onTapAddNewClaimBtn(context);
              },
              child: const Text('Add new claim'),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _width / widthDenominator,
            ),
            child: ElevatedButton(
              onPressed: () {
                _onTapReportsBtn(context);
              },
              child: const Text('Reports'),
            ),
          ),
          //add margin top to below button

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _width / 19.63636363636364,
            ), // 20
            child: Container(
              margin: EdgeInsets.only(top: 50),
              child: ElevatedButton(
                onPressed: () {
                  _onTapSignOutBtn(context);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith((states) => Colors.red),
                ),
                child: const Text("Sign out"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
