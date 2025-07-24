import 'package:app_sale_tickets/src/entity/ticket_entity.dart';
import 'package:app_sale_tickets/src/repository/reports_repository.dart';
import 'package:flutter/material.dart';

class ReportsController extends ChangeNotifier {
  final ReportsRepository repository;
  List<TicketEntity> tickets = [];
  bool loading = false;

  ReportsController({required this.repository});

  Future<void> fetchTickets(DateTimeRange range) async {
    loading = true;
    notifyListeners();
    //await Future.delayed(const Duration(seconds: 5));
    tickets = await repository.getTicketsByDateRange(range.start, range.end);
    loading = false;
    notifyListeners();
  }
}
