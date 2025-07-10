import 'dart:ui';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:app_sale_tickets/src/entity/locality_entity.dart';
import 'package:app_sale_tickets/src/entity/ticket_entity.dart';
import 'package:app_sale_tickets/src/utils/pdf_widget_export.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_to_pdf/flutter_to_pdf.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';

class FirestoreRepository {
  final _collection = FirebaseFirestore.instance;
  final ExportDelegate exportDelegate;

  FirestoreRepository(this.exportDelegate);

  Future<String> addSale(TicketEntity sale) async {
    try {
      //validar la silla al guardar
      final snapshot = await _collection
          .collection('seat_sale')
          .where('seat', isEqualTo: sale.seat)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return 'La silla ya no esta disponible';
      } else {
        await _collection.collection('seat_sale').add(sale.toMap());
      }
    } catch (e) {
      return 'Error al guardar la silla';
    }

    try {
      await sendPdfByEmail(sale);
      return 'Silla registrada correctamente';
    } catch (e) {
      return 'Se guardo la silla pero no se pudo enviar el ticket al correo';
    }
  }

  Future<void> sendPdfByEmail(TicketEntity ticket) async {
    // Configura tu servidor SMTP
    final smtpServer = SmtpServer(
      'sandbox.smtp.mailtrap.io', // Ejemplo: smtp.gmail.com
      username: '753f41b64e5e63',
      password: '730a20fd88619e',
      port: 587, // o 465 para SSL
      ignoreBadCertificate: false, // solo si es necesario
    );

    final pdf = await generatePDF(ticket);

    // Crea el mensaje
    final message = Message()
      ..from = Address('eventos@iglesiamt.com', 'Iglesia Mision transformadora')
      ..recipients.add(ticket.email)
      ..subject = 'Compra Exitosa - ${ticket.locality.name} - Jose Ordóñez'
      ..text =
          'Compraste de forma exitosa la entrada al evento de Jose Ordóñez. Yo no pedí nacer. \n Debes presentar el comprobante de compra adjunto el dia del evento, este comprobante es personal e intransferible y se inhabilitará al ser escaneado en la entrada por lo cual sera valido solo para la primera persona en presentarlo.'
      ..attachments = [
        StreamAttachment(
          Stream.fromIterable([pdf]), // pdf es List<int> o Uint8List
          'application/pdf',
          fileName: 'ticket Jose Ordóñez - ${ticket.name}.pdf',
        ),
      ];

    try {
      await send(message, smtpServer);
    } catch (e) {
      throw 'Correo no enviado';
    }
  }

  Future<List<int>> generatePDF(TicketEntity ticket) async {
    //Generate QR
    final Uint8List qrBytes = await generateQrPng();

    //Generate PDF
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return buildTicketPdfWidget(
            name: ticket.name,
            email: ticket.email,
            phone: ticket.phone,
            seat: ticket.seat,
            locality: ticket.locality.name,
            price: ticket.locality.price,
            document: ticket.document,
            leader: ticket.leader,
            dateSale: ticket.dateSale,
            id: ticket.id,
            qrBytes: qrBytes,
          );
        },
      ),
    );

    final savedFile = await pdf.save();
    return List.from(savedFile);
  }

  /*Future<List<TicketEntity>> getSales() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => TicketEntity.fromMap(doc.id, doc.data()))
        .toList();
  }*/

  Future<List<LocalityEntity>> fetchLocalities() async {
    final snapshot = await _collection.collection('locality').get();
    return snapshot.docs
        .map((doc) => LocalityEntity.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<Uint8List> generateQrPng() async {
    // Carga la imagen de marca desde assets
    final ByteData logoData = await rootBundle.load('assets/logo_iglesia.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(
      logoBytes,
      targetWidth: 700,
      targetHeight: 700,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image logoImage = frameInfo.image;

    final qrValidationResult = QrValidator.validate(
      data: 'andersson',
      version: 5,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
    );

    final qrCode = qrValidationResult.qrCode;
    final painter = QrPainter.withQr(
      gapless: true,
      qr: qrCode!,
      embeddedImage: logoImage,
      embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(300, 300)),
    );
    final picData = await painter.toImageData(1080);
    final imgBytes = picData!.buffer.asUint8List();

    return imgBytes;
  }
}
