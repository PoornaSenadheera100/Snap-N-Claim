import 'package:flutter/material.dart';

import '../../models/employee.dart';

class ApproverNavBar extends StatelessWidget {
  const ApproverNavBar(this.user, {super.key});

  final Employee user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text('Head of department'),
          accountEmail: Text(user.email),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: Image.asset(
                'assets/avatarpic.jpg',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            image: new DecorationImage(
              image: new AssetImage('assets/useravatarimage.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text("Approver Dashboard"),
          onTap: null,
          trailing: ClipOval(
            child: Container(
              color: Colors.red,
              width: 20,
              height: 20,
              child: Center(
                child: Text(
                  '8',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
        Divider(),
        ListTile(
            leading: Icon(Icons.analytics_outlined),
            title: Text("View Reports"),
            onTap: null),
        Divider(),
        ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text("My Claims"),
            onTap: null),
        Divider(),
      ],
    ));
  }
}
