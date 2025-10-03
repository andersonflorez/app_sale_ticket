import 'package:app_sale_tickets/src/entity/scanner_qr_response_entity.dart';
import 'package:app_sale_tickets/src/entity/ticket_entity.dart';
import 'package:app_sale_tickets/src/repository/scanner_qr_repository.dart';
import 'package:flutter/material.dart';

class ScannerQrController extends ChangeNotifier {
  final ScannerQrRepository repository;

  ScannerQrController({required this.repository});

  Future<TicketEntity?> scannerQr(String ticketId) async {
    try {
      return await repository.getTicketByCode(ticketId);
    } catch (e) {
      return null;
    }
  }

  Future<ScannerQrResponseEntity> markTicketUsed(TicketEntity? ticket) async {
    if (ticket == null || ticket.id.isEmpty) {
      return ScannerQrResponseEntity(
        message: 'QR no encontrado, inténtalo de nuevo\nNO PERMITIR INGRESO',
        status: ScannerQrResponseStatus.error,
      );
    }

    if (ticket.used == true) {
      return ScannerQrResponseEntity(
        message: 'Código usado anteriormente\nNO PERMITIR INGRESO',
        status: ScannerQrResponseStatus.error,
      );
    }

    try {
      await repository.markTicketAsUsed(ticket.id);
      return ScannerQrResponseEntity(
        message: 'Código correcto\nPERMITIR INGRESO',
        status: ScannerQrResponseStatus.success,
      );
    } catch (e) {
      return ScannerQrResponseEntity(
        message: 'Error inesperado, inténtalo de nuevo\nNO PERMITIR INGRESO',
        status: ScannerQrResponseStatus.error,
      );
    }
  }
}
