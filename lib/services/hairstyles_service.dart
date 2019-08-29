import 'package:cloud_firestore/cloud_firestore.dart';

class HairstylesService {
  final CollectionReference _collectionRef = Firestore.instance.collection('hairstyles');

  Stream<List> getHairstyles() {
    Query query = _collectionRef.orderBy('name');
    return query.snapshots().map((list) => list.documents.map((doc) => doc.data).toList());
  }
}
