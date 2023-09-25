import 'package:flutter/material.dart';

class FinanceAdminMenuDrawer extends StatelessWidget {
   const FinanceAdminMenuDrawer(this._width, this._height, {super.key});

  final double _width;
   final double _height;

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
        ),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: _width/19.63636363636364), // 20
          child: ElevatedButton(onPressed: () {}, child: const Text("Pending Claims")),
        ),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: _width/19.63636363636364), // 20
          child: ElevatedButton(onPressed: () {}, child: const Text("Reporting and Analytics")),
        ),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: _width/19.63636363636364), // 20
          child: ElevatedButton(onPressed: () {}, child: const Text("My Claims")),
        ),

      ],
    ));
  }
}
