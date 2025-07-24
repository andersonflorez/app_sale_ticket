import 'package:app_sale_tickets/src/entity/locality_entity.dart';

class TicketEntity {
  String id;
  final String name;
  String email;
  final String phone;
  final String document;
  DateTime dateSale;
  final LocalityEntity locality;
  final String seat;
  final bool used;
  final DateTime? dateUsed;

  TicketEntity({
    this.id = '',
    required this.name,
    required this.email,
    required this.phone,
    required this.seat,
    required this.document,
    required this.locality,
    required this.dateSale,
    this.used = false,
    this.dateUsed,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'document': document,
        'dateSale': dateSale.toIso8601String(),
        'locality': locality.toMap(),
        'seat': seat,
        'used': used,
        'dateUsed': dateUsed?.toIso8601String(),
      };

  factory TicketEntity.fromMap(String id, Map<String, dynamic> map) =>
      TicketEntity(
        id: id,
        name: map['name'],
        email: map['email'],
        phone: map['phone'],
        document: map['document'],
        dateSale: DateTime.parse(map['dateSale']),
        locality: LocalityEntity.fromMap(
          map['locality'],
        ),
        seat: map['seat'],
        used: map['used'] ?? false,
        dateUsed:
            map['dateUsed'] == null ? null : DateTime.parse(map['dateUsed']),
      );
}
