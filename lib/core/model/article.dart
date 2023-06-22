import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  List<String> images;
  String brand;
  String club;
  String condition;
  String title;
  String description;
  String size;
  String sport;
  String type;
  String userId;
  bool isSold;
  bool isDeleted;
  int price;
  Timestamp updatedAt;
  Timestamp createdAt;
  bool isIndividuallyWearable;

  Article(
      {required this.images,
      required this.brand,
      required this.club,
      required this.condition,
      required this.title,
      required this.description,
      required this.size,
      required this.sport,
      required this.type,
      required this.userId,
      required this.isSold,
      required this.isDeleted,
      required this.price,
      required this.updatedAt,
      required this.createdAt,
      required this.isIndividuallyWearable});

  factory Article.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    try {
      return Article(
          images: List<String>.from(data['images']),
          brand: data['brand'],
          club: data['club'],
          condition: data['condition'],
          title: data['title'],
          description: data['description'],
          size: data['size'],
          sport: data['sport'],
          type: data['type'],
          userId: data['userId'],
          isSold: data['isSold'],
          isDeleted: data['isDeleted'],
          price: data['price'],
          updatedAt: data['updatedAt'],
          createdAt: data['createdAt'],
          isIndividuallyWearable: data['isIndividuallyWearable']);
    } catch (e) {
      print("couldn't return product");
      rethrow;
    }
  }
}
