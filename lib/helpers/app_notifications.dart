// import 'dart:math';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import '../main.dart';
// import '../models/notifications_model.dart';
//
// class AppNotifications {
//   static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   static void initialize() {
//     // Initialize notification settings
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: AndroidInitializationSettings("@mipmap/ic_launcher"),
//       iOS: DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//       ),
//     );
//
//     _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         print("Notification clicked with payload: ${response.payload}");
//         // Handle notification interaction
//       },
//     );
//
//     // Listen for foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("Foreground message received: ${message.notification?.title}");
//       display(message);
//     });
//   }
//
//   static void display(RemoteMessage message) async {
//     try {
//       final id = Random().nextInt(999);
//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: AndroidNotificationDetails(
//           "recipebook",
//           "recipe_book",
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//         iOS: DarwinNotificationDetails(
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       );
//
//       print("Displaying notification: ${message.notification?.title}");
//
//       // Show the notification
//       await _flutterLocalNotificationsPlugin.show(
//         id,
//         message.notification?.title ?? "No Title",
//         message.notification?.body ?? "No Description",
//         notificationDetails,
//       );
//     } catch (e) {
//       print("Error displaying notification: $e");
//     }
//   }
// }
//
// Future<void> backgroundMessageHandle(RemoteMessage message) async {
//   print("Background message received: ${message.notification?.title}");
//   if (message.notification?.title != null && message.notification!.title!.isNotEmpty) {
//     AppNotifications.display(message);
//   }
// }
