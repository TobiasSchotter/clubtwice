class Message {
  final String senderId;
  final String receiverID;
  final String message;
  final DateTime timestamp;
  final String articleId;
  final String receiverUsername;
  final String profileImageUrl;

  Message(
      {required this.senderId,
      required this.receiverID,
      required this.message,
      required this.timestamp,
      required this.articleId,
      required this.receiverUsername,
      required this.profileImageUrl});

  factory Message.fromJson(Map<String, dynamic> json, String articleId) {
    return Message(
        senderId: json['senderId'],
        receiverID: json['receiverID'],
        message: json['message'],
        timestamp: DateTime.parse(json['timestamp']),
        articleId: articleId,
        receiverUsername: json['receiverUsername'],
        profileImageUrl: json['profileImageUrl']);
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'articleId': articleId,
      'receiverUsername': receiverUsername,
      'profileImageUrl': profileImageUrl
    };
  }
}
