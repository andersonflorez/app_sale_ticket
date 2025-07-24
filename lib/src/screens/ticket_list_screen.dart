import 'package:app_sale_tickets/src/controller/add_ticket_controller.dart';
import 'package:app_sale_tickets/src/controller/ticket_list_controller.dart';
import 'package:app_sale_tickets/src/entity/ticket_entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Importa tu método para enviar el PDF por email
//import 'package:app_sale_tickets/src/utils/send_pdf_email.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  String nameFilter = '';
  String emailFilter = '';
  String documentFilter = '';
  String seatFilter = '';

  Future<void> _confirmAndSendEmail(
    BuildContext context,
    TicketEntity ticket,
  ) async {
    final controller = TextEditingController(text: ticket.email);
    String? errorText;
    bool loading = false;

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Confirmar correo'),
              content: SizedBox(
                height: 70,
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Correo destinatario',
                          errorText: errorText,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_) {
                          if (errorText != null) {
                            setState(() => errorText = null);
                          }
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      errorText = null; // Reset error text
                      loading = true; // Show loading indicator
                    });
                    final value = controller.text;
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (value.isEmpty || !emailRegex.hasMatch(value)) {
                      setState(() {
                        errorText = 'Correo no válido';
                        loading = false;
                      });
                      return;
                    }
                    final response = await context
                        .read<AddTicketController>()
                        .updateTicketEmail(ticket, value);
                    Navigator.of(context).pop(response);
                  },
                  child: const Text('Enviar'),
                ),
              ],
            );
          },
        );
      },
    );
    if (result != null && result.isNotEmpty) {
      // await sendTicketPdfByEmail(ticket.copyWith(email: result));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
    }
  }

  @override
  void initState() {
    context.read<TicketListController>().listenTickets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tickets Vendidos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SizedBox(
                  width: getWidthFilters(),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por nombre',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => setState(() => nameFilter = value),
                  ),
                ),
                SizedBox(
                  width: getWidthFilters(),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por correo',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => setState(() => emailFilter = value),
                  ),
                ),
                SizedBox(
                  width: getWidthFilters(),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por documento',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) =>
                        setState(() => documentFilter = value),
                  ),
                ),
                SizedBox(
                  width: getWidthFilters(),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por silla',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => setState(() => seatFilter = value),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TicketListController>(
              builder: (context, controller, child) {
                final List<TicketEntity> filteredTickets =
                    controller.tickets.where((ticket) {
                  final matchesName = nameFilter.isEmpty ||
                      ticket.name
                          .toLowerCase()
                          .contains(nameFilter.toLowerCase());
                  final matchesEmail = emailFilter.isEmpty ||
                      ticket.email
                          .toLowerCase()
                          .contains(emailFilter.toLowerCase());
                  final matchesDocument = documentFilter.isEmpty ||
                      ticket.document
                          .toLowerCase()
                          .contains(documentFilter.toLowerCase());
                  final matchesSeat = seatFilter.isEmpty ||
                      ticket.seat
                          .toLowerCase()
                          .contains(seatFilter.toLowerCase());
                  return matchesName &&
                      matchesEmail &&
                      matchesDocument &&
                      matchesSeat;
                }).toList();

                if (controller.listening == false) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.tickets.isEmpty) {
                  return const Center(child: Text('No hay tickets vendidos'));
                }
                if (filteredTickets.isEmpty) {
                  return const Center(
                    child: Text('No hay resultados para los filtros aplicados'),
                  );
                }
                return ListView.builder(
                  itemCount: filteredTickets.length,
                  itemBuilder: (context, index) {
                    final ticket = filteredTickets[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: ListTile(
                        title: Text(ticket.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText('ID: ${ticket.id}'),
                            Text('Correo: ${ticket.email}'),
                            Text('Documento: ${ticket.document}'),
                            Text('Silla: ${ticket.seat}'),
                            Text('Localidad: ${ticket.locality.name}'),
                            Text('Donación: ${ticket.locality.price}'),
                          ],
                        ),
                        leading: ticket.used == false
                            ? IconButton(
                                icon: const Icon(Icons.email),
                                tooltip: 'Reenviar ticket por correo',
                                onPressed: () =>
                                    _confirmAndSendEmail(context, ticket),
                              )
                            : Container(
                                padding: const EdgeInsets.all(7),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF81BD58),
                                ),
                                child: const Icon(Icons.check),
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double getWidthFilters() {
    //return MediaQuery.of(context).size.width < 600 ? double.infinity : 200;
    return 200;
  }
}
