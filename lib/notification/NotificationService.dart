import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void initializeNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings("product");

    var initializationSettingsIos = new IOSInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIos);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    print('NOTIFICATION INITIALIZED');
  }

  Future showNotification(String payload) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        '1', 'products_channel',
        importance: Importance.high, priority: Priority.max);

    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      1,
      'Alert!',
      payload,
      platformChannelSpecifics,
    );
  }
}
