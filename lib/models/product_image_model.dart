class ProductImageModel {
  final int? id;
  final int productId;
  final String imageUrl;

  ProductImageModel({this.id, required this.productId, required this.imageUrl});

  factory ProductImageModel.fromMap(Map<String, dynamic> map) {
    return ProductImageModel(
      id: map['id'],
      productId: map['product_id'],
      imageUrl: map['image_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'product_id': productId, 'image_url': imageUrl};
  }
}
