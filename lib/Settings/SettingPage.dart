import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:newsfeed_mobile/models/FeedSource.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsSourceList extends StatefulWidget {
  final Function refresh;

  NewsSourceList({this.refresh});

  @override
  _NewsSourceListState createState() => _NewsSourceListState();
}

class _NewsSourceListState extends State<NewsSourceList> {
  List<FeedSourceData> feedSources = [];
  String selectedID = "0";

  @override
  void initState() {
    super.initState();
    this.fetchFeed();
  }

  Future fetchFeed() async {
  
    var prefs = await SharedPreferences.getInstance();
    var selectedLink = prefs.getString("baseURL");
    setState(() {
      this.feedSources = feedSources;
      if (feedSources != null) {
        selectedID = feedSources
            .firstWhere((f) => f.link == selectedLink, orElse: () => null)
            ?.id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (ctx, int) {
        return Divider();
      },
      itemCount: feedSources.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return FlatButton(
            onPressed: () async {
              await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) {
                return SettingsPage(
                  refresh: widget.refresh,
                );
              }));
              await this.fetchFeed();
            },
            child: Text("Add source"),
          );
        } else {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            secondaryActions: <Widget>[
              IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () async {
                  
                    await this.fetchFeed();
                  }),
            ],
            child: Container(
              child: RadioListTile(
                onChanged: (data) async {
                  setState(() {
                    selectedID = data;
                  });
                  FeedProvider provider = Provider.of(context);
                  provider.setupURL(feedSources
                      .firstWhere((f) => f.id == data, orElse: null)
                      ?.link);
                  await widget.refresh();
                },
                value: feedSources[index - 1].id,
                groupValue: selectedID,
                title: Text(feedSources[index - 1].name),
                subtitle: Text(feedSources[index - 1].link),
              ),
            ),
          );
        }
      },
    );
  }
}

class SettingsPage extends StatefulWidget {
  final Function refresh;

  SettingsPage({this.refresh});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isLoading = false;
  String url = "";
  TextEditingController controller = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) async {
      String url = prefs.getString("baseURL");
      setState(() {
        controller.text = url;
      });
    });
  }

  void _onSubmit(String url, String title) async {
    if (url.length > 0 && url.contains("http")) {
      setState(() {
        isLoading = true;
      });
      try {
        FeedProvider provider = Provider.of(context);

        provider.setupURL(url);
        await widget.refresh();
        setState(() {
          isLoading = false;
        });
        await buildSuccessDialog(context);
        Navigator.pop(context);
      } catch (err) {
        buildErrorDialog(context);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      buildErrorDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add news source"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              key: Key("name_field"),
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              key: Key("url_field"),
              controller: controller,
              decoration: InputDecoration(labelText: "Server URL"),
            ),
            if (isLoading)
              LinearProgressIndicator(
                key: Key("progress_bar"),
              ),
            RaisedButton(
              onPressed: () {
                if (controller.text != "" && nameController.text != "") {
                  this._onSubmit(controller.text, nameController.text);
                } else {
                  buildErrorDialog(context);
                }
              },
              child: Text("Confirm"),
            )
          ],
        ),
      ),
    );
  }

  Future buildErrorDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Connection Error"),
          content: Text(
              "Cannot connect to the server, make sure you url is correct"),
          actions: <Widget>[
            FlatButton(
              key: Key("e_ok"),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("ok"),
            )
          ],
        );
      },
    );
  }

  Future buildSuccessDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Connection Established"),
          content: Text(
              "You are now connected to the server, go back to your news screen"),
          actions: <Widget>[
            FlatButton(
              key: Key("ok"),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("ok"),
            )
          ],
        );
      },
    );
  }
}
