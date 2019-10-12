import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:only_kids/models/hairstyle.dart';

class HairstylesService {
  final CollectionReference _collectionRef = Firestore.instance.collection('hairstyles');

  Stream<List<Hairstyle>> getHairstyles() {
    Query query = _collectionRef.orderBy('order');
    return query.snapshots().map((list) => list.documents.map((snapshot) => Hairstyle.fromSnapshot(snapshot)).toList());
  }

  Future<double> getMaxOrder() async {
    final query = _collectionRef.orderBy('order', descending: true).limit(1);
    final querySnapshot = await query.getDocuments();
    final list = querySnapshot.documents.toList();
    if (list.length == 0) {
      return 0;
    }

    final documentSnapshot = list.first;
    final double maxOrder = documentSnapshot.data['order'];
    return maxOrder;
  }

  Future<String> add(
    String name,
    String price,
    String imageUrl,
    String imageStoragePath,
    double order,
  ) async {
    final hairstyle = Hairstyle(
      name: name,
      price: price,
      imageUrl: imageUrl,
      imageStoragePath: imageStoragePath,
      order: order,
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
