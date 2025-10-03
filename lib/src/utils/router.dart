import 'package:app_sale_tickets/src/screens/login_screen.dart';
import 'package:app_sale_tickets/src/screens/map_tickets_seat_screen.dart';
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

    // Obtener el parámetro onlyScanner desde el environment o donde lo estés definiendo
    const onlyScanner = bool.fromEnvironment('onlyScanner');

    if (user == null && !loggingIn && !isMap) {
      return '/login';
    }

    if (user != null) {
      if (loggingIn) {
        // Si onlyScanner es true, redirige a scannerQr, sino a la ruta por defecto
        return onlyScanner ? '/scannerQr' : '/';
      }

      // Si onlyScanner es true y no está en scannerQr, redirige a scannerQr
      if (onlyScanner && state.matchedLocation != '/scannerQr') {
        return '/scannerQr';
      }
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
      path: '/scannerQr',
      builder: (context, state) => const ScannerQrScreen(),
    ),
  ],
);
