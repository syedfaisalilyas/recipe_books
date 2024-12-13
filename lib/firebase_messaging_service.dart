import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize Firebase Messaging and Local Notifications
  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Request permission for iOS
    await _firebaseMessaging.requestPermission();

    // Listen for messages while the app is in the foreground
    FirebaseMessaging.onMessage.listen(_onMessageReceived);
  }

  // Handle the foreground message and show local notifications
  Future<void> _onMessageReceived(RemoteMessage message) async {
    if (message.notification != null) {
      await showNotification(
        message.notification!.title ?? 'Notification',
        message.notification!.body ?? 'Message Body',
      );
    }
  }

  // Show a local notification (make it public)
  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'your_channel_id', 'your_channel_name',
      importance: Importance.max, priority: Priority.high,
    );
    const NotificationDetails platformDetails =
    NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformDetails,
      payload: 'Item x',
    );
  }

  // Subscribe to a topic (if needed)
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  // Unsubscribe from a topic (if needed)
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}
