import 'package:app_sale_tickets/src/entity/ticket_entity.dart';
import 'package:app_sale_tickets/src/repository/export_repository.dart';
import 'package:flutter/material.dart';

class ExportController extends ChangeNotifier {
  final ExportRepository repository;
  List<TicketEntity> tickets = [];
  bool loading = false;

  ExportController({required this.repository});

  Future<void> exportTickets() async {
    loading = true;
    notifyListeners();
    tickets = await repository.getAllTickets();
    await repository.exportToExcel(tickets);

    loading = false;
    notifyListeners();
  }
}
