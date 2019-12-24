import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:url_launcher/url_launcher.dart';

class DocView extends StatelessWidget {
  final String path;
  DocView({@required this.path});

  Future<String> fetchHelpDoc() async {
    try {
      Dio dio = new Dio();
      await Future.delayed(Duration(milliseconds: 200));
      Response response = await dio
          .get("https://sirily11.github.io/docs/${this.path}/index.md");
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (err) {
      print(err);
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Help",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.open_in_browser),
            onPressed: () async {
              if (await canLaunch(
                  "https://sirily11.github.io/docs/${this.path}")) {
                await launch("https://sirily11.github.io/docs/${this.path}");
              }
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: fetchHelpDoc(),
        builder: (context, asyncSnapshot) {
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: !asyncSnapshot.hasData
                  ? Column(
                      children: <Widget>[
                        Image.asset("assets/code.gif"),
                        JumpingDotsProgressIndicator(
                          fontSize: 26,
                          numberOfDots: 5,
                          color: Colors.white,
                        )
                      ],
                    )
                  : Markdown(
                      data: asyncSnapshot.data,
                      onTapLink: (link) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return DocView(
                            path: "${link}.md",
                          );
                        }));
                      },
                    ));
        },
      ),
    );
  }
}
