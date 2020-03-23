import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DetailImageView extends StatelessWidget {
  final String imageURL;

  DetailImageView({this.imageURL});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PhotoView(
        imageProvider: NetworkImage(imageURL),
      ),
    );
  }
}
