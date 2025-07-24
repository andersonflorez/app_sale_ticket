import 'package:cloud_firestore/cloud_firestore.dart';

class ListenTicketsFirestoreRepository {
  final _collection = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> listenTickets() {
    return _collection.collection('seat_sale').snapshots();
  }
}
