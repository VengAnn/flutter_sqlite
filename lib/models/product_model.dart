class ProductModel {
  final int? id;
  final String name;
  final double price;
  final int? categoryId;

  // optional extras
  final String? categoryName;
  final String? imgUrl;
  final int? idImg;

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    this.categoryId,
    this.categoryName,
    this.imgUrl,
    this.idImg,
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
    String? imgUrl,
    int? idImg,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      imgUrl: imgUrl ?? this.imgUrl,
      idImg: idImg ?? this.idImg,
    );
  }
}
