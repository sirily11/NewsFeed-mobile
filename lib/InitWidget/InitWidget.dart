import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/models/DatabaseProvider.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:provider/provider.dart';

/// Call provider init function here
class InitWidget extends StatefulWidget {
  final Widget child;

  InitWidget({@required this.child});
  @override
  _InitWidgetState createState() => _InitWidgetState();
}

class _InitWidgetState extends State<InitWidget> {
  bool hasInit = false;

  @override
  void initState() {
    super.initState();
    FeedProvider feedProvider = Provider.of(context, listen: false);
    DatabaseProvider databaseProvider = Provider.of(context, listen: false);

    feedProvider.init().then((value) async {
      await databaseProvider.init();
      setState(() {
        hasInit = true;
      });
    }).catchError((err) => print("Init error: $err"));
  }

  @override
  Widget build(BuildContext context) {
    if (hasInit) {
      return widget.child;
    }

    return Container(
      color: Colors.white,
    );
  }
}
