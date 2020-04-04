import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/models/HomeControlProvider.dart';
import 'package:provider/provider.dart';

class FontSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeControlProvider homeControlProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Fonts"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Card(
                child: Center(
                  child: Text(
                    "Preview Text\n预览文字",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Select Font"),
                DropdownButton<FontSelections>(
                  value: homeControlProvider.fontSelections,
                  onChanged: (v) {
                    homeControlProvider.fontSelections = v;
                  },
                  items: homeControlProvider.avaliableFonts
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name),
                        ),
                      )
                      .toList(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
