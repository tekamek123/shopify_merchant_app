import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
import 'app/app.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle background message
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kIsWeb) {
    WebViewPlatform.instance = WebWebViewPlatform();
  }
  
  // Initialize Firebase
  try {
    // Note: Once 'flutterfire configure' works, import 'firebase_options.dart' 
    // and pass DefaultFirebaseOptions.currentPlatform here.
    await Firebase.initializeApp();
    
    // Configure FCM
    final messaging = FirebaseMessaging.instance;
    
    // Request permissions
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted notification permissions');
      final token = await messaging.getToken();
      debugPrint('FCM Token: $token');
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    debugPrint('Running without Firebase features. Run "flutterfire configure" to fix.');
  }
  
  runApp(const ShopifyApp());
}
