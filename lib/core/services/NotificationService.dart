import 'package:clubtwice/core/model/Notification.dart';

class NotificationService {
  static List<UserNotification> listNotification = notificationListRawData
      .map((data) => UserNotification.fromJson(data))
      .toList();
}

var notificationListRawData = [
  {
    'image_url': 'assets/images/logo.png',
    'title': 'Neue Funktion',
    'date_time': '${DateTime.now()}',
    'description': 'Ab sofort kannst du mehrere Benachrichtungen hinterlegen',
  },
  {
    'image_url': 'assets/images/logo.png',
    'title': 'Neue Artikel aus deinem Verein',
    'date_time': '${DateTime.now()}',
    'description': 'Es wurden neue Artikel aus deinem Verein hochgeladen',
  },
  {
    'image_url': 'assets/images/logo.png',
    'title': 'Neues Kidsprdoukt aus deinem Verein',
    'date_time': '${DateTime.now()}',
    'description':
        'Es wurde ein neues Kidsprodukt aus deinem Verein hochgeladen',
  },
];
