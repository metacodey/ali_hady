import 'package:geolocator/geolocator.dart';
import 'package:mc_utils/mc_utils.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/class/statusrequest.dart';
import '../../../services/data/data_api.dart';
import '../../../services/helper_function.dart';
import '../../auth/models/user_model.dart';

class MapAppController extends GetxController {
  // حالة الطلب
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;
  final DataApi dataApi = DataApi(Get.find());
  RxList<UserModel> clients = RxList<UserModel>([]);
  Rx<Position?> currentPosition = Rx<Position?>(null);

  // متغيرات جديدة للخريطة
  Rx<UserModel?> selectedUser = Rx<UserModel?>(null);
  RxBool isBottomSheetVisible = false.obs;

  // متحكم الخريطة للتحكم في الزوم والتنقل
  late MapController mapController;

  // حالة تحديث الموقع
  RxBool isUpdatingLocation = false.obs;

  @override
  void onInit() {
    super.onInit();
    mapController = MapController();
    getCurrentLocation();
    fetchData();
  }

  // فلترة المستخدمين الذين لديهم إحداثيات
  List<UserModel> get usersWithLocation {
    return clients
        .where((user) =>
            user.latitude != null &&
            user.longitude != null &&
            user.latitude != 0 &&
            user.longitude != 0)
        .toList();
  }

  // اختيار مستخدم وإظهار الشريط السفلي مع الزوم
  void selectUser(UserModel user) {
    selectedUser.value = user;
    isBottomSheetVisible.value = true;

    // زوم تلقائي إلى موقع المستخدم
    zoomToUser(user.latitude!, user.longitude!);
  }

  // إغلاق الشريط السفلي
  void closeBottomSheet() {
    isBottomSheetVisible.value = false;
    selectedUser.value = null;
  }

  // زوم إلى موقع مستخدم محدد
  void zoomToUser(double latitude, double longitude) {
    mapController.move(LatLng(latitude, longitude), 15.0);
  }

  // زوم إلى موقعي الحالي
  void zoomToMyLocation() {
    if (currentPosition.value != null) {
      mapController.move(
        LatLng(
          currentPosition.value!.latitude,
          currentPosition.value!.longitude,
        ),
        15.0,
      );
    }
  }

  // زوم للداخل
  void zoomIn() {
    final currentZoom = mapController.camera.zoom;
    mapController.move(mapController.camera.center, currentZoom + 1);
  }

  // زوم للخارج
  void zoomOut() {
    final currentZoom = mapController.camera.zoom;
    mapController.move(mapController.camera.center, currentZoom - 1);
  }

  // إعادة تحميل البيانات والموقع
  Future<void> refreshData() async {
    await Future.wait([
      getCurrentLocation(),
      fetchData(),
    ]);
  }

  Future<void> fetchData({bool hideLoading = false}) async {
    if (statusRequest.value.isLoading) return;

    await handleRequestfunc(
      hideLoading: true,
      status: hideLoading ? null : (status) => statusRequest.value = status,
      apiCall: () async => await dataApi.getDataMap(),
      onSuccess: (res) {
        var data = res['data'] as List?;
        if (data != null) {
          clients.assignAll(data.map((e) => UserModel.fromJson(e)).toList());
        }
      },
      onError: showError,
    );
  }

  Future<void> getCurrentLocation() async {
    try {
      isUpdatingLocation.value = true;

      if (!await Geolocator.isLocationServiceEnabled()) {
        isUpdatingLocation.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          isUpdatingLocation.value = false;
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      currentPosition.value = position;
      isUpdatingLocation.value = false;
    } catch (e) {
      isUpdatingLocation.value = false;
    }
  }
}
