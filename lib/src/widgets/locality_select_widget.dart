import 'package:app_sale_tickets/src/controller/add_ticket_controller.dart';
import 'package:app_sale_tickets/src/entity/locality_entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocalitySelectWidget extends StatelessWidget {
  const LocalitySelectWidget({
    super.key,
    required this.onLocalitySelected,
    required this.locality,
  });

  final void Function(LocalityEntity) onLocalitySelected;
  final LocalityEntity? locality;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AddTicketController>();

    if (controller.isLoading) {
      return const CircularProgressIndicator();
    }

    return DropdownButton<LocalityEntity>(
      hint: const Text('Selecciona una localidad'),
      value: locality,
      items: controller.localities
          .map(
            (loc) => DropdownMenuItem(
              value: loc,
              child: Text(loc.name),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          onLocalitySelected(value);
        }
      },
      isExpanded: true,
    );
  }
}
