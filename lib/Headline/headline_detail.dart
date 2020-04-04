import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_screen/json_screen/views/json_screen.dart';
import 'package:newsfeed_mobile/Headline/detail_imageView.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/utils/utils.dart';

class HeadlineDetail extends StatelessWidget {
  final Headline headline;
  HeadlineDetail({@required this.headline});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${headline.title}",
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Theme(
        data: ThemeData.dark().copyWith(
          textTheme: TextTheme().copyWith(
            bodyText1: TextStyle(fontSize: 16),
          ),
        ),
        child: JsonScreen(
          onLinkTap: (link) async {
            redirect(link, context);
          },
          onImageTap: (link) async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => DetailImageView(
                  imageURL: link,
                ),
              ),
            );
          },
          json: JsonDecoder().convert(headline.content),
        ),
      ),
    );
  }
}
