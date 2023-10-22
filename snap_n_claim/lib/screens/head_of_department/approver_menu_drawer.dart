import 'dart:io';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snap_n_claim/models/employee.dart';
import 'package:snap_n_claim/screens/common/login_screen.dart';
import 'package:snap_n_claim/screens/finance_admin/finance_admin_home_screen.dart';

import 'approver_approvalhistory_screen.dart';

class ApproverMenuDrawer extends StatelessWidget {
  const ApproverMenuDrawer(
      this._width, this._height, this.currentPage, this.user,
      {super.key});

  final double _width;
  final double _height;
  final String currentPage;
  final Employee user;

  void _onTapPendingClaimsBtn(BuildContext context) {
    Navigator.of(context).pop();
    if (currentPage != "Approver Dashboard") {
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

  void _onTapViewReportsBtn(BuildContext context) {
    Navigator.of(context).pop();
    if (currentPage != "View Reports") {
      Navigator.push(
        context,
        PageTransition(
          child: approvalHistory(_width, _height, user),
          type: PageTransitionType.rightToLeft,
          alignment: Alignment.center,
          isIos: true,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _onTapMyClaimsBtn(BuildContext context) {}

  Future<void> _onTapSignOutBtn(BuildContext context) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    File file = File('$path/userdata.txt');
    await file.delete();

    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => LoginScreen(_width, _height)));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        UserAccountsDrawerHeader(
          accountName: const Text('Head of Department'),
          accountEmail: Text(user.email),
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
              _onTapViewReportsBtn(context);

            },
            child: const Text("View Reports"),
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
        ),
        const Divider(
          thickness: 5,
          indent: 20,
          endIndent: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _width / 19.63636363636364,
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
