import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:newsfeed_mobile/Settings/parts/Colorselector.dart';
import 'package:newsfeed_mobile/models/HomeControlProvider.dart';
import 'package:provider/provider.dart';

/// A page which sets color for the app
class ColorSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeControlProvider homeControlProvider = Provider.of(context);
    Color primaryColor =
        homeControlProvider.primaryColor ?? Theme.of(context).primaryColor;
    Color tagColor =
        homeControlProvider.tagColor ?? Theme.of(context).buttonColor;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Pick primary color"),
            onTap: () {
              showDialog(
                context: context,
                builder: (c) => ColorSelector(
                  initColor: primaryColor,
                  selectColor: (c) {
                    homeControlProvider.primaryColor = c;
                  },
                ),
              );
            },
            trailing: CircleColor(
              circleSize: 30,
              color: primaryColor,
            ),
          ),
          ListTile(
            title: Text("Pick Tag color"),
            onTap: () {
              showDialog(
                context: context,
                builder: (c) => ColorSelector(
                  initColor: tagColor,
                  selectColor: (c) {
                    homeControlProvider.tagColor = c;
                  },
                ),
              );
            },
            trailing: CircleColor(
              circleSize: 30,
              color: tagColor,
            ),
          )
        ],
      ),
    );
  }
}
