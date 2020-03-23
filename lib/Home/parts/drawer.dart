import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: <Widget>[
        DrawerHeader(
          child: Center(child: Text("Settings")),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Home"),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Settings"),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/settings');
          },
        ),
        ListTile(
          leading: Icon(Icons.supervised_user_circle),
          title: Text("Users"),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/users');
          },
        )
      ],
    ));
  }
}
