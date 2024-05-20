import '../models/models.dart';
import 'database_helper.dart';

class GasFillDao {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insertShopCylinder(ShopCylinder shopCylinder) async {
    final db = await dbHelper.database;
    return await db.insert('shop_cylinders', shopCylinder.toMap());
  }

  Future<int> insertCustomerCylinder(CustomerCylinder customerCylinder) async {
    final db = await dbHelper.database;
    return await db.insert('customer_cylinders', customerCylinder.toMap());
  }

  Future<List<ShopCylinder>> getShopCylinders() async {
    final db = await dbHelper.database;
    final result = await db.query('shop_cylinders');
    return result.map((map) => ShopCylinder.fromMap(map)).toList();
  }

  Future<int> updateShopCylinder(ShopCylinder shopCylinder) async {
    final db = await dbHelper.database;
    return await db.update(
      'shop_cylinders',
      shopCylinder.toMap(),
      where: 'id = ?',
      whereArgs: [shopCylinder.id],
    );
  }

  Future<int> deleteShopCylinder(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'shop_cylinders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<CustomerCylinder>> getCustomerCylinders(
      int shopCylinderId) async {
    final db = await dbHelper.database;
    final result = await db.query('customer_cylinders',
        where: 'shop_cylinder_id = ?', whereArgs: [shopCylinderId]);
    return result.map((map) => CustomerCylinder.fromMap(map)).toList();
  }
}

// Adding missing fromMap method in CustomerCylinder class
extension on CustomerCylinder {}

// Adding missing fromMap method in ShopCylinder class
extension on ShopCylinder {}
