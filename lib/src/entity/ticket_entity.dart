import 'package:app_sale_tickets/src/entity/locality_entity.dart';

class TicketEntity {
  String id;
  final String name;
  final String email;
  final String phone;
  final String leader;
  final String document;
  DateTime dateSale;
  final LocalityEntity locality;

  final String seat;

  TicketEntity({
    this.id = '',
    required this.name,
    required this.email,
    required this.phone,
    required this.seat,
    required this.leader,
    required this.document,
    required this.locality,
    required this.dateSale,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'phone': phone,
        'leader': leader,
        'document': document,
        'dateSale': dateSale.toIso8601String(),
        'locality': locality.toMap(),
        'seat': seat,
      };

  factory TicketEntity.fromMap(String id, Map<String, dynamic> map) =>
      TicketEntity(
        id: id,
        name: map['name'],
        email: map['email'],
        phone: map['phone'],
        leader: map['leader'],
        document: map['document'],
        dateSale: DateTime.parse(map['dateSale']),
        locality: LocalityEntity.fromMap(
            (map['locality'] as Map)['id'], map['locality']),
        seat: map['seat'],
      );
}
