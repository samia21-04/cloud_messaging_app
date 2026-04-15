import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FCMService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initialize({
    required void Function(RemoteMessage) onData,
  }) async {
    try {
      final NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      debugPrint('Permission status: ${settings.authorizationStatus}');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('onMessage fired');
        debugPrint('Foreground title: ${message.notification?.title}');
        debugPrint('Foreground body: ${message.notification?.body}');
        debugPrint('Foreground data: ${message.data}');
        onData(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('onMessageOpenedApp fired');
        debugPrint('Opened title: ${message.notification?.title}');
        debugPrint('Opened body: ${message.notification?.body}');
        debugPrint('Opened data: ${message.data}');
        onData(message);
      });

      final RemoteMessage? initialMessage = await messaging.getInitialMessage();

      if (initialMessage != null) {
        debugPrint('getInitialMessage fired');
        debugPrint('Initial title: ${initialMessage.notification?.title}');
        debugPrint('Initial body: ${initialMessage.notification?.body}');
        debugPrint('Initial data: ${initialMessage.data}');
        onData(initialMessage);
      }
    } catch (e) {
      debugPrint('FCM initialize error: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      final String? token = await messaging.getToken();
      debugPrint('FCM token: $token');
      return token;
    } catch (e) {
      debugPrint('FCM token error: $e');
      return null;
    }
  }
}