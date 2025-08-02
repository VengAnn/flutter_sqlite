import '../../models/product_image_model.dart';
import '../sqlite_hepler.dart';

// DAO (Data Access Object)
class ProductImageDAO {
  Future<int> insertImage(ProductImageModel image) async {
    final db = await SqliteHepler().database;
    return await db.insert('product_image', image.toMap());
  }

  Future<List<ProductImageModel>> getImagesByProductId(int productId) async {
    final db = await SqliteHepler().database;
    final result = await db.query(
      'product_image',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
    return result.map((e) => ProductImageModel.fromMap(e)).toList();
  }

  Future<int> deleteImage(int id) async {
    final db = await SqliteHepler().database;
    return await db.delete('product_image', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteImagesByProductId(int productId) async {
    final db = await SqliteHepler().database;
    return await db.delete(
      'product_image',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }
}
