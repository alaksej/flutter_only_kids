import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:only_kids/models/hairstyle.dart';
import 'package:only_kids/services/hairstyles_service.dart';
import 'package:only_kids/utils/utils.dart';
import 'package:only_kids/widgets/spinner.dart';

import '../main.dart';

class EditGalleryPage extends StatefulWidget {
  EditGalleryPage({Key key}) : super(key: key);

  _EditGalleryPageState createState() => _EditGalleryPageState();
}

class _EditGalleryPageState extends State<EditGalleryPage> {
  final HairstylesService _hairstylesService = getIt.get<HairstylesService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit gallery'),
      ),
      body: StreamBuilder<List<Hairstyle>>(
        stream: _hairstylesService.getHairstyles(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Spinner();
          }

          final List items = snapshot.data;
          return ListView(
            children: items.map((item) => _buildItem(context, item)).toList(),
          );
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, Hairstyle item) {
    return Card(
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: item.imageUrl,
        ),
        contentPadding: EdgeInsets.all(10.0),
        title: Text(item.name),
        subtitle: Text(item.price),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            try {
              await _hairstylesService.delete(item.id);
            } catch (e) {
              print(e);
              showSnackBar(context: context, text: 'Error deleting the item');
            }
          },
        ),
        onTap: () {
          print('editing');
        },
      ),
    );
  }
}
