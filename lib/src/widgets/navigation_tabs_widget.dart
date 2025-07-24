import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          ElevatedButton(
            onPressed: () {
              GoRouter.of(context).push('/reports');
            },
            child: const Text('Reportes'),
          ),
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
