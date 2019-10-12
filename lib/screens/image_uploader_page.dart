import 'dart:io';

import 'package:flutter/material.dart';
import 'package:only_kids/models/image_uploader_result.dart';
import 'package:only_kids/widgets/uploader.dart';

class ImageUploaderPage extends StatelessWidget {
  const ImageUploaderPage(this.image, this.imageStoragePath, {Key key}) : super(key: key);

  final File image;
  final String imageStoragePath;

  onCompleted(BuildContext context, ImageUploaderResult result) {
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Uploading image'),
      ),
      body: Uploader(
        image,
        imageStoragePath,
        onCompleted: (result) => onCompleted(context, result),
      ),
    );
  }
}
