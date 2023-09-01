import 'package:flutter/material.dart';
class ApproverNavBar extends StatelessWidget {
  const ApproverNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:ListView(
        children: [
          UserAccountsDrawerHeader(accountName: Text('Head of department'), accountEmail: Text('Approver@gmail.com'),currentAccountPicture: CircleAvatar(child: ClipOval(child: Image.asset('assets/avatarpic.jpg'),),),)
        ],
      )
    );
  }
}
