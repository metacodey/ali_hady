import 'dart:developer';
import 'package:fakhama_amir_app/core/class/preferences.dart';
import 'package:fakhama_amir_app/services/data/data_api.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';
import 'package:mc_utils/mc_utils.dart';

class LocationWorker {
  static const String _taskName = "location_update_task";
  static const String _uniqueName = "location_update_unique";

  /// تهيئة WorkManager
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false, // تعيين false في الإنتاج
    );
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
        return;
      }

      // التحقق من الأذونات
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        log('Location permission denied');
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
      log('Error updating location: $e');
    }
  }

  /// إرسال الموقع إلى الخادم
  static Future<void> _sendLocationToServer(
      Position position, Placemark? placeMark) async {
    try {
      var user = Preferences.getDataUser();
      if (user?.id == null) {
        log('User not found, cannot update location');
        return;
      }

      Map<String, dynamic> locationData = {
        "city": placeMark?.locality ?? "",
        "street_address": placeMark?.street ?? "",
        "country": placeMark?.country ?? "",
        "latitude": position.latitude,
        "longitude": position.longitude
      };

      // إنشاء instance من DataApi
      // ملاحظة: قد تحتاج لتعديل هذا حسب طريقة إنشاء DataApi في مشروعك
      final dataApi = DataApi(Get.find());

      await dataApi.updateLocationCustomer(user!.id!, locationData);
      log('Location sent to server successfully');
    } catch (e) {
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
          await LocationWorker.updateCurrentLocation();
          break;
        default:
          log('Unknown task: $task');
      }

      return Future.value(true);
    } catch (e) {
      log('Background task failed: $e');
      return Future.value(false);
    }
  });
}
