import 'package:app_sale_tickets/src/controller/ticket_list_controller.dart';
import 'package:app_sale_tickets/src/entity/locality_entity.dart';
import 'package:app_sale_tickets/src/entity/seat_locality_entity.dart';
import 'package:app_sale_tickets/src/utils/utils.dart';
import 'package:app_sale_tickets/src/widgets/seat_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeatSelectorWidget extends StatefulWidget {
  final void Function(List<SeatLocalityEntity>)? onSeatSelected;
  final List<LocalityEntity>? localitiesPrice;
  const SeatSelectorWidget({
    this.onSeatSelected,
    this.localitiesPrice,
    super.key,
  });

  @override
  State<SeatSelectorWidget> createState() => _SeatSelectorWidgetState();
}

class _SeatSelectorWidgetState extends State<SeatSelectorWidget> {
  List<SeatLocalityEntity> selectedSeat = [];

  @override
  void initState() {
    context.read<TicketListController>().listenTickets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const List<int> letterSpace = [10];
    const double blockSpacing = 25;
    const double padding = 1;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Consumer<TicketListController>(
        builder: (context, controller, child) {
          if (controller.listening == false) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(lettersSeats.length, (letterIdx) {
              final letter = lettersSeats[letterIdx]!;
              final letterString = letter['letter'] as String;
              final List<Widget> columnChildren = [];
              if (letterSpace.contains(letterIdx)) {
                columnChildren.add(
                  const SizedBox(
                    height: blockSpacing,
                    width: 1,
                  ),
                ); // Espacio para el pasillo
              }
              columnChildren.add(
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: padding),
                  child: Row(
                    children: List.generate(letter['totalSeats'], (seatIdx) {
                      final List<Widget> rowsChildren = [];

                      if (letter['emptySeats'] != null &&
                          (letter['emptySeats'] as List).contains(seatIdx)) {
                        rowsChildren.add(
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: padding),
                            width: blockSpacing,
                            height: blockSpacing,
                          ),
                        );
                        if ((letter['space'] as List).contains(seatIdx)) {
                          rowsChildren.add(
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: padding,
                              ),
                              width: blockSpacing,
                              height: 1,
                            ),
                          );
                        }
                      } else {
                        final seatId = '$letterString${seatIdx + 1}';
                        late final LocalityEntity locality;
                        if (widget.localitiesPrice == null) {
                          locality = LocalityEntity(
                              price: 0,
                              name: (letter['locality'] as Map)[seatIdx]);
                        } else {
                          locality = widget.localitiesPrice!.firstWhere(
                            (locality) =>
                                locality.name.toLowerCase() ==
                                ((letter['locality'] as Map)[seatIdx] as String)
                                    .toLowerCase(),
                            orElse: () => LocalityEntity(
                                price: 0,
                                name: (letter['locality'] as Map)[seatIdx]),
                          );
                        }

                        final seatLocality = SeatLocalityEntity(
                          seat: seatId,
                          locality: locality,
                        );
                        final indexTicketReserved = controller.tickets
                            .indexWhere((ticket) => ticket.seat == seatId);
                        rowsChildren.add(
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: padding),
                            child: SeatWidget(
                                onSeatSelected: widget.onSeatSelected == null
                                    ? null
                                    : (value) {
                                        setState(() {
                                          if (selectedSeat.indexWhere(
                                                  (selected) =>
                                                      selected.seat ==
                                                      seatLocality.seat) !=
                                              -1) {
                                            selectedSeat.removeWhere(
                                                (selected) =>
                                                    selected.seat ==
                                                    seatLocality.seat);
                                          } else {
                                            selectedSeat.add(value);
                                          }
                                        });
                                        widget.onSeatSelected!(selectedSeat);
                                      },
                                seat: seatLocality,
                                isSelected: selectedSeat.indexWhere(
                                        (selected) =>
                                            selected.seat ==
                                            seatLocality.seat) !=
                                    -1,
                                ticketReserved: indexTicketReserved == -1
                                    ? null
                                    : controller.tickets[indexTicketReserved]),
                          ),
                        );
                        if ((letter['space'] as List).contains(seatIdx)) {
                          rowsChildren.add(
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: padding,
                              ),
                              width: blockSpacing,
                              height: 1,
                            ),
                          );
                        }
                      }

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: rowsChildren,
                      );
                    }),
                  ),
                ),
              );
              return Column(
                children: columnChildren,
              );
            }),
          );
        },
      ),
    );
  }
}
