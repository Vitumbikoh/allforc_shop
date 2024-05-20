class ShopCylinder {
  int? id;
  String cylinderName;
  double tareMass;
  double gasAmount;
  double totalMass;
  double openingMass;
  String createdAt;

  ShopCylinder({
    this.id,
    required this.cylinderName,
    required this.tareMass,
    required this.gasAmount,
    required this.totalMass,
    required this.openingMass,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cylinder_name': cylinderName,
      'tare_mass': tareMass,
      'gas_amount': gasAmount,
      'total_mass': totalMass,
      'opening_mass': openingMass,
      'created_at': createdAt,
    };
  }

  factory ShopCylinder.fromMap(Map<String, dynamic> map) {
    return ShopCylinder(
      id: map['id'] as int?,
      cylinderName: map['cylinder_name'] as String,
      tareMass: map['tare_mass'] as double? ?? 0.0,
      gasAmount: map['gas_amount'] as double? ?? 0.0,
      totalMass: map['total_mass'] as double? ?? 0.0,
      openingMass: map['opening_mass'] as double? ?? 0.0,
      createdAt: map['created_at'] as String,
    );
  }
}

class CustomerCylinder {
  final int? id;
  final int shopCylinderId;
  final double tareMass;
  final double gasAmount;
  final double totalMass;
  final String createdAt;

  CustomerCylinder({
    this.id,
    required this.shopCylinderId,
    required this.tareMass,
    required this.gasAmount,
    required this.totalMass,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shop_cylinder_id': shopCylinderId,
      'tare_mass': tareMass,
      'gas_amount': gasAmount,
      'total_mass': totalMass,
      'created_at': createdAt,
    };
  }

  factory CustomerCylinder.fromMap(Map<String, dynamic> map) {
    return CustomerCylinder(
      id: map['id'] as int?,
      shopCylinderId: map['shop_cylinder_id'] as int,
      tareMass: map['tare_mass'] as double? ?? 0.0,
      gasAmount: map['gas_amount'] as double? ?? 0.0,
      totalMass: map['total_mass'] as double? ?? 0.0,
      createdAt: map['created_at'] as String,
    );
  }
}
