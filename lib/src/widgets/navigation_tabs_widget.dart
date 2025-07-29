import 'package:app_sale_tickets/src/controller/export_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NavigationTabsWidget extends StatelessWidget {
  const NavigationTabsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              GoRouter.of(context).push('/ticketList');
            },
            child: const Text('Ver Tickets Vendidos'),
          ),
          if (!kIsWeb)
            const SizedBox(
              width: 5,
            ),
          if (!kIsWeb)
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push('/scannerQr');
              },
              child: const Text('Escanear Ticket'),
            ),
          const SizedBox(
            width: 5,
          ),
          ElevatedButton(
            onPressed: () {
              GoRouter.of(context).push('/ticketMap');
            },
            child: const Text('Ver Mapa de tickets'),
          ),
          const SizedBox(
            width: 5,
          ),
          Consumer<ExportController>(builder: (context, controller, child) {
            if (controller.loading) {
              return const CircularProgressIndicator();
            } else {
              return ElevatedButton(
                onPressed: () {
                  controller.exportTickets();
                },
                child: const Text('Exportar'),
              );
            }
          }),
          const SizedBox(
            width: 5,
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              GoRouter.of(context).go('/login');
            },
            child: const Text('Cerrar sesión'),
          )
        ],
      ),
    );
  }
}
