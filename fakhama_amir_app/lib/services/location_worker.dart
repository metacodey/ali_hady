import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fakhama_amir_app/core/class/preferences.dart';
import 'package:fakhama_amir_app/services/api/api_services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';
// import 'notifications/notifcations_service.dart';
import 'package:http/http.dart' as http;

class LocationWorker {
  static const String _taskName = "location_update_task";
  static const String _uniqueName = "location_update_unique";

  /// تهيئة WorkManager
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false, // تعيين false في الإنتاج
    );

    // طلب تجاهل تحسين الكبطارية لضمان العمل المستمر
    await _requestIgnoreBatteryOptimization();
    await startLocationUpdates();
  }

  /// طلب تجاهل تحسين البطارية
  static Future<void> _requestIgnoreBatteryOptimization() async {
    try {
      if (Platform.isAndroid) {
        // يمكن إضافة كود لطلب تجاهل تحسين البطارية هنا
        // هذا يتطلب plugin إضافي مثل battery_optimization

        // استخدام plugin disable_battery_optimization
        // أولاً تحقق من حالة تحسين البطارية
        // bool isIgnoringBatteryOptimizations = await DisableBatteryOptimization.isIgnoringBatteryOptimizations;

        // if (!isIgnoringBatteryOptimizations) {
        //   // طلب تجاهل تحسين البطارية
        //   await DisableBatteryOptimization.showIgnoreBatteryOptimizationSettings();
        // }

        // أو استخدام plugin battery_optimization
        // await BatteryOptimization.requestIgnoreBatteryOptimizations();

        // أو استخدام plugin permission_handler مع android_intent_plus
        // final AndroidIntent intent = AndroidIntent(
        //   action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
        //   data: 'package:${await PackageInfo.fromPlatform().then((info) => info.packageName)}',
        // );
        // await intent.launch();

        log('Battery optimization request - consider adding battery_optimization plugin');
        log('Recommended plugins: disable_battery_optimization, battery_optimization, or permission_handler');
        log('Add to pubspec.yaml: disable_battery_optimization: ^1.1.1');
      }
    } catch (e) {
      log('Error requesting battery optimization ignore: $e');
    }
  }

  /// بدء تحديث الموقع الدوري كل 15 دقيقة
  static Future<void> startLocationUpdates() async {
    await Workmanager().registerPeriodicTask(
      _uniqueName,
      _taskName,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: const Duration(seconds: 30),
    );
    log('Location updates started - every 15 minutes');
  }

  /// إيقاف تحديث الموقع الدوري
  static Future<void> stopLocationUpdates() async {
    await Workmanager().cancelByUniqueName(_uniqueName);
    log('Location updates stopped');
  }

  /// التحقق من حالة المهمة
  static Future<bool> isLocationUpdatesActive() async {
    // WorkManager لا يوفر طريقة مباشرة للتحقق من المهام النشطة
    // يمكن استخدام SharedPreferences لتتبع الحالة
    return Preferences.getBoolean('location_updates_active');
  }

  /// تحديث الموقع الحالي
  static Future<void> updateCurrentLocation() async {
    try {
      log('Starting location update...');

      // التحقق من تفعيل خدمات الموقع
      if (!await Geolocator.isLocationServiceEnabled()) {
        log('Location services are disabled');
        // await NotificationService.showSimpleNotification(
        //   title: ' error',
        //   body: 'Location services are disabled',
        //   payload: 'background_task_loaction',
        // );
        return;
      }

      // التحقق من الأذونات
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        log('Location permission denied');
        // await NotificationService.showSimpleNotification(
        //   title: ' error',
        //   body: 'Location permission denied',
        //   payload: 'background_task_denied',
        // );
        return;
      }

      // الحصول على الموقع الحالي
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30),
      );

      // الحصول على معلومات العنوان
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark? placeMark = placemarks.isNotEmpty ? placemarks[0] : null;

      // إرسال الموقع إلى الخادم
      await _sendLocationToServer(position, placeMark);

      log('Location updated successfully: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      // await NotificationService.showBigTextNotification(
      //     title: ' error',
      //     body: 'Error updating location ',
      //     payload: 'background_taskError_updating',
      //     bigText: e.toString(),
      //     summaryText: "test");
      log('Error updating location: $e');
    }
  }

  static Map<String, String>? _headerWithToken() {
    var user = Preferences.getDataUser();
    if (user != null) {
      var token = user.token;
      return {"Authorization": "Bearer $token"};
    }
    return null;
  }

  /// إرسال الموقع إلى الخادم
  static Future<void> _sendLocationToServer(
      Position position, Placemark? placeMark) async {
    try {
      await Preferences.initPref();
      var user = Preferences.getDataUser();
      var header = _headerWithToken();

      if (user?.id == null || header == null) {
        log('User not found, cannot update location');
        // await NotificationService.showSimpleNotification(
        //   title: ' notfound',
        //   body: 'User not found, cannot update location',
        //   payload: 'background_taskError_notfound',
        // );
        return;
      }

      Map<String, dynamic> locationData = {
        "city": placeMark?.locality ?? "",
        "street_address": placeMark?.street ?? "",
        "country": placeMark?.country ?? "",
        "latitude": position.latitude,
        "longitude": position.longitude
      };

      await http
          .put(
            Uri.parse("${ApiServices.editCustomer}${user!.id!}/location"),
            headers: {...ApiServices.headers, ...header},
            body: jsonEncode(locationData),
          )
          .timeout(const Duration(seconds: 60));
      // إنشاء instance من DataApi
      // ملاحظة: قد تحتاج لتعديل هذا حسب طريقة إنشاء DataApi في مشروعك

      log('Location sent to server successfully');
    } catch (e) {
      // await NotificationService.showBigTextNotification(
      //     title: ' error',
      //     body: 'Error sending location to server: ',
      //     payload: 'background_taskError_error',
      //     bigText: e.toString(),
      //     summaryText: "test test");
      log('Error sending location to server: $e');
    }
  }
}

/// Callback dispatcher للعمل في الخلفية
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      log('Background task started: $task');

      switch (task) {
        case 'location_update_task':
          // إظهار إشعار بدء المهمة في الخلفية
          // await NotificationService.showSimpleNotification(
          //   title: 'مهمة الخلفية',
          //   body: 'بدء تحديث الموقع في الخلفية...',
          //   payload: 'background_task_started',
          // );

          await LocationWorker.updateCurrentLocation();

          // إظهار إشعار انتهاء المهمة
          // await NotificationService.showSimpleNotification(
          //   title: 'مهمة الخلفية',
          //   body: 'تم الانتهاء من تحديث الموقع في الخلفية',
          //   payload: 'background_task_completed',
          // );
          break;
        default:
          log('Unknown task: $task');
      }

      return Future.value(true);
    } catch (e) {
      log('Background task failed: $e');

      // إظهار إشعار خطأ في المهمة
      // await NotificationService.showSimpleNotification(
      //   title: 'خطأ في مهمة الخلفية',
      //   body: 'فشل في تنفيذ مهمة تحديث الموقع: ${e.toString()}',
      //   payload: 'background_task_error',
      // );

      return Future.value(false);
    }
  });
}
