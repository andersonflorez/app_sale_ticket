import 'package:app_sale_tickets/src/entity/ticket_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScannerQrRepository {
  final _collection = FirebaseFirestore.instance.collection('seat_sale');

  Future<TicketEntity?> getTicketByCode(String code) async {
    final doc = await _collection.doc(code).get();
    if (!doc.exists) return null;
    return TicketEntity.fromMap(doc.id, doc.data()!);
  }

  Future<void> markTicketAsUsed(String ticketId) async {
    await _collection.doc(ticketId).update({
      'used': true,
      'dateUsed': DateTime.now().toIso8601String(),
    });
  }
}
