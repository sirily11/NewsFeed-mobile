import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:newsfeed_mobile/Detail/CommentReplyFiled.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:newsfeed_mobile/utils/utils.dart';
import 'package:provider/provider.dart';

class DetailCommentPage extends StatelessWidget {
  final List<FeedComment> comments;
  final Feed feed;

  DetailCommentPage({@required this.comments, @required this.feed});

  @override
  Widget build(BuildContext context) {
    FeedProvider provider = Provider.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: ModalProgressHUD(
        inAsyncCall: provider.isLoading,
        child: Scaffold(
          appBar: AppBar(
            title: Text("${comments.length} Comments"),
          ),
          body: Stack(
            children: <Widget>[
              ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (c, i) {
                    FeedComment comment = comments[i];
                    return ListTile(
                      leading: Icon(
                        Icons.supervised_user_circle,
                        size: 50,
                      ),
                      title: Text("${comment.author.username}"),
                      subtitle: Text("${comment.comment}"),
                      trailing: Text("${getTime(comment.publishedTime)}"),
                    );
                  }),
              Positioned(
                bottom: 0,
                child: provider.user != null
                    ? CommentReplyField(
                        feed: this.feed,
                      )
                    : Container(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
