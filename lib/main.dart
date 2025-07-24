import 'package:app_sale_tickets/firebase_options.dart';
import 'package:app_sale_tickets/src/controller/add_ticket_controller.dart';
import 'package:app_sale_tickets/src/controller/reports_controller.dart';
import 'package:app_sale_tickets/src/controller/scanner_qr_controller.dart';
import 'package:app_sale_tickets/src/controller/ticket_list_controller.dart';
import 'package:app_sale_tickets/src/repository/add_sale_ticket_firestore_repository.dart';
import 'package:app_sale_tickets/src/repository/listen_tickets_firestore_repository.dart';
import 'package:app_sale_tickets/src/repository/reports_repository.dart';
import 'package:app_sale_tickets/src/repository/scanner_qr_repository.dart';
import 'package:app_sale_tickets/src/utils/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AddTicketController(
            repository: AddSaleTicketFirestoreRepository(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => TicketListController(
            repository: ListenTicketsFirestoreRepository(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ScannerQrController(
            repository: ScannerQrRepository(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ReportsController(
            repository: ReportsRepository(),
          ),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        title: 'Iglesia Misión Trasformadora',
        theme: ThemeData(primarySwatch: Colors.blue),
      ),
    );
  }
}
