import 'dart:io';
import 'dart:typed_data';

import 'package:app_sale_tickets/src/entity/ticket_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ExportRepository {
  final _collection = FirebaseFirestore.instance.collection('seat_sale');

  Future<List<TicketEntity>> getAllTickets() async {
    final query = await _collection.get();

    return query.docs
        .map((doc) => TicketEntity.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> exportToExcel(List<TicketEntity> tickets) async {
    if (!kIsWeb && Platform.isAndroid) {
      await Permission.storage.request();
    }

    final excel = Excel.createExcel();
    final sheet = excel['Reporte'];

    // Estilo para la cabecera
    final headerStyle = CellStyle(
      bold: true,
      fontFamily: getFontFamily(FontFamily.Calibri),
      backgroundColorHex: ExcelColor.fromHexString('#E0E0E0'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    // Encabezados
    final headers = [
      TextCellValue('ID'),
      TextCellValue('Nombre'),
      TextCellValue('Email'),
      TextCellValue('Teléfono'),
      TextCellValue('Documento'),
      TextCellValue('Fecha Venta'),
      TextCellValue('Hora Venta'),
      TextCellValue('Localidad'),
      TextCellValue('Precio'),
      TextCellValue('Silla'),
      TextCellValue('Usado'),
      TextCellValue('Fecha Uso'),
    ];

    sheet.appendRow(headers);

    // Aplicar estilo a encabezados
    for (var i = 0; i < headers.length; i++) {
      final cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.cellStyle = headerStyle;
    }

    // Agregar los datos
    for (int r = 0; r < tickets.length; r++) {
      final item = tickets[r];
      final row = [
        TextCellValue(item.id),
        TextCellValue(item.name),
        TextCellValue(item.email),
        TextCellValue(item.phone),
        TextCellValue(item.document),
        DateCellValue.fromDateTime(item.dateSale),
        TimeCellValue.fromTimeOfDateTime(item.dateSale),
        TextCellValue(item.locality.name),
        IntCellValue(item.locality.price),
        TextCellValue(item.seat),
        BoolCellValue(item.used),
        if (item.dateUsed == null)
          TextCellValue('')
        else
          TimeCellValue.fromTimeOfDateTime(item.dateUsed!),
      ];

      sheet.appendRow(row);
    }

    final bytes = excel.encode();
    if (bytes == null) return;

    const name = 'reporte';

    if (kIsWeb) {
      await FileSaver.instance.saveFile(
        name: name,
        bytes: Uint8List.fromList(bytes),
        fileExtension: 'xlsx',
        mimeType: MimeType.microsoftExcel,
      );
    } else {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/$name';
      final file = File(filePath)..writeAsBytesSync(bytes);

      await FileSaver.instance.saveFile(
        name: name,
        file: file,
        fileExtension: 'xlsx',
        mimeType: MimeType.microsoftExcel,
      );
    }
  }
}
