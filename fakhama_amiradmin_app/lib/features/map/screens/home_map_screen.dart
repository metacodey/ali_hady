import 'package:fakhama_amiradmin_app/core/class/statusrequest.dart';
import 'package:fakhama_amiradmin_app/core/constants/utils/widgets/custom_text_field.dart';
import 'package:fakhama_amiradmin_app/features/map/controllers/map_app_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/colors.dart';

class HomeMapScreen extends GetView<MapAppController> {
  const HomeMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          if (controller.statusRequest.value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Stack(
            children: [
              // الخريطة
              FlutterMap(
                mapController: controller.mapController,
                options: MapOptions(
                  initialCenter: LatLng(
                    controller.currentPosition.value?.latitude ?? 24.7136,
                    controller.currentPosition.value?.longitude ?? 46.6753,
                  ),
                  initialZoom: 12.0,
                  minZoom: 3.0,
                  maxZoom: 18.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.fakhama_amiradmin_app',
                  ),

                  // طبقة ماركات المستخدمين
                  MarkerLayer(
                    markers: [
                      // موقعي الحالي
                      if (controller.currentPosition.value != null)
                        Marker(
                          point: LatLng(
                            controller.currentPosition.value!.latitude,
                            controller.currentPosition.value!.longitude,
                          ),
                          width: 50,
                          height: 50,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),

                      // ماركات المستخدمين
                      ...controller.usersWithLocation.map((user) {
                        final isSelected =
                            controller.selectedUser.value?.id == user.id;
                        return Marker(
                          point: LatLng(user.latitude!, user.longitude!),
                          width: isSelected ? 50 : 40,
                          height: isSelected ? 50 : 40,
                          child: GestureDetector(
                            onTap: () => controller.selectUser(user),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.orange : Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: isSelected ? 3 : 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isSelected
                                            ? Colors.orange
                                            : Colors.blue)
                                        .withOpacity(0.3),
                                    blurRadius: isSelected ? 15 : 8,
                                    spreadRadius: isSelected ? 5 : 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: isSelected ? 25 : 20,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
              // شريط البحث الجديد
              Positioned(
                top: 50,
                left: 16,
                right: 16,
                child: CustomTextField(
                  controller: controller.searchController,
                  hintText: 'ابحث عن مستخدم (الاسم، الهاتف، المدينة...)',
                  // focusNode: controller.searchFocus,
                  prefixIcon: Icon(
                    Icons.search,
                    size: 24.sp,
                    color: Theme.of(context).dividerColor,
                  ),
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  padding: EdgeInsets.all(12.r),
                  radius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(
                      color: AppColors.greenBlueVeryLight, width: 2),
                  keyboardType: TextInputType.text,
                  suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            controller.searchController.clear();
                            controller.clearSearch();
                          },
                        )
                      : const SizedBox()),
                  onChanged: controller.updateSearchQuery,
                ),
              ),

              // أزرار التحكم في الخريطة
              Positioned(
                bottom: 50,
                left: 16,
                child: Column(
                  children: [
                    // زر إعادة التحميل
                    _buildControlButton(
                      icon: controller.isUpdatingLocation.value
                          ? Icons.refresh
                          : Icons.refresh,
                      onPressed: controller.refreshData,
                      backgroundColor: Colors.green,
                      isLoading: controller.isUpdatingLocation.value,
                    ),
                    const SizedBox(height: 8),
                    // زر موقعي
                    _buildControlButton(
                      icon: Icons.my_location,
                      onPressed: controller.zoomToMyLocation,
                      backgroundColor: Colors.red,
                    ),
                    const SizedBox(height: 8),
                    // زر الزوم للداخل
                    _buildControlButton(
                      icon: Icons.zoom_in,
                      onPressed: controller.zoomIn,
                    ),
                    const SizedBox(height: 8),
                    // زر الزوم للخارج
                    _buildControlButton(
                      icon: Icons.zoom_out,
                      onPressed: controller.zoomOut,
                    ),
                  ],
                ),
              ),

              // مؤشر عدد المستخدمين مع نتائج البحث
              Positioned(
                top: 110,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: controller.isSearching.value
                        ? Colors.orange.withOpacity(0.9)
                        : Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        controller.isSearching.value
                            ? Icons.search
                            : Icons.people,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      McText(
                        txt: controller.isSearching.value
                            ? 'نتائج: ${controller.usersWithLocation.length}'
                            : '${controller.usersWithLocation.length}',
                        color: Colors.white,
                        fontSize: 14,
                        blod: true,
                      ),
                    ],
                  ),
                ),
              ),

              // الشريط السفلي المحسن والمضغوط
              if (controller.isBottomSheetVisible.value &&
                  controller.selectedUser.value != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, -8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // رأس الشريط المضغوط
                        Row(
                          children: [
                            // أيقونة المستخدم المصغرة
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade400,
                                    Colors.blue.shade600
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // بيانات المستخدم المضغوطة
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  McText(
                                    txt:
                                        controller.selectedUser.value!.fullName,
                                    fontSize: 16,
                                    blod: true,
                                    color: Colors.black87,
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      McText(
                                        txt: controller
                                            .selectedUser.value!.phone,
                                        fontSize: 12,
                                        color: Colors.grey[600]!,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // زر الإغلاق المصغر
                            GestureDetector(
                              onTap: controller.closeBottomSheet,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.grey[600],
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // أزرار العمليات المحسنة
                        Row(
                          children: [
                            // زر الاتصال
                            Expanded(
                              child: Container(
                                height: 42,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.shade400,
                                      Colors.green.shade600
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _makePhoneCall(
                                      controller.selectedUser.value!.phone,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        SizedBox(width: 6),
                                        McText(
                                          txt: "اتصال",
                                          color: Colors.white,
                                          fontSize: 14,
                                          blod: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // زر خرائط جوجل
                            Expanded(
                              child: Container(
                                height: 42,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.shade400,
                                      Colors.blue.shade600
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _openGoogleMaps(
                                      controller.selectedUser.value!.latitude!,
                                      controller.selectedUser.value!.longitude!,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.map,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        SizedBox(width: 6),
                                        McText(
                                          txt: "خرائط",
                                          color: Colors.white,
                                          fontSize: 14,
                                          blod: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // زر معلومات إضافية
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _showUserDetails(context),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Icon(
                                    Icons.info_outline,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // ويدجت لأزرار التحكم
  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color backgroundColor = Colors.white,
    bool isLoading = false,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    backgroundColor == Colors.white
                        ? Colors.blue
                        : Colors.white,
                  ),
                ),
              )
            : Icon(
                icon,
                color: backgroundColor == Colors.white
                    ? Colors.black87
                    : Colors.white,
                size: 24,
              ),
      ),
    );
  }

  // فتح تطبيق الهاتف للاتصال
  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  // فتح خرائط جوجل
  void _openGoogleMaps(double latitude, double longitude) async {
    final Uri googleMapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );
    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    }
  }

  // دالة لإظهار تفاصيل المستخدم الكاملة
  void _showUserDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // شريط علوي للسحب
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // عنوان
            const McText(
              txt: "تفاصيل المستخدم",
              fontSize: 20,
              blod: true,
            ),
            const SizedBox(height: 20),

            // التفاصيل
            _buildDetailRow(
                Icons.person, "الاسم", controller.selectedUser.value!.fullName),
            _buildDetailRow(
                Icons.phone, "الهاتف", controller.selectedUser.value!.phone),
            if (controller.selectedUser.value!.city != null)
              _buildDetailRow(Icons.location_city, "المدينة",
                  controller.selectedUser.value!.city!),
            if (controller.selectedUser.value!.country != null)
              _buildDetailRow(Icons.public, "البلد",
                  controller.selectedUser.value!.country!),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                McText(
                  txt: label,
                  fontSize: 12,
                  color: Colors.grey[600]!,
                ),
                McText(
                  txt: value,
                  fontSize: 16,
                  blod: true,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
