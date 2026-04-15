import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/fcm_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FCMService _fcmService = FCMService();

  String statusText = 'Waiting for a cloud message';
  String imagePath = 'assets/images/default.png';
  String tokenText = 'Loading token...';

  @override
  void initState() {
    super.initState();
    _setupFCM();
  }

  Future<void> _setupFCM() async {
    await _fcmService.initialize(
      onData: (RemoteMessage message) {
        setState(() {
          statusText = message.notification?.title ?? 'Payload received';

          imagePath =
              'assets/images/${message.data['asset'] ?? 'default'}.png';
        });

        debugPrint('Message title: ${message.notification?.title}');
        debugPrint('Message body: ${message.notification?.body}');
        debugPrint('Message data: ${message.data}');
      },
    );

    final token = await _fcmService.getToken();

    setState(() {
      tokenText = token ?? 'No token found';
    });

    debugPrint('FCM token: $token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Messaging App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              statusText,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Image.asset(
              imagePath,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return const Text('Image failed to load');
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'FCM Token:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SelectableText(tokenText),
          ],
        ),
      ),
    );
  }
}