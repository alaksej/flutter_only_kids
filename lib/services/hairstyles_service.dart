import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:only_kids/models/hairstyle.dart';

class HairstylesService {
  final CollectionReference _collectionRef = FirebaseFirestore.instance.collection('hairstyles');

  Stream<List<Hairstyle>> getHairstyles() {
    Query query = _collectionRef.orderBy('order');
    return query.snapshots().map((list) => list.docs.map((snapshot) => Hairstyle.fromSnapshot(snapshot)).toList());
  }

  Future<double> getMaxOrder() async {
    final query = _collectionRef.orderBy('order', descending: true).limit(1);
    final querySnapshot = await query.get();
    final list = querySnapshot.docs.toList();
    if (list.length == 0) {
      return 0;
    }

    final documentSnapshot = list.first;
    Object? data = documentSnapshot.data();
    final double maxOrder = data == null ? 0 : (data as Map)['order'];
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

    return docRef.id;
  }

  Future<void> update(Hairstyle hairstyle) async {
    await _collectionRef.doc(hairstyle.id).set(hairstyle.toMap(), SetOptions(merge: true));
  }

  Future<void> delete(String id) async {
    await _collectionRef.doc(id).delete();
  }
}
