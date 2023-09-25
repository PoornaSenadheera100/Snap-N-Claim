import 'package:flutter/material.dart';

class FinanceAdminMenuDrawer extends StatelessWidget {
  const FinanceAdminMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child:ListView(
          children: [
            UserAccountsDrawerHeader(accountName: Text('Finance Administrator'), accountEmail: Text('finadmin@spsh.lk'),currentAccountPicture: CircleAvatar(child: ClipOval(child: Image.asset('assets/avatarpic.jpg'),),),)
          ],
        )
    );

  }
}
