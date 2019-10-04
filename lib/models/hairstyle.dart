import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:only_kids/models/time_slot.dart';

class Hairstyle {
  final String id;
  final String name;
  final String price;
  final String imageUrl;

  const Hairstyle({
    this.id,
    this.name,
    this.price,
    this.imageUrl,
  });

  Hairstyle.fromMap(this.id, Map<String, dynamic> map)
      : assert(map['imageUrl'] != null),
        imageUrl = map['imageUrl'],
        name = map['name'],
        price = map['price'];

  Hairstyle.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.documentID,
          snapshot.data,
        );

  Map<String, dynamic> toMap() => {
        'imageUrl': imageUrl,
        'name': name,
        'price': price,
      };

  @override
  String toString() => "Hairstyle<$name:$price>";
}
