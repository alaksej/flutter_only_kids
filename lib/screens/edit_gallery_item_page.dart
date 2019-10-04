import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:only_kids/models/hairstyle.dart';
import 'package:only_kids/services/hairstyles_service.dart';

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
  String imageUrl;

  @override
  void initState() {
    nameTextController.text = widget.hairstyle?.name;
    priceTextController.text = widget.hairstyle?.price;
    imageUrl = widget.hairstyle?.imageUrl;
    super.initState();
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
            onPressed: imageUrl != null
                ? () async {
                    isNew
                        ? await _hairstylesService.add(
                            name: nameTextController.text, price: priceTextController.text, imageUrl: imageUrl)
                        : await _hairstylesService.update(
                            Hairstyle(
                              id: widget.hairstyle.id,
                              name: nameTextController.text,
                              price: priceTextController.text,
                              imageUrl: imageUrl,
                            ),
                          );
                    Navigator.pop(context);
                  }
                : null,
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
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 200,
              child: isNew
                  ? RaisedButton(
                      child: Text('Upload an image'),
                      onPressed: () {},
                    )
                  : CachedNetworkImage(
                      imageUrl: imageUrl,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
