import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

import '../../../core/controller/connect_controller.dart';
import '../controller/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: Column(
          children: [
            GetBuilder<ConnectController>(
              builder: (connect) {
                if (connect.checkIsConnect) {
                  return Container();
                }
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  color: connect.checkIsConnect
                      ? const Color(0xFF00EE44)
                      : const Color(0xFFEE4400),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: connect.checkIsConnect
                        ? Text('online'.tr)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('offline'.tr),
                              const SizedBox(width: 8.0),
                              const SizedBox(
                                width: 12.0,
                                height: 12.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),
            Expanded(
              child: IndexedStack(
                index: controller.pageIndex.value,
                children: controller.screens,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          useLegacyColorScheme: false,
          currentIndex: controller.pageIndex.value,
          onTap: controller.jumpToPage,
          selectedIconTheme: IconThemeData(size: 30.sp),
          unselectedIconTheme: IconThemeData(size: 26.sp),
          items: controller.buildBottomNavItems(),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     var setting = Get.find<SettingController>();
        //     if (setting.setting == null) return;
        //     launchUrlApp(
        //         'https://wa.me/${setting.setting?.whatsappPhone}?text=${setting.setting?.whatsappMessage}');
        //   },
        //   backgroundColor: Theme.of(context).canvasColor,
        //   child: McImageAssets(
        //     path: AppImages.whatsapp,
        //     width: 35.w,
        //     height: 35.h,
        //   ),
        // )
      );
    });
  }
}
