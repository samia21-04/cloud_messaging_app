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

      debugPrint(
        'Permission status: ${settings.authorizationStatus}',
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied ||
          settings.authorizationStatus == AuthorizationStatus.notDetermined) {
        debugPrint('Notification permission was not granted.');
        return;
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        onData(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        onData(message);
      });

      final RemoteMessage? initialMessage =
          await messaging.getInitialMessage();

      if (initialMessage != null) {
        onData(initialMessage);
      }
    } catch (e) {
      debugPrint('FCM initialize error: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      final token = await messaging.getToken();
      debugPrint('FCM token: $token');
      return token;
    } catch (e) {
      debugPrint('FCM token error: $e');
      return null;
    }
  }
}