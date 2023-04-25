class Product {
  List<String> image;
  String name;
  int price;

  String description;

  Product({
    required this.image,
    required this.name,
    required this.price,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      return Product(
        image: json['image'],
        name: json['name'],
        price: json['price'],
        description: json['description'],
      );
    } catch (e) {
      // print("couldn't return product");
      rethrow;
    }
  }
}
