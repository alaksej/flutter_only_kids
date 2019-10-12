import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:only_kids/models/hairstyle.dart';
import 'package:only_kids/screens/edit_gallery_item_page.dart';
import 'package:only_kids/services/hairstyles_service.dart';
import 'package:only_kids/utils/utils.dart';
import 'package:only_kids/widgets/spinner.dart';

import '../main.dart';

class EditGalleryPage extends StatelessWidget {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditGalleryItemPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildItem(BuildContext context, Hairstyle item) {
    return Card(
      child: ListTile(
        leading: item.imageUrl != null
            ? CachedNetworkImage(
                imageUrl: item.imageUrl,
              )
            : Image.asset('assets/only_kids_logo.png'),
        contentPadding: EdgeInsets.all(10.0),
        title: Text(item.name),
        subtitle: Text(item.price),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            final confirmed =
                await showConfirmationDialog(context, 'Delete', 'Are you sure you want to delete?', 'Delete');
            if (confirmed == null || !confirmed) {
              return;
            }

            try {
              await _hairstylesService.delete(item.id);
            } catch (e) {
              print(e);
              showSnackBar(context: context, text: 'Error deleting the item');
            }
          },
        ),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (BuildContext context) => EditGalleryItemPage(hairstyle: item)));
        },
      ),
    );
  }
}
