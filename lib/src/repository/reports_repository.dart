import 'package:app_sale_tickets/src/entity/ticket_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportsRepository {
  final _collection = FirebaseFirestore.instance.collection('seat_sale');

  Future<List<TicketEntity>> getTicketsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final query = await _collection
        .where('dateSale', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('dateSale', isLessThanOrEqualTo: end.toIso8601String())
        .get();

    return query.docs
        .map((doc) => TicketEntity.fromMap(doc.id, doc.data()))
        .toList();
  }
}
