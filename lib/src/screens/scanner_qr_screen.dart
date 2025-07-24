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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                MobileScanner(
                  onDetect: _onDetect,
                ),
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
              ],
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  scanning = true;
                  message = 'Escanea el QR';
                  status = null;
                });
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: status == ScannerQrResponseStatus.success
                    ? const Color(0xFF81BD58)
                    : status == ScannerQrResponseStatus.error
                        ? const Color(0xFFA55A38)
                        : Colors.white,
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
