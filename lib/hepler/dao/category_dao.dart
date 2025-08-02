import '../../models/category_model.dart';
import '../sqlite_hepler.dart';

// DAO (Data Access Object)
class CategoryDAO {
  Future<int> insertCategory(CategoryModel category) async {
    final db = await SqliteHepler().database;
    return await db.insert('category', category.toMap());
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final db = await SqliteHepler().database;
    final result = await db.query('category');
    return result.map((e) => CategoryModel.fromMap(e)).toList();
  }

  Future<int> updateCategory(CategoryModel category) async {
    final db = await SqliteHepler().database;
    return await db.update(
      'category',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await SqliteHepler().database;
    return await db.delete('category', where: 'id = ?', whereArgs: [id]);
  }
}
