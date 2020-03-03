import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:newsfeed_mobile/Detail/DetailPage.dart';
import 'package:newsfeed_mobile/models/Feed.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';
import 'package:provider/provider.dart';

class CommentPage extends StatefulWidget {
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  @override
  void initState() {
    super.initState();
    FeedProvider provider = Provider.of(context, listen: false);
    Future.delayed(Duration(milliseconds: 30)).then(
      (value) => provider.fetchComments(),
    );
  }

  @override
  Widget build(BuildContext context) {
    FeedProvider provider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("My Comments"),
        leading: BackButton(),
      ),
      body: ModalProgressHUD(
        inAsyncCall: provider.isLoading,
        child: EasyRefresh(
          onLoad: () async {
            await provider.fetchMoreComments();
          },
          header: ClassicalHeader(textColor: Colors.white),
          footer: ClassicalFooter(textColor: Colors.white),
          child: ListView.separated(
              itemBuilder: (c, i) {
                FeedComment comment = provider.comments[i];
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () async {
                        await provider.deleteComment(comment);
                      },
                    ),
                  ],
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => DetailPage(
                            feed: comment.newsFeed,
                          ),
                        ),
                      );
                    },
                    title: Text("${comment.newsFeed.title}"),
                    subtitle: Text("${comment.comment}"),
                  ),
                );
              },
              separatorBuilder: (c, i) => Divider(),
              itemCount: provider.comments.length),
        ),
      ),
    );
  }
}
