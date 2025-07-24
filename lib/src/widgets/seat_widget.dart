import 'package:app_sale_tickets/src/entity/seat_locality_entity.dart';
import 'package:app_sale_tickets/src/entity/ticket_entity.dart';
import 'package:flutter/material.dart';

class SeatWidget extends StatelessWidget {
  const SeatWidget({
    super.key,
    required this.onSeatSelected,
    required this.seat,
    required this.isSelected,
    this.ticketReserved,
  });

  final void Function(SeatLocalityEntity)? onSeatSelected;
  final TicketEntity? ticketReserved;
  final SeatLocalityEntity seat;

  static const double seatSize = 25;
  static const double aisleWidth = 24;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ticketReserved != null || onSeatSelected == null
          ? null
          : () {
              onSeatSelected!(seat);
            },
      child: Container(
        width: seatSize,
        height: seatSize,
        decoration: BoxDecoration(
          color: getColorBackground(
            locality: seat.locality.name,
            isReserved: ticketReserved != null,
            isSelected: isSelected,
            isUsed: ticketReserved?.used ?? false,
          ),
          borderRadius: BorderRadius.circular(3),
          border: isSelected == false ? null : Border.all(width: 2),
        ),
        child: Center(
          child: Text(
            seat.seat,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: getColorText(
                locality: seat.locality.name,
                isReserved: ticketReserved != null,
                isSelected: isSelected,
                isUsed: ticketReserved?.used ?? false,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color getColorBackground({
    required String locality,
    required bool isReserved,
    required bool isSelected,
    required bool isUsed,
  }) {
    if (isSelected) {
      return Colors.red;
    } else if (isReserved && !isUsed) {
      return Colors.black;
    } else if (isReserved && isUsed) {
      return Colors.white;
    } else {
      if (locality == 'VIP') {
        return const Color(0xFFE3E118);
      } else if (locality == 'PLATEA') {
        return const Color(0xFF898E6F);
      } else if (locality == 'GENERAL') {
        return const Color(0xFF80BB58);
      } else if (locality == 'VIDRIERA') {
        return const Color(0xFFEAAC67);
      } else {
        return Colors.red;
      }
    }
  }

  Color getColorText({
    required String locality,
    required bool isReserved,
    required bool isSelected,
    required bool isUsed,
  }) {
    if (isUsed) {
      return Colors.black;
    } else if (locality == 'PLATEA' || isSelected || isReserved) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}
