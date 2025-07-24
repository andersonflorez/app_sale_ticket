class LocalityEntity {
  final String name;
  final int price;

  LocalityEntity({required this.price, required this.name});

  factory LocalityEntity.fromMap(Map<String, dynamic> map) {
    return LocalityEntity(
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
