import 'package:app_sale_tickets/firebase_options.dart';
import 'package:app_sale_tickets/src/controller/add_ticket_controller.dart';
import 'package:app_sale_tickets/src/repository/firestore_repository.dart';
import 'package:app_sale_tickets/src/screens/seat_sale_form_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_to_pdf/flutter_to_pdf.dart';
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
            repository: FirestoreRepository(
              ExportDelegate(),
            ),
          ),
        ),
      ],
      child: const MaterialApp(home: SeatSaleFormScreen()),
    );
  }
}
