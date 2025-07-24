import 'dart:typed_data';

import 'package:intl/intl.dart';
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
  required Uint8List qrBytes,
  required DateTime dateSale,
  required Uint8List bannerBytes,
}) {
  final formatMoney = NumberFormat('#,##0', 'es_CO');
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Center(
        child: pw.Container(
          width: 595,
          height: 150,
          child: pw.Center(
            child: pw.Image(
              pw.MemoryImage(bannerBytes),
              fit: pw.BoxFit.cover,
            ),
          ),
        ),
      ),
      pw.SizedBox(height: 10),
      pw.Text(
        'NO HAGAS COPIA DE TU ENTRADA Y NO LA ENVÍES A OTRA PERSONA, UNA VEZ EL CÓDIGO PASE POR NUESTROS LECTORES, SERÁ INHABILITADO PARA NUEVOS INGRESOS.',
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
                  'JOSÉ ORDÓÑEZ',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'Yo no pedí nacer Parte 2',
                  style: pw.TextStyle(
                    fontSize: 15,
                    fontWeight: pw.FontWeight.normal,
                    letterSpacing: 0.6,
                    wordSpacing: 0.6,
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
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    letterSpacing: 0.6,
                  ),
                ),
                pw.Text(
                  'Localidad: $locality',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    letterSpacing: 0.6,
                    wordSpacing: 0.6,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Iglesia Misión Transformadora\nCalle 44 # 80 - 16',
                  style: const pw.TextStyle(fontSize: 15),
                ),
                pw.SizedBox(height: 20),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Donación: \$${formatMoney.format(price)}',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
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
      pw.SizedBox(height: 10),
      pw.Text(
        'ORGANIZA: IGLESIA MISIÓN TRANSFORMADORA',
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 15),
      pw.Text(
        '1. La edad mínima de ingreso al evento es 10 años.',
      ),
      pw.Text(
        '2. No está permitido el ingreso de mascotas al evento.',
      ),
      pw.Text(
        '3. Presenta tu boleta legible (física o digital). Recuerda que es personal e intransferible.',
      ),
      pw.Text(
        '4.	La primera boleta que se valide anula copias. No compartas tu PDF ni QR.',
      ),
      pw.Text(
        '5.	Dirígete a la ubicación seleccionada al momento de realizar la donación. El personal de Logística y Seguridad te direccionará hacia tu ubicación.',
      ),
      pw.Text(
        '6.	NO ES PERMITIDO GRABAR NI TOMAR REGISTRO FOTOGRÁFICO DURANTE EL EVENTO.',
      ),
      pw.Text(
        '7.	El personal de Logística y Seguridad puede negar el ingreso o solicitar tu retiro si no cumples las reglas del evento, sin lugar a a reembolso.',
      ),
      pw.Text(
        '8.	Lee los Términos y Condiciones que se encuentra junto con la boleta.',
      ),
      pw.Text(
        '9.	Si tienes alguna duda o inquietud puedes escribir a presidencia@iglesiamt.com',
      ),
      pw.Text(
        '10. No está permitido el ingreso de bebidas y alimentos.',
      ),
      pw.Text(
        '11. No se permite el ingreso de bebidas alcohólicas ni de sustancias psicoactivas.',
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
        pw.Padding(
          padding: const pw.EdgeInsets.all(10),
          child: qrCodePdfWidgetFromPng(qrBytes),
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

List<pw.Widget> buildTermsAndCondition() {
  return [
    pw.Center(
      child: pw.Text(
        'Términos y Condiciones',
        style: pw.TextStyle(
          fontSize: 20,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    ),
    pw.SizedBox(height: 15),
    pw.Text(
      '1. ¿Quiénes somos?',
      style: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
      ),
      textAlign: pw.TextAlign.start,
    ),
    pw.SizedBox(height: 8),
    pw.Text(
      'Somos Iglesia Misión Transformadora, una entidad sin ánimo de lucro, que busca conectar a la comunidad con la palabra de Dios y llevar el mensaje de Jesús a los hogares, y para ello, en busca del crecimiento y mejoramiento continuo, pone a disposición de la comunidad, eventos de edificación para todos los miembros de la familia, en ejecución de los fines de la Iglesia y como medio para la recaudación de fondos para perseguir tales fines.',
      textAlign: pw.TextAlign.justify,
    ),
    pw.SizedBox(height: 15),
    pw.Text(
      '2. ¿Qué es una donación?',
      style: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
      ),
      textAlign: pw.TextAlign.start,
    ),
    pw.SizedBox(height: 8),
    pw.Text(
      'Es cuando una persona natural o jurídica decide entregar parte de sus bienes a la Iglesia, de manera gratuita y sin posibilidad de revocarla. La Iglesia acepta esta entrega de manera formal.\n\nLa donación queda firme cuando sea entregada en la taquilla y recibes un correo con tu boleta.\n\nNota: La donación es gratuita, voluntaria e irrevocable, por lo tanto, no se permiten devoluciones ni reprogramaciones de eventos.',
      textAlign: pw.TextAlign.justify,
    ),
    pw.SizedBox(height: 15),
    pw.Text(
      '3. ¿Quién es el donante?',
      style: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
      ),
      textAlign: pw.TextAlign.start,
    ),
    pw.SizedBox(height: 8),
    pw.Text(
      'Es cualquier persona natural o jurídica, de derecho privado, ya sea colombiana o extranjera, que: (i) Tiene capacidad legal para donar; (ii) Tiene el interés voluntario de entregar parte de sus bienes a la Iglesia, sin esperar pago o contraprestación, y (iii) Lo hace de forma irrevocable.',
      textAlign: pw.TextAlign.justify,
    ),
    pw.SizedBox(height: 15),
    pw.Text(
      '4. ¿Qué es el "Formulario de Donación"?',
      style: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
      ),
      textAlign: pw.TextAlign.start,
    ),
    pw.SizedBox(height: 8),
    pw.Text(
      'Es el formulario con los datos que el donante debe proporcionar en la taquilla de la Iglesia con el fin de acceder al evento. Allí proporciona sus datos personales y manifiesta su intención de donar. Los datos del donante serán tratados de conformidad con la Ley 1581 de 2012, y demás normas que lo reglamenten o adicionen, para recibir información del evento al que desea asistir, y futuros eventos que la Iglesia lleve a cabo, el donante podrá ejercer sus derechos sobre el tratamiento, uso, circulación, recolección, almacenamiento y supresión de sus datos en todo momento y para ello, podrá escribir al correo juridica@iglesiamt.com\n\nNota legal: Según la ley colombiana, este formulario constituye una oferta de donación.',
      textAlign: pw.TextAlign.justify,
    ),
    pw.SizedBox(height: 15),
    pw.Text(
      '5. ¿Cuáles son los deberes del Donante?',
      style: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
      ),
      textAlign: pw.TextAlign.start,
    ),
    pw.SizedBox(height: 8),
    pw.Text(
      'Al realizar una donación, el donante declara que:\n\n- Tiene capacidad legal para donar.\n- Es titular del medio de pago utilizado.\n- El dinero donado proviene de actividades lícitas, conforme a la ley colombiana.\n- La donación no afecta negativamente su patrimonio, ni compromete su sustento ni el de su familia.\n- Hará un uso honesto y responsable de la página de donaciones.\n\nImportante: La Iglesia no se hace responsable por información falsa o incorrecta suministrada por el donante, ni por información financiera incorrecta ingresada por el donante.',
      textAlign: pw.TextAlign.justify,
    ),
    pw.SizedBox(height: 15),
    pw.Text(
      '6. ¿Qué obtienes con la donación?',
      style: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
      ),
      textAlign: pw.TextAlign.start,
    ),
    pw.SizedBox(height: 8),
    pw.Text(
      'Quienes donen podrán participar en el evento especial organizado por la Iglesia Misión Transformadora, siempre que:\n\n- Diligencien los formularios de inscripción.\n- Se respete el aforo máximo del auditorio.\n\n¿Inconvenientes con la inscripción? Escríbenos a: presidencia@iglesiamt.com',
      textAlign: pw.TextAlign.justify,
    ),
    pw.SizedBox(height: 15),
    pw.Text(
      '7. ¿Cómo realizo la donación para asistir al evento?',
      style: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
      ),
      textAlign: pw.TextAlign.start,
    ),
    pw.SizedBox(height: 8),
    pw.Text(
      'El único lugar destinado para la donación es la taquilla del teatro IMT\n\n- Diligencia el formulario. Incluye tus datos personales, valor, concepto, medio de pago y si requieres certificado.\n- Lee y acepta los términos y condiciones.\n- Autoriza el tratamiento de tus datos personales, para los fines anteriormente mencionados.\n- Realiza la donación.',
      textAlign: pw.TextAlign.justify,
    ),
    pw.SizedBox(height: 15),
    pw.Text(
      '8. Propiedad intelectual.',
      style: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
      ),
      textAlign: pw.TextAlign.start,
    ),
    pw.SizedBox(height: 8),
    pw.Text(
      'Todo el contenido del evento:\n\n- Logotipos, imágenes, textos, marcas y gráficos\n\n- Software, bases de datos, material multimedia\n\nEstá protegido por normas nacionales e internacionales sobre derechos de autor y propiedad industrial (Convenio de Berna, OMPI, Decisiones Andinas, Ley 23 de 1982, entre otras).\n\nPara reclamaciones sobre propiedad intelectual: juridica@iglesiamt.com\nUna vez verificado el reclamo, se retirará el contenido en disputa.',
      textAlign: pw.TextAlign.justify,
    ),
    pw.SizedBox(height: 15),
    pw.Text(
      '9. Resolución de conflictos.',
      style: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
      ),
      textAlign: pw.TextAlign.start,
    ),
    pw.SizedBox(height: 8),
    pw.Text(
      'Cualquier diferencia se resolverá según la ley colombiana.\n\n- Presenta tus reclamaciones al correo: juridica@iglesiamt.com\n- Primero intentaremos resolver cualquier diferencia directamente contigo, de no ser posible, procederemos con los mecanismos alternativos para la resolución de conflictos de conformidad con la Ley.\n\nAtenderemos tus PQRs en máximo 15 días hábiles.',
      textAlign: pw.TextAlign.justify,
    ),
    pw.SizedBox(height: 15),
    pw.Text(
      '10. Cambios, reprogramación o cancelación.',
      style: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
      ),
      textAlign: pw.TextAlign.start,
    ),
    pw.SizedBox(height: 8),
    pw.Text(
      'Si se cancela el evento antes de empezar, te devolveremos el valor de la donación.\n\nSi se reprograma, podrás usar tu boleta en la nueva fecha o pedir devolución dentro del plazo que publiquemos.\n\nFuerza mayor (clima, orden público, pandemia) puede causar suspensión; en esos casos no hay lugar al reembolso.',
      textAlign: pw.TextAlign.justify,
    ),
    pw.SizedBox(height: 15),
    pw.Text(
      '11. Uso de la boleta y acceso al evento.',
      style: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
      ),
      textAlign: pw.TextAlign.start,
    ),
    pw.SizedBox(height: 8),
    pw.Text(
      '- Presenta tu boleta legible (física o digital) y tu documento de identidad.\n- El personal de seguridad puede negar el ingreso si no cumples las reglas del evento.\n- Guarda tu boleta: la primera que se valide anula copias. No compartas tu PDF ni QR.\n\nNo se permite comercializar la boleta. Si la donación original se revierte, la boleta transferida se anula.',
      textAlign: pw.TextAlign.justify,
    ),
    pw.SizedBox(height: 15),
    pw.Text(
      '12. Aceptación de los términos y condiciones.',
      style: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
      ),
      textAlign: pw.TextAlign.start,
    ),
    pw.SizedBox(height: 8),
    pw.Text(
      'Al realizar una donación, el donante declara que:\n\n- Ha leído y comprendido estos términos y condiciones.\n- Acepta todas las cláusulas aquí previstas.',
      textAlign: pw.TextAlign.justify,
    ),
    pw.SizedBox(height: 15),
    pw.Text(
      '¡Disfruta tu evento!',
      style: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
      ),
      textAlign: pw.TextAlign.start,
    ),
  ];
}
