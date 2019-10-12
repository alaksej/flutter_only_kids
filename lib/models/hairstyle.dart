import 'package:cloud_firestore/cloud_firestore.dart';

class Hairstyle {
  final String id;
  final String name;
  final String price;
  final String imageUrl;
  final String imageStoragePath;

  const Hairstyle({
    this.id,
    this.name,
    this.price,
    this.imageUrl,
    this.imageStoragePath,
  });

  Hairstyle.fromMap(this.id, Map<String, dynamic> map)
      : imageUrl = map['imageUrl'],
        imageStoragePath = map['imageStoragePath'],
        name = map['name'],
        price = map['price'];

  Hairstyle.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.documentID,
          snapshot.data,
        );

  Map<String, dynamic> toMap() => {
        'imageUrl': imageUrl,
        'imageStoragePath': imageStoragePath,
        'name': name,
        'price': price,
      };

  @override
  String toString() => "Hairstyle<$name:$price>";
}
