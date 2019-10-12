import 'dart:io';

import 'package:flutter/material.dart';
import 'package:only_kids/widgets/uploader.dart';

class ImageUploaderPage extends StatelessWidget {
  const ImageUploaderPage(this.image, {Key key}) : super(key: key);

  final File image;

  onCompleted(BuildContext context, String downloadUrl) {
    Navigator.pop(context, downloadUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Uploading image'),
      ),
      body: Uploader(
        image,
        onCompleted: (downloadUrl) => onCompleted(context, downloadUrl),
      ),
    );
  }
}
