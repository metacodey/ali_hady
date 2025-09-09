import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../core/class/preferences.dart';

NotificationService notificationService = NotificationService();

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      await _initializeLocalNotifications();
      await _requestNotificationPermission();
      // await _firebaseMessaging.subscribeToTopic('allUsers');
      await _firebaseMessaging.setAutoInitEnabled(true);
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // التعامل مع الرسائل عند فتح التطبيق من إشعار
      FirebaseMessaging.instance.getInitialMessage().then(_handleMessage);

      // التعامل مع الرسائل عند فتح التطبيق من إشعار (عندما يكون التطبيق في الخلفية)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

      // التعامل مع الرسائل عند وصول إشعار جديد (عندما يكون التطبيق في الواجهة الأمامية)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log('Foreground Notification Payload: ${message.notification?.toMap()}');
        _showLocalNotification(message);
      });

      // تحديث رمز FCM عند التغيير
      FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
        log('FCM Token refreshed: $token');
        // هنا يمكنك إرسال الرمز الجديد إلى الخادم الخاص بك
      });

      // الحصول على الرمز الحالي لـ FCM
      final String? token = await _firebaseMessaging.getToken();
      log('FCM Token: $token');
    } catch (e) {
      log('Error initializing notifications: $e');
    }
  }

  static Future<String?> getToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? apnsToken;
      if (Platform.isIOS) {
        int retries = 5;
        int delaySeconds = 2;
        while (retries > 0) {
          apnsToken = await messaging.getAPNSToken();
          if (apnsToken != null) {
            log("✅ APNs Token: $apnsToken");
            break;
          }
          await Future.delayed(Duration(seconds: delaySeconds));
          retries--;
        }

        if (apnsToken == null) {
          log("⚠️ لم يتم الحصول على APNs Token بعد عدة محاولات");
        }
      }
      String? firebaseToken = await messaging.getToken();
      if (firebaseToken != null) {
        log("✅ Firebase Token: $firebaseToken");
        if (Platform.isIOS) {
          // showSnakBar(title: "Token", msg: firebaseToken);
        }
      } else {
        log("⚠️ لم يتم الحصول على Firebase Token");
      }

      return firebaseToken;
    } catch (e) {
      if (Platform.isIOS) {
        log("❌ خطأ أثناء جلب التوكن: ${e.toString()}");
      }
      // showSnakBar(title: "Token Error", msg: e.toString());
      return null;
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log('Notification clicked: ${response.payload}');
      },
    );
  }

  Future<void> _requestNotificationPermission() async {
    if (Platform.isIOS) {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        log('User granted notification permission');
        Preferences.setBoolean(Preferences.notificationApp, true);
      } else {
        Preferences.setBoolean(Preferences.notificationApp, false);
        log('User declined or has not accepted notification permission');
      }
    }
  }

  void _handleMessage(RemoteMessage? message) {
    if (message != null) {
      final payload = message.notification?.toMap();
      log('Notification Payload: $payload');
      // هنا يمكنك التعامل مع الرسالة، مثل فتح صفحة معينة في التطبيق
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }
}

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  final payloadData = message.data;
  log('Background Notification Data: $payloadData');
  log('Background Notification Payload: ${message.notification?.toMap()}');
  // هنا يمكنك التعامل مع الرسالة في الخلفية
}
