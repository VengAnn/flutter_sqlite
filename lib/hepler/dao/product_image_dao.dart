import 'package:sqflite/sqflite.dart';

import '../../models/product_image_model.dart';
import '../sqlite_hepler.dart';

// DAO (Data Access Object)
class ProductImageDAO {
  Future<Database> get _db async => await SqliteHepler.database;

  Future<int> insertImage(ProductImageModel image) async {
    final db = await _db;
    return await db.insert('product_image', image.toMap());
  }

  Future<List<ProductImageModel>> getImagesByProductId(int productId) async {
    final db = await _db;
    final result = await db.query(
      'product_image',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
    return result.map((e) => ProductImageModel.fromMap(e)).toList();
  }

  Future<int> deleteImage(int id) async {
    final db = await _db;
    return await db.delete('product_image', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateImage(ProductImageModel image) async {
    if (image.id == null) throw Exception('Image id is required for update');

    final db = await _db;
    final updateMap = {
      'product_id': image.productId,
      'image_url': image.imageUrl,
    };
    return await db.update(
      'product_image',
      updateMap,
      where: 'id = ?',
      whereArgs: [image.id],
    );
  }

  Future<int> deleteImagesByProductId(int productId) async {
    final db = await _db;
    return await db.delete(
      'product_image',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }
}
