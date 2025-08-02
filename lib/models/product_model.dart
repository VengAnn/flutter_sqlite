class ProductModel {
  final int? id;
  final String name;
  final double price;
  final int? categoryId;

  // optional extras
  final String? categoryName;
  final List<String>? imageUrls;

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    this.categoryId,
    this.categoryName,
    this.imageUrls,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      price: map['price'] is int
          ? (map['price'] as int).toDouble()
          : map['price'],
      categoryId: map['category_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'price': price, 'category_id': categoryId};
  }

  ProductModel copyWith({
    int? id,
    String? name,
    double? price,
    int? categoryId,
    String? categoryName,
    List<String>? imageUrls,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}
