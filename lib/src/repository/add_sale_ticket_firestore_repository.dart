import 'dart:convert';
import 'dart:ui' as ui;
import 'package:app_sale_tickets/src/entity/locality_entity.dart';
import 'package:app_sale_tickets/src/entity/ticket_entity.dart';
import 'package:app_sale_tickets/src/utils/pdf_widget_export.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';

class AddSaleTicketFirestoreRepository {
  final _collection = FirebaseFirestore.instance;

  AddSaleTicketFirestoreRepository();

  Future<String> addSale(List<TicketEntity> tickets) async {
    final List<String> seatNotAvailable = [];
    bool reservedAllSeat = true;
    final List<TicketEntity> ticketsReserved = [];

    try {
      for (final ticket in tickets) {
        //validar la silla al guardar
        final snapshot = await _collection
            .collection('seat_sale')
            .where('seat', isEqualTo: ticket.seat)
            .get();
        if (snapshot.docs.isNotEmpty) {
          seatNotAvailable.add(ticket.seat);
          reservedAllSeat = false;
        } else {
          final result =
              await _collection.collection('seat_sale').add(ticket.toMap());
          ticket.id = result.id;
          ticketsReserved.add(ticket);
        }
      }
    } catch (e) {
      return 'Error al guardar la silla';
    }

    try {
      await sendPdfByEmail(ticketsReserved);
      if (reservedAllSeat) {
        return 'Se ha realizado la reserva y se ha enviado el correo';
      } else {
        return 'Error al reservar todas las sillas, sillas no disponibles: ${seatNotAvailable.join(' - ')}, con el resto de las sillas se envió el correo electrónico';
      }
    } catch (e) {
      if (reservedAllSeat) {
        return 'Se guardo la silla pero no se pudo enviar el ticket al correo';
      } else {
        return 'No se pudieron reservar todas las sillas, sillas no disponibles: ${seatNotAvailable.join(' - ')}, tampoco pudo ser enviado el ticket al correo';
      }
    }
  }

  Future<String> updateTicketEmail(TicketEntity ticket) async {
    try {
      await _collection
          .collection('seat_sale')
          .doc(ticket.id)
          .update({'email': ticket.email});
    } catch (e) {
      return 'Error al cambiar el correo';
    }

    try {
      await sendPdfByEmail([ticket]);
      return 'Ticket enviado al correo correctamente';
    } catch (e) {
      return 'Se cambio el correo pero no se pudo enviar el ticket';
    }
  }

  Future<void> sendPdfByEmail(List<TicketEntity> tickets) async {
    try {
      final pdf = await generatePDF(tickets);
      //downloadFileFromUint8List(pdf, 'Ticket.pdf');
      await sendMail(
          email: tickets.first.email,
          pdfBytes: pdf,
          fileName: 'Ticket José Ordóñez - ${tickets.first.name}.pdf');
    } catch (e) {
      throw 'Correo no enviado';
    }
  }

  /*void downloadFileFromUint8List(Uint8List data, String filename) {
    final blob = html.Blob([data], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final html.AnchorElement anchorElement = html.AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();
  }*/

  Future<void> sendMail({
    required String email,
    required List<int> pdfBytes,
    required String fileName,
  }) async {
    final dio = Dio();
    const url =
        'https://cerulean-yeot-4cf73a.netlify.app/.netlify/functions/sendEmail';

    try {
      final pdfBase64 = base64Encode(pdfBytes);

      final data = {
        'email': email,
        'filename': fileName,
        'pdfBase64': pdfBase64,
      };

      final response = await dio.post(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode != 200) {
        throw 'correo no enviado';
      }
    } catch (e) {
      throw 'correo no enviado';
    }
  }

  Future<Uint8List> generatePDF(List<TicketEntity> tickets) async {
    final pdf = pw.Document();
    final fontRegular = pw.Font.ttf(await rootBundle
        .load('assets/fonts/SpaceGrotesk/SpaceGrotesk-Regular.ttf')
        .then((d) => d.buffer.asByteData()));
    final fontBold = pw.Font.ttf(await rootBundle
        .load('assets/fonts/SpaceGrotesk/SpaceGrotesk-Bold.ttf')
        .then((d) => d.buffer.asByteData()));

    final theme = pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
    );

    final ByteData data = await rootBundle.load('assets/banner.jpg');
    final Uint8List bannerBytes = data.buffer.asUint8List();
    for (final ticket in tickets) {
      //Generate QR
      final Uint8List qrBytes = await generateQrPng(ticket);

      pdf.addPage(
        pw.Page(
          theme: theme,
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
              dateSale: ticket.dateSale,
              id: ticket.id,
              qrBytes: qrBytes,
              bannerBytes: bannerBytes,
            );
          },
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        theme: theme,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return buildTermsAndCondition();
        },
      ),
    );

    final savedFile = await pdf.save();
    //return List.from(savedFile);
    return savedFile;
  }

  Future<List<LocalityEntity>> fetchLocalities() async {
    final snapshot =
        await _collection.collection('locality').orderBy('order').get();
    return snapshot.docs
        .map((doc) => LocalityEntity.fromMap(doc.data()))
        .toList();
  }

  Future<Uint8List> generateQrPng(TicketEntity ticket) async {
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
    /* final data = json.encode(ticket.toMapSingle());

    final dataCompress = await compress(
      data,
    );*/

    final qrValidationResult = QrValidator.validate(
      data: ticket.id,
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
