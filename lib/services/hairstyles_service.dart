import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:only_kids/models/hairstyle.dart';

class HairstylesService {
  final CollectionReference _collectionRef = Firestore.instance.collection('hairstyles');

  Stream<List<Hairstyle>> getHairstyles() {
    Query query = _collectionRef.orderBy('name');
    return query.snapshots().map((list) => list.documents.map((snapshot) => Hairstyle.fromSnapshot(snapshot)).toList());
  }

  Future<void> delete(String id) async {
    await _collectionRef.document(id).delete();
  }
}
