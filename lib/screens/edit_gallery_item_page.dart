import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:only_kids/models/hairstyle.dart';
import 'package:only_kids/models/image_uploader_result.dart';
import 'package:only_kids/screens/image_uploader_page.dart';
import 'package:only_kids/services/hairstyles_service.dart';
import 'package:only_kids/widgets/spinner.dart';

import '../main.dart';

class EditGalleryItemPage extends StatefulWidget {
  EditGalleryItemPage({this.hairstyle, Key key}) : super(key: key);

  final Hairstyle hairstyle;

  _EditGalleryItemPageState createState() => _EditGalleryItemPageState();
}

class _EditGalleryItemPageState extends State<EditGalleryItemPage> {
  final HairstylesService _hairstylesService = getIt.get<HairstylesService>();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _autovalidate = false;
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController priceTextController = TextEditingController();
  File _savedImageFile;
  File _imageFile;
  bool errorLoadingImage = false;

  @override
  void initState() {
    nameTextController.text = widget.hairstyle?.name;
    priceTextController.text = widget.hairstyle?.price;
    final imageUrl = widget.hairstyle?.imageUrl;
    if (imageUrl != null) {
      DefaultCacheManager().getSingleFile(imageUrl).then((file) {
        _savedImageFile = file;
        setState(() {
          _imageFile = file;
        });
      }).catchError((e) {
        print(e);
        setState(() {
          errorLoadingImage = true;
        });
      });
    }
    super.initState();
  }

  bool get isLoadingImage => !errorLoadingImage && widget.hairstyle?.imageUrl != null && _imageFile == null;
  bool get shouldUploadImage => _imageFile != null && _imageFile != _savedImageFile;

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
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

  @override
  Widget build(BuildContext context) {
    final bool isNew = widget.hairstyle == null;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(isNew ? 'Add hairstyle' : 'Edit style'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _imageFile != null ? () => handleSave(context, isNew) : null,
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              autovalidate: _autovalidate,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: nameTextController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Title',
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: priceTextController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Price',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: isLoadingImage
                    ? Spinner()
                    : errorLoadingImage
                        ? Text('Error loading image')
                        : Column(
                            children: <Widget>[
                              Row(
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
                                  if (_imageFile != null)
                                    IconButton(
                                      icon: Icon(
                                        Icons.crop,
                                        color: Colors.black54,
                                      ),
                                      onPressed: _cropImage,
                                    ),
                                ],
                              ),
                              SizedBox(
                                height: 200,
                                child: Center(
                                  child: _imageFile != null
                                      ? Image.file(_imageFile)
                                      : Padding(
                                          padding: const EdgeInsets.only(top: 40.0),
                                          child: Center(
                                            child: Text(
                                              'Take a picture using camera or select from gallery',
                                              style: Theme.of(context).textTheme.title,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  handleSave(BuildContext context, bool isNew) async {
    String imageUrl = widget.hairstyle?.imageUrl;
    String imageStoragePath = widget.hairstyle?.imageStoragePath;

    if (shouldUploadImage) {
      final ImageUploaderResult uploadResult = await Navigator.push<ImageUploaderResult>(context,
          MaterialPageRoute(builder: (context) => ImageUploaderPage(_imageFile, widget.hairstyle?.imageStoragePath)));
      imageUrl = uploadResult?.downloadUrl ?? imageUrl;
      imageStoragePath = uploadResult?.imageStoragePath;
    }

    assert(imageUrl != null && imageStoragePath != null);

    isNew && imageUrl != null
        ? await _hairstylesService.add(
            name: nameTextController.text,
            price: priceTextController.text,
            imageUrl: imageUrl,
            imageStoragePath: imageStoragePath,
          )
        : await _hairstylesService.update(
            Hairstyle(
              id: widget.hairstyle.id,
              name: nameTextController.text,
              price: priceTextController.text,
              imageUrl: imageUrl,
              imageStoragePath: imageStoragePath,
            ),
          );
    Navigator.pop(context);
  }
}
