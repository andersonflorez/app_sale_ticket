import 'package:app_sale_tickets/src/screens/login_screen.dart';
import 'package:app_sale_tickets/src/screens/map_tickets_seat_screen.dart';
import 'package:app_sale_tickets/src/screens/reports_screen.dart';
import 'package:app_sale_tickets/src/screens/scanner_qr_screen.dart';
import 'package:app_sale_tickets/src/screens/seat_sale_form_screen.dart';
import 'package:app_sale_tickets/src/screens/ticket_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final loggingIn = state.matchedLocation == '/login';
    final isMap = state.matchedLocation == '/ticketMap';

    if (user == null && !loggingIn && !isMap) {
      return '/login';
    }

    if (user != null && loggingIn) {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const SeatSaleFormScreen(),
    ),
    GoRoute(
      path: '/ticketList',
      builder: (context, state) => const TicketListScreen(),
    ),
    GoRoute(
      path: '/ticketMap',
      builder: (context, state) => const MapTicketsSeatScreen(),
    ),
    GoRoute(
      path: '/reports',
      builder: (context, state) => const ReportsScreen(),
    ),
    GoRoute(
      path: '/scannerQr',
      builder: (context, state) => const ScannerQrScreen(),
    ),
  ],
);
