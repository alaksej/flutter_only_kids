import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:only_kids/models/hairstyle.dart';

class HairstylesService {
  final CollectionReference _collectionRef = Firestore.instance.collection('hairstyles');

  Stream<List<Hairstyle>> getHairstyles() {
    Query query = _collectionRef.orderBy('name');
    return query.snapshots().map((list) => list.documents.map((snapshot) => Hairstyle.fromSnapshot(snapshot)).toList());
  }

  Future<String> add({String name, String price, String imageUrl}) async {
    final hairstyle = Hairstyle(
      name: name,
      price: price,
      imageUrl: imageUrl,
    );

    final docRef = await _collectionRef.add(hairstyle.toMap());

    return docRef.documentID;
  }

  Future<void> update(Hairstyle hairstyle) async {
    await _collectionRef.document(hairstyle.id).setData(hairstyle.toMap(), merge: true);
  }

  Future<void> delete(String id) async {
    await _collectionRef.document(id).delete();
  }
}
