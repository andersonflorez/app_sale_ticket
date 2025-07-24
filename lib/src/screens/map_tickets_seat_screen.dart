import 'package:app_sale_tickets/src/widgets/seat_selector_widget.dart';
import 'package:flutter/material.dart';

class MapTicketsSeatScreen extends StatelessWidget {
  const MapTicketsSeatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ubicaciones')),
      body: const SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: SeatSelectorWidget()),
        )),
      ),
    );
  }
}
