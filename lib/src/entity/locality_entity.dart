class LocalityEntity {
  final String id;
  final String name;
  final int price;

  LocalityEntity({required this.price, required this.id, required this.name});

  factory LocalityEntity.fromMap(String id, Map<String, dynamic> map) {
    return LocalityEntity(
      id: id,
      name: map['name'] ?? '',
      price: map['price'] ?? 0,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }
}
