import 'package:app_sale_tickets/src/controller/scanner_qr_controller.dart';
import 'package:app_sale_tickets/src/entity/scanner_qr_response_entity.dart';
import 'package:app_sale_tickets/src/entity/ticket_entity.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class ScannerQrScreen extends StatefulWidget {
  const ScannerQrScreen({super.key});

  @override
  State<ScannerQrScreen> createState() => _ScannerQrScreenState();
}

class _ScannerQrScreenState extends State<ScannerQrScreen> {
  bool scanning = true;
  String message = 'Escanea el QR';
  ScannerQrResponseStatus? status;

  TicketEntity? ticketEntity;

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (!scanning) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    final code = barcode.rawValue!;
    setState(() {
      scanning = false;
      message = 'Consultando el QR';
    });
    await Future.delayed(const Duration(milliseconds: 500));

    final scannerController = context.read<ScannerQrController>();
    ticketEntity = await scannerController.scannerQr(code);
    setState(() {
      message = 'Consultando el QR: ${ticketEntity?.id}';
    });

    final response = await scannerController.markTicketUsed(ticketEntity);

    setState(() {
      message = response.message;
      status = response.status;
    });

    _showResultModal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR')),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _onDetect,
          ),
          if (scanning)
            Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: scanning == true
                        ? const Color(0xFFE7DE00)
                        : status == ScannerQrResponseStatus.success
                            ? const Color(0xFF81BD58)
                            : status == ScannerQrResponseStatus.error
                                ? const Color(0xFFA55A38)
                                : const Color(0xFFE7DE00),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          if (!scanning && status == null)
            Center(
              child: Container(
                width: 300,
                height: 150,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      'Consultando QR, espere un momento',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showResultModal() {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (ticketEntity != null)
                Text(
                  'Ticket: ${ticketEntity!.id}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              if (ticketEntity != null)
                Text(
                  'Nombre: ${ticketEntity!.name}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              if (ticketEntity != null)
                Text(
                  'Documento: ${ticketEntity!.document}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              if (ticketEntity != null)
                Text(
                  'Fecha de venta: ${ticketEntity!.dateSale}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              if (ticketEntity != null)
                if (ticketEntity!.dateUsed != null)
                  Text(
                    'Hora de Uso: ${ticketEntity!.dateUsed?.hour}:${ticketEntity!.dateUsed?.minute}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
              if (ticketEntity != null)
                Text(
                  'Localidad: ${ticketEntity!.locality.name}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              if (ticketEntity != null)
                Text(
                  'Silla: ${ticketEntity!.seat}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: status == ScannerQrResponseStatus.success
                      ? const Color(0xFF81BD58)
                      : status == ScannerQrResponseStatus.error
                          ? const Color(0xFFA55A38)
                          : Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    scanning = true;
                    message = 'Escanea el QR';
                    status = null;
                  });
                },
                child: const Text(
                  'Volver a escanear',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }
}
