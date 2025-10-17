import 'package:app_sale_tickets/src/entity/ticket_entity.dart';
import 'package:app_sale_tickets/src/repository/listen_tickets_firestore_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TicketListController extends ChangeNotifier {
  final ListenTicketsFirestoreRepository repository;

  List<TicketEntity> tickets = [];
  bool loading = true;
  TicketListController({required this.repository});

  Future<void> listenTickets() async {
    loading = true;
    notifyListeners();

    final QuerySnapshot<Map<String, dynamic>> list =
        await repository.listenTickets();

    tickets = list.docs
        .map((doc) => TicketEntity.fromMap(doc.id, doc.data()))
        .toList();

    loading = false;
    notifyListeners();
  }
}
