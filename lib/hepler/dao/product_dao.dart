import 'package:flutter/material.dart';

import '../../models/product_model.dart';
import '../sqlite_hepler.dart';

// DAO (Data Access Object)
class ProductDAO {
  Future<int> insertProduct(ProductModel product) async {
    final db = await SqliteHepler.database;
    return await db.insert('product', product.toMap());
  }

  Future<void> insertSampleData() async {
    final db = await SqliteHepler.database;
    // await SqliteHepler().resetDatabase();

    // Insert category
    final categoryId = await db.insert('category', {'name': 'Electronics'});

    // List of products with one image each
    final products = [
      {
        'name': 'Smartphone',
        'price': 299.99,
        'image_url':
            'https://static.vecteezy.com/system/resources/thumbnails/028/794/706/small_2x/cartoon-cute-school-boy-photo.jpg',
      },
      {
        'name': 'Laptop',
        'price': 899.99,
        'image_url':
            'https://cdn.pixabay.com/photo/2024/03/19/15/23/boy-8643450_1280.png',
      },
      {
        'name': 'Tablet',
        'price': 499.99,
        'image_url':
            'https://cdn.prod.website-files.com/6600e1eab90de089c2d9c9cd/669726ee8cafdb308dac9389_image_6528c515_1720809290218_1024.jpeg',
      },
    ];

    for (var product in products) {
      // Insert product with categoryId
      final productId = await db.insert('product', {
        'name': product['name'],
        'price': product['price'],
        'category_id': categoryId,
      });

      // Insert one image for the product
      await db.insert('product_image', {
        'product_id': productId,
        'image_url': product['image_url'],
      });
    }

    debugPrint('Inserted 3 products, each with one image and category.');
  }

  // get all products with related category and images
  Future<List<ProductModel>> getAllProductsWithDetails() async {
    final db = await SqliteHepler.database;

    final result = await db.rawQuery('''
    SELECT p.*, c.name AS category_name
    FROM product p
    LEFT JOIN category c ON p.category_id = c.id
    ORDER BY p.id
  ''');

    List<ProductModel> products = [];

    for (var row in result) {
      final productId = row['id'] as int;

      // ✅ Get only 1 image for this product (first one found)
      final imageRow = await db.query(
        'product_image',
        where: 'product_id = ?',
        whereArgs: [productId],
        limit: 1,
      );

      String? imageUrl;
      int? imageId;

      if (imageRow.isNotEmpty) {
        imageUrl = imageRow.first['image_url'] as String;
        imageId = imageRow.first['id'] as int;
      }

      final product = ProductModel.fromMap(row).copyWith(
        imgUrl: imageUrl,
        idImg: imageId,
        categoryName: row['category_name'] as String?,
      );

      products.add(product);
    }

    return products;
  }

  Future<List<ProductModel>> getAllProducts() async {
    final db = await SqliteHepler.database;
    final result = await db.query('product');

    return result.map((e) => ProductModel.fromMap(e)).toList();
  }

  Future<ProductModel?> getProductById(int id) async {
    final db = await SqliteHepler.database;
    final result = await db.query('product', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) return ProductModel.fromMap(result.first);
    return null;
  }

  Future<int> updateProduct(ProductModel product) async {
    final db = await SqliteHepler.database;
    return await db.update(
      'product',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await SqliteHepler.database;
    return await db.delete('product', where: 'id = ?', whereArgs: [id]);
  }
}
