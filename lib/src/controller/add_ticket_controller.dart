import 'package:app_sale_tickets/src/entity/locality_entity.dart';
import 'package:app_sale_tickets/src/entity/ticket_entity.dart';
import 'package:app_sale_tickets/src/repository/firestore_repository.dart';
import 'package:flutter/material.dart';

class AddTicketController extends ChangeNotifier {
  final FirestoreRepository repository;

  TicketEntity? ticket;

  List<LocalityEntity> localities = [];
  List<String> reservedSeats = [];

  bool isLoading = false;

  AddTicketController({required this.repository});

  Future<String> saveTicket() async {
    if (ticket != null) {
      isLoading = true;
      notifyListeners();
      final result = await repository.addSale(ticket!);
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
}
