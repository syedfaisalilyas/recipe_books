import 'package:firebase_messaging/firebase_messaging.dart';
import 'app_notifications.dart';

class NotificationService {
  static final _fcm = FirebaseMessaging.instance;
  static String? fcmToken;

  ///Initializing Notification services that includes FLN, ANDROID NOTIFICATION CHANNEL setting
  ///FCM NOTIFICATION SETTINGS, and also listeners for OnMessage and for onMessageOpenedApp

  static initConfigure() async {
    print("+++++++++++++++++++++++++++++++");
    print("init configuration started");
    print("+++++++++++++++++++++++++++++++");

    /// Giver message when open in background but terminated
    /// when user tap on Message it open the from terminated state
    _fcm.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        AppNotifications.display(message);
      }
    });

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    ///First instantiating the setting
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    ///Token Initializing
    await _fcm.getToken().then((token) {
      print("FCM Token is ====>>>> $token");
      fcmToken = token;
    });

    ///now initializing the listeners
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("+++++++++++++++++++++++++++++++");
      print("onMessage Listener Called");
      print("+++++++++++++++++++++++++++++++");
      print("message is ====>>>> $message");
      AppNotifications.display(message);
      print("+++++++++++++++++++++++++++++++");
      print("onMessageOpenedApp Listener Closed");
      print("+++++++++++++++++++++++++++++++");
    });

    /// When app is in background but app should  be open not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("+++++++++++++++++++++++++++++++");
      print("onMessageOpenedApp Listener Called");
      print("+++++++++++++++++++++++++++++++");
      AppNotifications.display(message);
      print("+++++++++++++++++++++++++++++++");
      print("onMessageOpenedApp Listener Closed");
      print("+++++++++++++++++++++++++++++++");
    });
  }

  static initToken() async {
    await _fcm.getToken().then((token) {
      print("FCM Token is ====>>>> $token");
      fcmToken = token;
    });
  }


}
