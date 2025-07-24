import 'package:app_sale_tickets/src/controller/add_ticket_controller.dart';
import 'package:app_sale_tickets/src/entity/seat_locality_entity.dart';
import 'package:app_sale_tickets/src/entity/ticket_entity.dart';
import 'package:app_sale_tickets/src/widgets/adaptive_screens_widget.dart';
import 'package:app_sale_tickets/src/widgets/navigation_tabs_widget.dart';
import 'package:app_sale_tickets/src/widgets/seat_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SeatSaleFormScreen extends StatefulWidget {
  const SeatSaleFormScreen({super.key});

  @override
  State<SeatSaleFormScreen> createState() => _SeatSaleFormScreenState();
}

class _SeatSaleFormScreenState extends State<SeatSaleFormScreen> {
  String name = '';
  String email = '';
  String phone = '';
  List<SeatLocalityEntity> seats = [];
  String document = '';
  int price = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddTicketController>().loadLocalities();
    });
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
      appBar: AppBar(
        title: const Text('Registro de Venta de Asientos'),
      ),
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
                                const NavigationTabsWidget(),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Divider(),
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
                                  onChanged: (value) => setState(() {
                                    name = value;
                                  }),
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
                                    setState(() {
                                      document = value;
                                    });
                                  },
                                  validator: _validateNumber,
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  decoration:
                                      const InputDecoration(labelText: 'Email'),
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) {
                                    setState(() {
                                      email = value;
                                    });
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
                                    setState(() {
                                      phone = value;
                                    });
                                  },
                                  validator: _validateNumber,
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
                                  seats = value;
                                });
                              },
                              localitiesPrice: context
                                  .read<AddTicketController>()
                                  .localities,
                            ),
                          ),
                          AdaptiveScreensWidget(
                            child: Column(
                              children: [
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: seats.isNotEmpty &&
                                          _formKey.currentState?.validate() ==
                                              true
                                      ? () {
                                          final List<TicketEntity> tickets = [];
                                          double total = 0;
                                          seats.forEach((seat) {
                                            total += seat.locality.price;
                                            tickets.add(
                                              TicketEntity(
                                                name: name,
                                                email: email,
                                                phone: phone,
                                                seat: seat.seat,
                                                document: document,
                                                locality: seat.locality,
                                                dateSale: DateTime.now(),
                                              ),
                                            );
                                          });

                                          showDialog(
                                            context: context,
                                            barrierDismissible:
                                                false, // evita cerrar tocando fuera del cuadro
                                            builder: (BuildContext context) {
                                              final formatMoney =
                                                  NumberFormat(
                                                      '#,##0', 'es_CO');
                                              return AlertDialog(
                                                title: const Text(
                                                    'Confirmar Reserva'),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                        'Sillas seleccionadas:'),
                                                    Wrap(
                                                      spacing: 8.0,
                                                      runSpacing: 8.0,
                                                      children: seats
                                                          .map((seat) => Chip(
                                                              label: Text(
                                                                  seat.seat)))
                                                          .toList(),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Text(
                                                        'Total donación: \$${formatMoney.format(total)}',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child:
                                                        const Text('Cancelar'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  ElevatedButton(
                                                    child:
                                                        const Text('Continuar'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();

                                                      addTicketController
                                                          .saveTicket(tickets)
                                                          .then((value) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content:
                                                                Text(value),
                                                          ),
                                                        );
                                                        setState(() {
                                                          name = '';
                                                          email = '';
                                                          phone = '';
                                                          document = '';
                                                          seats = [];
                                                        });
                                                        _formKey.currentState
                                                            ?.reset();
                                                      });
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
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
