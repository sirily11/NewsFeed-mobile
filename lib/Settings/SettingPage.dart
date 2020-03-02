import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:newsfeed_mobile/models/DatabaseProvider.dart';
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
  int selectedID = 0;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      int id = value.getInt("selectedFeedsourceKey");
      setState(() {
        selectedID = id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DatabaseProvider databaseProvider = Provider.of(context);
    return FutureBuilder<List<FeedSourceData>>(
      future: databaseProvider.getFeedSources(),
      builder: (c, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        List<FeedSourceData> sources = snapshot.data;
        return ListView.separated(
          itemBuilder: (c, index) {
            if (index == 0) {
              return FlatButton(
                onPressed: () async {
                  await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (ctx) {
                    return SettingsPage(
                      refresh: widget.refresh,
                    );
                  }));
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
                        FeedSourceData deleteSouce = sources.firstWhere(
                          (element) => element.id == index,
                        );
                        await databaseProvider.deleteFeedSource(deleteSouce);
                        setState(() {
                          selectedID = -1;
                        });
                      }),
                ],
                child: Container(
                  child: RadioListTile<int>(
                    onChanged: (data) async {
                      FeedSourceData selectedSource = sources.firstWhere(
                        (element) => element.id == data,
                        orElse: () => null,
                      );
                      setState(() {
                        selectedID = data;
                      });
                      FeedProvider provider =
                          Provider.of(context, listen: false);
                      provider.setupURL(selectedSource.link, key: data);
                      await widget.refresh();
                    },
                    value: sources[index - 1].id,
                    groupValue: selectedID,
                    title: Text(sources[index - 1].name),
                    subtitle: Text(sources[index - 1].link),
                  ),
                ),
              );
            }
          },
          separatorBuilder: (c, i) => Divider(),
          itemCount: sources.length + 1,
        );
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
        FeedProvider provider = Provider.of(context, listen: false);
        DatabaseProvider databaseProvider = Provider.of(context, listen: false);
        provider.setupURL(url);
        await databaseProvider.addFeedSource(
          FeedSourceData(name: title, link: url),
        );
        await widget.refresh();
        setState(() {
          isLoading = false;
        });
        await buildSuccessDialog(context);
        Navigator.pop(context);
      } catch (err) {
        print(err);
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
            TextFormField(
              key: Key("url_field"),
              controller: controller,
              validator: (text) {
                if (!text.startsWith("http://") &&
                    !text.startsWith("https://")) {
                  return "URL must start with http:// or https://";
                }
                if (text.endsWith("/")) {
                  return "url must no ends with /";
                }
                return null;
              },
              autovalidate: true,
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
