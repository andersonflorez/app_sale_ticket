import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget buildTicketPdfWidget({
  required String id,
  required String name,
  required String email,
  required String phone,
  required String seat,
  required String locality,
  required int price,
  required String document,
  required String leader,
  required Uint8List qrBytes,
  required DateTime dateSale,
}) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Container(
        width: double.infinity,
        height: 150,
        child: pw.Center(
          child: pw.Placeholder(),
        ),
      ),
      pw.SizedBox(height: 10),
      pw.Text(
        'NO HAGAS COPIAS DE ESTA ENTRADA, SOLAMENTE EL PRIMERO EN PASAR POR NUESTROS LECTORES TENDRÁ ACCESO AL EVENTO',
        style: const pw.TextStyle(fontSize: 9),
      ),
      pw.SizedBox(height: 10),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'JOSE ORDÓÑEZ',
                  style: pw.TextStyle(
                    fontSize: 25,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'Yo no pedí nacer',
                  style: pw.TextStyle(
                    fontSize: 25,
                    fontWeight: pw.FontWeight.normal,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    // Reemplaza por tus widgets de fecha y hora en pdf
                    dateEventPdfWidget(),
                    pw.Text(
                      'Ingreso - 6:00 PM\nEvento - 7:00 PM',
                      style: const pw.TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Silla: $seat',
                  style: pw.TextStyle(
                    fontSize: 15,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Localidad: $locality',
                  style: const pw.TextStyle(fontSize: 15),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Iglesia Misión Transformadora\nCalle 44 # 80 - 16',
                  style: const pw.TextStyle(fontSize: 15),
                ),
                pw.SizedBox(height: 20),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Valor de la entrada:',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  '\$ $price',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'EDAD MINIMA DE INGRESO: 10 AÑOS',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.Text(
                  'ORGANIZA: IGLESIA MISIÓN TRANSFORMADORA',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Debes presentar el comprobante de compra adjunto el dia del evento, este comprobante es personal e intransferible y se inhabilitará al ser escaneado en la entrada por lo cual sera valido solo para la primera persona en presentarlo.',
                ),
              ],
            ),
          ),
          pw.SizedBox(width: 30),
          // Aquí puedes agregar tu widget QR o información adicional en PDF
          containerQrInformationPdf(
            name: name,
            document: document,
            code: id,
            date: dateSale,
            qrBytes: qrBytes,
          ),
        ],
      ),
    ],
  );
}

pw.Widget qrCodePdfWidgetFromPng(Uint8List bytes) {
  final image = pw.MemoryImage(bytes);
  return pw.Image(image);
}

pw.Widget containerQrInformationPdf({
  required String name,
  required String document,
  required String code,
  required DateTime date,
  required Uint8List qrBytes,
}) {
  return pw.Container(
    width: 210,
    decoration: pw.BoxDecoration(
      border: pw.Border.all(),
    ),
    child: pw.Column(
      children: [
        pw.Column(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10),
              child: qrCodePdfWidgetFromPng(qrBytes),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              name,
              style: const pw.TextStyle(fontSize: 15),
            ),
            pw.Text(
              document,
              style: const pw.TextStyle(fontSize: 15),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          width: double.infinity,
          decoration: pw.BoxDecoration(
            color: PdfColors.grey300,
            border: pw.Border.all(),
          ),
          child: pw.Column(
            children: [
              pw.Text(code),
              pw.Text(date.toIso8601String()),
            ],
          ),
        ),
      ],
    ),
  );
}

pw.Widget dateEventPdfWidget() {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        'Viernes',
        style: pw.TextStyle(
          fontSize: 15,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      pw.Text(
        '17/10/2025',
        style: const pw.TextStyle(
          fontSize: 15,
        ),
      ),
    ],
  );
}
