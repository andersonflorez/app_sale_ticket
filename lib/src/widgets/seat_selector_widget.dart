import 'package:flutter/material.dart';

class SeatSelectorWidget extends StatefulWidget {
  final void Function(String) onSeatSelected;
  final List<String> reservedSeats;
  final List<String> blockedSeats;
  const SeatSelectorWidget({
    required this.onSeatSelected,
    required this.reservedSeats,
    this.blockedSeats = const [
      // Ejemplo de sillas reservadas
      // "1-A-1", "1-A-2", "1-B-3", "2-C-4", etc.
    ],
    super.key,
  });

  @override
  State<SeatSelectorWidget> createState() => _SeatSelectorWidgetState();
}

class _SeatSelectorWidgetState extends State<SeatSelectorWidget> {
  String? selectedSeat;
  @override
  Widget build(BuildContext context) {
    const Map<int, Map> letters = {
      0: {
        'letter': 'Q',
        'totalSeats': 0,
        'space': [],
      },
      1: {
        'letter': 'Z',
        'totalSeats': 7,
        'space': [],
        'emptySeats': [0, 1],
      },
      2: {
        'letter': 'Y',
        'totalSeats': 7,
        'space': [],
        'emptySeats': [0],
      },
      3: {
        'letter': 'X',
        'totalSeats': 7,
        'space': [],
        'emptySeats': [0],
      },
      4: {
        'letter': 'W',
        'totalSeats': 7,
        'space': [],
      },
      5: {
        'letter': 'V',
        'totalSeats': 7,
        'space': [],
      },
      6: {
        'letter': 'U',
        'totalSeats': 7,
        'space': [],
      },
      7: {
        'letter': 'T',
        'totalSeats': 7,
        'space': [],
      },
      8: {
        'letter': 'S',
        'totalSeats': 7,
        'space': [],
        'emptySeats': [5, 6],
      },
      9: {
        'letter': 'R',
        'totalSeats': 51,
        'space': [25],
        'emptySeats': [12, 13],
      },
      10: {
        'letter': 'Q',
        'totalSeats': 48,
        'space': [6, 18, 23, 36],
        'emptySeats': [6, 19],
      },
      11: {
        'letter': 'P',
        'totalSeats': 48,
        'space': [6, 18, 23, 36],
      },
      12: {
        'letter': 'O',
        'totalSeats': 50,
        'space': [5, 16, 23, 31, 40],
        'emptySeats': [
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          32,
          33,
          34,
          35,
          36,
          37,
          38,
          39,
          40,
          41,
          42,
          43,
          44,
          45,
          46,
          47,
          48,
          49,
        ],
      },
      13: {
        'letter': 'N',
        'totalSeats': 50,
        'space': [5, 16, 23, 31, 40],
        'emptySeats': [
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          32,
          33,
          34,
          35,
          36,
          37,
          38,
          39,
          40,
          41,
          42,
          43,
          44,
          45,
          46,
          47,
          48,
          49,
        ],
      },
      14: {
        'letter': 'M',
        'totalSeats': 50,
        'space': [5, 16, 23, 31, 40],
        'emptySeats': [
          0,
          1,
          2,
          3,
          4,
          5,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          41,
          42,
          43,
          44,
          45,
          46,
          47,
          48,
          49,
        ],
      },
      15: {
        'letter': 'L',
        'totalSeats': 50,
        'space': [5, 16, 23, 31, 40],
        'emptySeats': [0, 1, 2, 17, 18, 19, 20, 21, 22, 23],
      },
      16: {
        'letter': 'K',
        'totalSeats': 50,
        'space': [5, 16, 23, 31, 40],
        'emptySeats': [17, 18, 19, 20, 21, 22, 23],
      },
      17: {
        'letter': 'J',
        'totalSeats': 50,
        'space': [
          5,
          16,
          23,
          31,
          40,
        ],
        'emptySeats': [17, 18, 19, 20, 21, 22, 23],
      },
      18: {
        'letter': 'I',
        'totalSeats': 50,
        'space': [5, 16, 23, 31, 40],
      },
      19: {
        'letter': 'H',
        'totalSeats': 50,
        'space': [5, 16, 23, 31, 40],
      },
      20: {
        'letter': 'G',
        'totalSeats': 50,
        'space': [5, 16, 23, 31, 40],
      },
      21: {
        'letter': 'F',
        'totalSeats': 50,
        'space': [5, 16, 23, 31, 40],
      },
      22: {
        'letter': 'E',
        'totalSeats': 50,
        'space': [5, 16, 23, 31, 40],
      },
      23: {
        'letter': 'D',
        'totalSeats': 50,
        'space': [5, 16, 23, 31, 40],
      },
      24: {
        'letter': 'C',
        'totalSeats': 50,
        'space': [5, 16, 23, 31, 40],
      },
      25: {
        'letter': 'B',
        'totalSeats': 50,
        'space': [5, 16, 23, 31, 40],
      },
      26: {
        'letter': 'A',
        'totalSeats': 50,
        'space': [5, 16, 23, 31, 40],
      },
    };
    const List<int> letterSpace = [12, 9];
    const double blockSpacing = 25;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(letters.length, (letterIdx) {
          final letter = letters[letterIdx]!;
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
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: List.generate(letter['totalSeats'], (seatIdx) {
                  final List<Widget> rowsChildren = [];

                  if (letter['emptySeats'] != null &&
                      (letter['emptySeats'] as List).contains(seatIdx)) {
                    rowsChildren.add(
                      const SizedBox(
                        width: blockSpacing,
                        height: blockSpacing,
                      ),
                    );
                    if ((letter['space'] as List).contains(seatIdx)) {
                      rowsChildren.add(
                        const SizedBox(
                          width: blockSpacing,
                          height: 1,
                        ),
                      );
                    }
                  } else {
                    final seatId = '$letterString${seatIdx + 1}';
                    rowsChildren.add(
                      SeatWidget(
                        onSeatSelected: (value) {
                          setState(() {
                            selectedSeat = value;
                          });
                          widget.onSeatSelected(value);
                        },
                        seatId: seatId,
                        isSelected: selectedSeat == seatId,
                      ),
                    );
                    if ((letter['space'] as List).contains(seatIdx)) {
                      rowsChildren.add(
                        const SizedBox(
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
        }
            /*     return Padding(
            padding: EdgeInsets.only(
              right: blockIdx < blocks - 1 ? blockSpacing : 0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Bloque $blockNumber',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Column(
                  children: List.generate(rowsPerBlock, (rowIdx) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(colsPerBlock, (colIdx) {
                        final seatId = '$blockNumber-$rowLetter-${colIdx + 1}';
                        final isReserved = reservedSeats.contains(seatId);
                        final isSelected = seatId == selectedSeat;
                        return Padding(
                          padding: EdgeInsets.only(
                            left: colIdx == 5
                                ? aisleWidth
                                : 2, // Pasillo central después de la columna 5
                            right: 2,
                            top: rowIdx == 4
                                ? aisleWidth / 2
                                : 2, // Pasillo horizontal después de la fila 4
                            bottom: 2,
                          ),
                          child: GestureDetector(
                            onTap: isReserved
                                ? null
                                : () => onSeatSelected(seatId),
                            child: Container(
                              width: seatSize,
                              height: seatSize,
                              decoration: BoxDecoration(
                                color: isReserved
                                    ? Colors.red[300]
                                    : isSelected
                                        ? Colors.green
                                        : Colors.grey[300],
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.green[900]!
                                      : isReserved
                                          ? Colors.red
                                          : Colors.black,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  '${rowLetter}${colIdx + 1}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isReserved
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ],
            ),
          );*/
            ),
      ),
    );
  }
}

class SeatWidget extends StatelessWidget {
  const SeatWidget({
    super.key,
    required this.onSeatSelected,
    required this.seatId,
    required this.isSelected,
  });

  final void Function(String p1) onSeatSelected;
  final bool isReserved = false;
  final String seatId;

  final double seatSize = 25;
  final double aisleWidth = 24;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isReserved
          ? null
          : () {
              onSeatSelected(seatId);
            },
      child: Container(
        width: seatSize,
        height: seatSize,
        decoration: BoxDecoration(
          color: isReserved
              ? Colors.red[300]
              : isSelected
                  ? Colors.green
                  : Colors.grey[300],
          border: Border.all(
            color: isSelected
                ? Colors.green[900]!
                : isReserved
                    ? Colors.red
                    : Colors.black,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            seatId,
            style: TextStyle(
              fontSize: 10,
              color: isReserved ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
