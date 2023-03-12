class Message {
  final bool isRead;
  final String shopName;
  final String message;
  final String shopLogoUrl;

  Message({
    this.isRead = false,
    this.shopLogoUrl = "",
    this.message = "",
    this.shopName = "",
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      isRead: json['is_read'],
      shopLogoUrl: json['shop_logo_url'],
      message: json['message'],
      shopName: json['shop_name'],
    );
  }
}
