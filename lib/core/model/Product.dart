import 'package:clubtwice/core/model/ProductSize.dart';

class Product {
  List<String> image;
  String name;
  int price;

  String description;

  List<ProductSize> sizes;

  Product({
    required this.image,
    required this.name,
    required this.price,
    required this.description,
    required this.sizes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      return Product(
        image: json['image'],
        name: json['name'],
        price: json['price'],
        description: json['description'],
        sizes: (json['sizes'] as List)
            .map((data) => ProductSize.fromJson(data))
            .toList(),
      );
    } catch (e) {
      // print("couldn't return product");
      rethrow;
    }
  }
}
