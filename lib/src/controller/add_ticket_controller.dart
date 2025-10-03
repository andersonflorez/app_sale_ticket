import 'package:app_sale_tickets/src/entity/locality_entity.dart';
import 'package:app_sale_tickets/src/entity/ticket_entity.dart';
import 'package:app_sale_tickets/src/repository/add_sale_ticket_firestore_repository.dart';
import 'package:flutter/material.dart';

class AddTicketController extends ChangeNotifier {
  final AddSaleTicketFirestoreRepository repository;

  List<LocalityEntity> localities = [];
  List<String> reservedSeats = [];

  bool isLoading = false;

  AddTicketController({required this.repository});

  Future<String> saveTicket(List<TicketEntity> tickets) async {
    if (tickets.isNotEmpty) {
      isLoading = true;
      notifyListeners();
      final result = await repository.addSale(tickets);
      isLoading = false;
      notifyListeners();
      return result;
    } else {
      return 'Por favor, complete todos los campos antes de guardar.';
    }
  }

  Future<void> loadLocalities() async {
    isLoading = true;
    notifyListeners();
    localities = await repository.fetchLocalities();
    isLoading = false;
    notifyListeners();
  }

  Future<String> updateTicketEmail(TicketEntity ticket, String newEmail) async {
    ticket.email = newEmail;
    return await repository.updateTicketEmail(ticket);
  }

  Future<String> downloadTicket(TicketEntity ticket) async {
    return await repository.downloadTicketPdf(ticket);
  }
}
