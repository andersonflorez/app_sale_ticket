import 'package:app_sale_tickets/src/entity/ticket_entity.dart';
import 'package:app_sale_tickets/src/repository/listen_tickets_firestore_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TicketListController extends ChangeNotifier {
  final ListenTicketsFirestoreRepository repository;

  List<TicketEntity> tickets = [];

  bool listening = false;

  TicketListController({required this.repository});

  Future<void> listenTickets() async {
    if (listening == false) {
      repository
          .listenTickets()
          .listen((QuerySnapshot<Map<String, dynamic>> list) {
        listening = true;
        tickets = list.docs
            .map((doc) => TicketEntity.fromMap(doc.id, doc.data()))
            .toList();

        notifyListeners();
      });
    }
  }
}
