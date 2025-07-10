import 'package:app_sale_tickets/src/controller/add_ticket_controller.dart';
import 'package:app_sale_tickets/src/entity/locality_entity.dart';
import 'package:app_sale_tickets/src/entity/ticket_entity.dart';
import 'package:app_sale_tickets/src/widgets/adaptive_screens_widget.dart';
import 'package:app_sale_tickets/src/widgets/locality_select_widget.dart';
import 'package:app_sale_tickets/src/widgets/seat_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SeatSaleFormScreen extends StatefulWidget {
  const SeatSaleFormScreen({super.key});

  @override
  State<SeatSaleFormScreen> createState() => _SeatSaleFormScreenState();
}

class _SeatSaleFormScreenState extends State<SeatSaleFormScreen> {
  String name = '';
  String email = '';
  String phone = '';
  String seat = '';
  String leader = '';
  String document = '';
  LocalityEntity? locality;
  int price = 0;

  final uuid = Uuid();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    context.read<AddTicketController>().loadLocalities();
    super.initState();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Ingrese un correo válido';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Correo no válido';
    return null;
  }

  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    if (!RegExp(r'^\d+$').hasMatch(value)) return 'Solo números';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Venta de Asientos')),
      body: Consumer<AddTicketController>(
        builder: (context, addTicketController, child) {
          return addTicketController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AdaptiveScreensWidget(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Datos personales',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Nombre',
                                  ),
                                  onChanged: (value) => name = value,
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? 'Campo requerido'
                                          : null,
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Documento',
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    document = value;
                                  },
                                  validator: _validateNumber,
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  decoration:
                                      const InputDecoration(labelText: 'Email'),
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) {
                                    email = value;
                                  },
                                  validator: _validateEmail,
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Teléfono',
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    phone = value;
                                  },
                                  validator: _validateNumber,
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  decoration:
                                      const InputDecoration(labelText: 'Líder'),
                                  onChanged: (value) => leader = value,
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? 'Campo requerido'
                                          : null,
                                ),
                                const SizedBox(height: 16),
                                const Text('Localidad:'),
                                const SizedBox(height: 8),
                                LocalitySelectWidget(
                                  onLocalitySelected: (value) {
                                    setState(() {
                                      locality = value;
                                    });
                                  },
                                  locality: locality,
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'Selecciona tu asiento',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SeatSelectorWidget(
                              onSeatSelected: (value) {
                                setState(() {
                                  seat = value;
                                });
                              },
                              reservedSeats: addTicketController.reservedSeats,
                            ),
                          ),
                          AdaptiveScreensWidget(
                            child: Column(
                              children: [
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: seat.isNotEmpty &&
                                          _formKey.currentState?.validate() ==
                                              true &&
                                          locality != null
                                      ? () async {
                                          addTicketController.ticket =
                                              TicketEntity(
                                            name: name,
                                            email: email,
                                            phone: phone,
                                            seat: seat,
                                            leader: leader,
                                            document: document,
                                            locality: locality!,
                                            dateSale: DateTime.now(),
                                          );
                                          addTicketController
                                              .saveTicket()
                                              .then((value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(value),
                                              ),
                                            );
                                            setState(() {
                                              name = '';
                                              email = '';
                                              phone = '';
                                              seat = '';
                                              leader = '';
                                              document = '';
                                              locality = null;
                                              seat = '';
                                            });
                                            _formKey.currentState?.reset();
                                          });
                                        }
                                      : null,
                                  child: const Text('Guardar'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
