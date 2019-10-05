import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapturePage extends StatefulWidget {
  ImageCapturePage({this.imageFile});

  final File imageFile;

  createState() => _ImageCapturePageState();
}

class _ImageCapturePageState extends State<ImageCapturePage> {
  /// Active image file
  File _imageFile;

  @override
  initState() {
    _imageFile = widget.imageFile;
    super.initState();
  }

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 3),
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Theme.of(context).primaryColor,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Crop It',
      ),
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select an image'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _imageFile != null
                ? () {
                    Navigator.pop(context, _imageFile);
                  }
                : null,
          )
        ],
      ),
      // Select an image from the camera or gallery
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.photo_camera,
                color: Colors.black45,
              ),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(
                Icons.photo_library,
                color: Colors.black45,
              ),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),

      // Preview the image and crop it
      body: ListView(
        children: <Widget>[
          if (_imageFile == null) ...[
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Center(
                child: Text(
                  'No image is selected',
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ),
          ],
          if (_imageFile != null) ...[
            GestureDetector(
              onTap: _cropImage,
              child: Card(
                child: SizedBox(
                  width: 300,
                  height: 450,
                  child: Image.file(_imageFile),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
