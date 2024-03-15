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

          final List<Hairstyle> items = snapshot.data!;
          return ReorderableListView(
            onReorder: (oldIndex, newIndex) => _onReorder(oldIndex, newIndex, items),
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
      key: ValueKey(item.id),
      child: ListTile(
        leading: item.imageUrl != null
            ? CachedNetworkImage(
                imageUrl: item.imageUrl!,
              )
            : Image.asset('assets/only_kids_logo.png'),
        contentPadding: EdgeInsets.all(10.0),
        title: Text(item.name!),
        subtitle: Text(item.price!),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            final confirmed =
                await showConfirmationDialog(context, 'Delete', 'Are you sure you want to delete?', 'Delete');
            if (confirmed == null || !confirmed) {
              return;
            }

            try {
              await _hairstylesService.delete(item.id!);
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

  double _calculateNewOrder(int oldIndex, int newIndex, List<Hairstyle> items) {
    if (oldIndex < newIndex) {
      // removing the item at oldIndex will shorten the list by 1.
      newIndex -= 1;
    }

    final newIndexOrder = items[newIndex].order;
    final minOrder = 0.0;
    double newOrder;

    if (newIndex == 0) {
      // if moving to the first place
      // take the middle between the minOrder and the first item order
      newOrder = _interpolate(minOrder, newIndexOrder!);
    } else if (newIndex == items.length - 1) {
      // if moving to the last place
      // assign the order to be 1 greater than the last item's order
      newOrder = newIndexOrder!.ceil() + 1.0;
    } else {
      // if moving somewhere in the middle of the list
      // take newIndex item's order and the one's before it
      // interpolate between them and assign to the item being reordered
      if (oldIndex < newIndex) {
        newOrder = _interpolate(newIndexOrder!, items[newIndex + 1].order!);
      } else {
        newOrder = _interpolate(newIndexOrder!, items[newIndex - 1].order!);
      }
    }

    return newOrder;
  }

  void _onReorder(int oldIndex, int newIndex, List<Hairstyle> items) async {
    final itemBeingMoved = items[oldIndex];
    double newOrder = _calculateNewOrder(oldIndex, newIndex, items);
    final updatedItem = Hairstyle(
      id: itemBeingMoved.id,
      imageStoragePath: itemBeingMoved.imageStoragePath,
      imageUrl: itemBeingMoved.imageUrl,
      name: itemBeingMoved.name,
      order: newOrder,
      price: itemBeingMoved.price,
    );

    await _hairstylesService.update(updatedItem);
  }

  double _interpolate(double n1, double n2) {
    return (n1 + n2) / 2;
  }
}
