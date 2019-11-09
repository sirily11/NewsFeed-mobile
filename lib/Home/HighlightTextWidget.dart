import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/models/AlgoliaQueryData.dart';
import 'package:newsfeed_mobile/utils/utils.dart';

class HighlightTextWidget extends StatelessWidget {
  final String text;

  HighlightTextWidget({this.text});

  @override
  Widget build(BuildContext context) {
    List<HighlightText> textList = getHighlightText(text);

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: textList.map<TextSpan>((t) {
          if (t.isBold) {
            return TextSpan(
              text: t.text,
              style: DefaultTextStyle.of(context).style.copyWith(
                  fontWeight: FontWeight.bold, color: Colors.yellowAccent),
            );
          }
          return TextSpan(
              text: t.text, style: DefaultTextStyle.of(context).style);
        }).toList(),
      ),
    );
  }
}
