import 'package:flutter/material.dart';

class ApproverNavBar extends StatelessWidget {
  const ApproverNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text('Head of department'),
          accountEmail: Text('Approver@gmail.com'),
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
              image:new AssetImage('assets/useravatarimage.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text("Approver Dashboard"),
          onTap: null
        ),
        ListTile(
            leading: Icon(Icons.analytics_outlined),
            title: Text("View Reports"),
            onTap: null
        ),
        ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text("My Claims"),
            onTap: null
        ),
      ],
    ));
  }
}
