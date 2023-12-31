import 'dart:io';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snap_n_claim/models/employee.dart';
import 'package:snap_n_claim/screens/common/login_screen.dart';
import 'package:snap_n_claim/screens/finance_admin/finance_admin_budget_allocation_selection_screen.dart';
import 'package:snap_n_claim/screens/finance_admin/finance_admin_home_screen.dart';
import 'package:snap_n_claim/screens/finance_admin/finance_admin_reports_selection_screen.dart';
import 'package:snap_n_claim/screens/finance_admin/login_status.dart';

import 'create_account_screen.dart';


import '../employee/employee_add_modify_claim_screen.dart';
import '../employee/employee_home_screen.dart';

class FinanceAdminMenuDrawer extends StatelessWidget {
  const FinanceAdminMenuDrawer(
      this._width, this._height, this.currentPage, this.user,
      {super.key});

  final double _width;
  final double _height;
  final String currentPage;
  final Employee user;

  void _onTapPendingClaimsBtn(BuildContext context) {
    Navigator.of(context).pop();
    if (currentPage != "Finance Pending Claims") {
      Navigator.pushReplacement(
        context,
        PageTransition(
          child: FinanceAdminHomeScreen(_width, _height, user),
          type: PageTransitionType.rightToLeft,
          alignment: Alignment.center,
          isIos: true,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

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

  void _onTapBudgetAllocationBtn(BuildContext context) {
    Navigator.of(context).pop();
    if (currentPage != "Budget Allocation Menu") {
      Navigator.pushReplacement(
        context,
        PageTransition(
          child: FinanceAdminBudgetAllocationSelectionScreen(
              _width, _height, user),
          type: PageTransitionType.rightToLeft,
          alignment: Alignment.center,
          isIos: true,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _onTapUserConfigBtn(BuildContext context) {
    Navigator.of(context).pop();
    if (currentPage != "User Configuration Screen") {
      Navigator.pushReplacement(
        context,
        PageTransition(
          child: LoginStatusScreen(
              _width, _height, user),
          type: PageTransitionType.rightToLeft,
          alignment: Alignment.center,
          isIos: true,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _onTapMyClaimsBtn(BuildContext context) {
    Navigator.of(context).pop();

    if (currentPage != 'All Claims') {
      Navigator.pushReplacement(
        context,
        PageTransition(
          child: EmployeeHomeScreen(_width, _height, user),
          type: PageTransitionType.rightToLeft,
          alignment: Alignment.center,
          isIos: true,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

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
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _onTapSignOutBtn(BuildContext context) async {
    var dialogRes = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              actionsAlignment: MainAxisAlignment.spaceBetween,
              content: const Text('Are you sure you want to signout?'),
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

    if (dialogRes == true) {
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
    return Drawer(
        child: ListView(
      children: [
        UserAccountsDrawerHeader(
          accountName: const Text('Finance Administrator'),
          accountEmail: const Text('finadmin@spsh.lk'),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: Image.asset('assets/avatarpic.jpg'),
            ),
          ),
          decoration: const BoxDecoration(
            color: Colors.blueAccent,
            image: DecorationImage(
              image: AssetImage('assets/useravatarimage.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _width / 19.63636363636364,
          ), // 20
          child: ElevatedButton(
            onPressed: () {
              _onTapPendingClaimsBtn(context);
            },
            child: const Text("Pending Claims"),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _width / 19.63636363636364,
          ), // 20
          child: ElevatedButton(
            onPressed: () {
              _onTapReportsBtn(context);
            },
            child: const Text("Reports"),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _width / 19.63636363636364,
          ), // 20
          child: ElevatedButton(
            onPressed: () {
              _onTapBudgetAllocationBtn(context);
            },
            child: const Text("Budget Allocation"),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _width / 19.63636363636364,
          ), // 20
          child: ElevatedButton(
            onPressed: () {
              _onTapUserConfigBtn(context);
            },
            child: const Text("User Configurations"),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _width / 19.63636363636364,
          ), // 20
          child: ElevatedButton(
            onPressed: () {
              _onTapMyClaimsBtn(context);
            },
            child: const Text("My Claims"),
          ),
        ),Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _width / 19.63636363636364,
          ), // 20
          child: ElevatedButton(
            onPressed: () {
              _onTapAddNewClaimBtn(context);
            },
            child: const Text("Add new claim"),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _width / 19.63636363636364,
            vertical: _height / 16.05818181818182,
          ), // 20
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
      ],
    ));
  }
}
