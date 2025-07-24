import 'package:app_sale_tickets/src/entity/seat_locality_entity.dart';
import 'package:flutter/material.dart';

class SeatWidget extends StatelessWidget {
  const SeatWidget({
    super.key,
    required this.onSeatSelected,
    required this.seat,
    required this.isSelected,
    this.isReserved = false,
  });

  final void Function(SeatLocalityEntity)? onSeatSelected;
  final bool isReserved;
  final SeatLocalityEntity seat;

  static const double seatSize = 25;
  static const double aisleWidth = 24;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isReserved || onSeatSelected == null
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
            isReserved: isReserved,
            isSelected: isSelected,
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
                isReserved: isReserved,
                isSelected: isSelected,
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
  }) {
    if (isSelected) {
      return Colors.red;
    } else if (isReserved) {
      return Colors.black;
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
  }) {
    if (locality == 'PLATEA' || isSelected || isReserved) {
      return Colors.white;
    }
    return Colors.black;
  }
}
