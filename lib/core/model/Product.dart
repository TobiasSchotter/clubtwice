import 'package:flutter/cupertino.dart';

import 'package:clubtwice/core/model/ProductSize.dart';

class Product {
  List<String> image;
  String name;
  int price;
  double rating;
  String description;

  List<ProductSize> sizes;
  String storeName;

  Product({
    required this.image,
    required this.name,
    required this.price,
    required this.rating,
    required this.description,
    required this.sizes,
    required this.storeName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      return Product(
        image: json['image'],
        name: json['name'],
        price: json['price'],
        rating: json['rating'],
        description: json['description'],
        sizes: (json['sizes'] as List)
            .map((data) => ProductSize.fromJson(data))
            .toList(),
        storeName: json['store_name'],
      );
    } catch (e) {
      // print("couldn't return product");
      rethrow;
    }
  }
}
