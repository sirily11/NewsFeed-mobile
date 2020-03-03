import 'package:flutter/material.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:provider/provider.dart';

class CommentReplyField extends StatefulWidget {
  final Feed feed;

  CommentReplyField({@required this.feed});

  @override
  _CommentReplyFieldState createState() => _CommentReplyFieldState();
}

class _CommentReplyFieldState extends State<CommentReplyField> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FeedProvider provider = Provider.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(19.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 9,
              child: TextField(
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                controller: controller,
                decoration: InputDecoration(labelText: "Comment"),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                  if (provider.user == null) {
                    return null;
                  }
                  await provider.sendComment(widget.feed, controller.text);
                  controller.clear();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
