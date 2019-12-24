import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/Docs/DocsView.dart';

class HelpCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
            key: Key("hello_card"),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "No NewsFeed Source detected",
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  Text(
                      "You can use the docs to help with setup process. Or if you already know how to setup, click settings icon to setup."),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (ctx) {
                          return DocView(
                            path: "news-feed",
                          );
                        }),
                      );
                    },
                    child: Text("Go to Docs"),
                  )
                ],
              ),
            ))
      ],
    );
  }
}
