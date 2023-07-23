class UserModel {
  String club;
  String email;
  String sport;
  String username;
  String firstName;
  String? profileImageUrl;
  List<String>? search;
  List<String>? favorites;

  UserModel({
    required this.club,
    required this.email,
    required this.firstName,
    required this.sport,
    required this.username,
    this.profileImageUrl,
    this.search,
    this.favorites,
  });

  // Factory method to create a user model from a Map (usually from Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      club: map['club'],
      email: map['email'],
      favorites: List<String>.from(map['favorites'] ?? []),
      firstName: map['first Name'],
      profileImageUrl: map['profileImageUrl'],
      search: List<String>.from(map['search'] ?? []),
      sport: map['sport'],
      username: map['username'],
    );
  }

  // Convert the user model to a Map (usually for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'club': club,
      'email': email,
      'favorites': favorites,
      'firstName': firstName,
      'profileImageUrl': profileImageUrl,
      'search': search,
      'sport': sport,
      'username': username,
    };
  }
}
