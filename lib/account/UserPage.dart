import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_schema_form/json_schema_form.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:newsfeed_mobile/Home/parts/drawer.dart';
import 'package:newsfeed_mobile/account/MyCommentPage.dart';
import 'package:newsfeed_mobile/master-detail/master_detail_route.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool isLogin = true;

  final List<Map<String, dynamic>> loginSchema = [
    {
      "label": "Login User Name",
      "readonly": false,
      "extra": {"help": "Please Enter your user name", "default": ""},
      "name": "username",
      "widget": "text",
      "required": true,
      "translated": false,
      "validations": {
        "length": {"maximum": 1024}
      }
    },
    {
      "label": "Password",
      "readonly": false,
      "extra": {"help": "Please Enter your password", "default": ""},
      "name": "password",
      "widget": "text",
      "required": true,
      "translated": false,
      "validations": {
        "length": {"maximum": 1024}
      }
    }
  ];

  final List<Map<String, dynamic>> signUpSchema = [
    {
      "label": "SignUp User Name",
      "readonly": false,
      "extra": {"help": "Please Enter your user name", "default": ""},
      "name": "username",
      "widget": "text",
      "required": true,
      "translated": false,
      "validations": {
        "length": {"maximum": 1024}
      }
    },
    {
      "label": "Password",
      "readonly": false,
      "extra": {"help": "Please Enter your password", "default": ""},
      "name": "password",
      "widget": "text",
      "required": true,
      "translated": false,
      "validations": {
        "length": {"maximum": 1024}
      }
    },
    {
      "label": "Password",
      "readonly": false,
      "extra": {"help": "Please Enter your password", "default": ""},
      "name": "password_confirm",
      "widget": "text",
      "required": true,
      "translated": false,
      "validations": {
        "length": {"maximum": 1024}
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    FeedProvider provider = Provider.of(context);

    if (provider.user != null) {
      return Scaffold(
        drawer: DrawerWidget(),
        appBar: AppBar(
          title: Text("Users"),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text("You are Logined"),
            ),
            Divider(),
            ListTile(
              onTap: () {
                if (Platform.isMacOS) {
                  Navigator.push(
                    context,
                    DetailRoute(
                      builder: (c) => CommentPage(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => CommentPage(),
                    ),
                  );
                }
              },
              title: Text("View All My Comments"),
              trailing: Icon(Icons.more_horiz),
            ),
            Divider(),
            FlatButton(
              onPressed: () async {
                await provider.logout();
              },
              child: Text(
                "LogOut",
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: provider.isLoading,
        child: Container(
          child: Stack(
            children: <Widget>[
              if (isLogin)
                Container(
                  key: Key("login"),
                  child: JSONSchemaForm(
                    schema: loginSchema,
                    onSubmit: (data) async {
                      try {
                        await provider.login(data: data);
                      } catch (err) {
                        showDialog(
                            context: context,
                            builder: (c) => AlertDialog(
                                  content: Text("${err.toString()}"),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("ok"),
                                    )
                                  ],
                                ));
                      }
                    },
                  ),
                ),
              if (!isLogin)
                Container(
                  key: Key("sign up"),
                  child: JSONSchemaForm(
                    schema: signUpSchema,
                    onSubmit: (data) async {
                      await provider.signUp(data, context);
                    },
                  ),
                ),
              Positioned(
                bottom: 30,
                right: 10,
                child: FloatingActionButton(
                  tooltip: "Switch",
                  onPressed: () async {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Icon(Icons.loop),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
