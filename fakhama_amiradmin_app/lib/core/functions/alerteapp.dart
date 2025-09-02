import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../theme/controller/theme_controller.dart';
import '../constants/colors.dart';
import '../constants/utils/assets/fonts.dart';

Future<bool> alertExitApp() {
  ThemeController controller = Get.find<ThemeController>();
  Get.defaultDialog(
      title: "alert".tr,
      titleStyle: TextStyle(
          fontFamily: AppFontFamilies.cairoFont,
          color: controller.darkTheme ? Colors.white : AppColors.kDarkBlue,
          fontWeight: FontWeight.bold),
      middleTextStyle: TextStyle(
          fontFamily: AppFontFamilies.cairoFont,
          color: controller.darkTheme ? Colors.white : AppColors.kDarkBlue,
          fontWeight: FontWeight.bold),
      middleText: "exit".tr,
      actions: [
        McButton(
          txt: "agree".tr,
          colorBtn: AppColors.kDarkBlue,
          color: Colors.white,
          colorBorder: AppColors.kDarkBlue,
          blod: true,
          fontSize: 16,
          padding: const EdgeInsets.all(7),
          raudis: BorderRadius.circular(30),
          width: 80,
          onTap: () => exit(0),
        ),
        McButton(
          txt: "cancel".tr,
          colorBorder: AppColors.kDarkBlue,
          color: !controller.darkTheme ? AppColors.kDarkBlue : Colors.white,
          blod: true,
          fontSize: 16,
          padding: const EdgeInsets.all(7),
          raudis: BorderRadius.circular(30),
          width: 80,
          onTap: () => Get.back(),
        ),
      ]);
  return Future.value(true);
}

Future<bool> alertDialogData({
  required String title,
  String body = "",
  Function()? accespt,
  Function()? denided,
}) async {
  final ThemeController themecontroller = Get.find<ThemeController>();
  final isDarkTheme = themecontroller.darkTheme;

  await Get.defaultDialog(
    backgroundColor: isDarkTheme ? Colors.black : Colors.white,
    title: title,
    titleStyle: TextStyle(
      fontFamily: AppFontFamilies.cairoFont,
      color: isDarkTheme ? Colors.white : AppColors.kDarkBlue,
      fontWeight: FontWeight.bold,
    ),
    middleTextStyle: TextStyle(
      fontFamily: AppFontFamilies.cairoFont,
      color: isDarkTheme ? Colors.white : AppColors.kDarkBlue,
      fontWeight: FontWeight.bold,
    ),
    middleText: body,
    actions: [
      McButton(
        txt: "yes".tr,
        colorBtn: isDarkTheme ? Colors.white : Colors.black,
        color: Colors.red,
        colorBorder: isDarkTheme ? Colors.white : Colors.black,
        blod: true,
        fontSize: 16,
        padding: const EdgeInsets.all(7),
        raudis: BorderRadius.circular(30),
        width: 80,
        onTap: accespt,
      ),
      McButton(
        txt: "no".tr,
        colorBtn: isDarkTheme ? Colors.white : Colors.black,
        color: isDarkTheme ? Colors.black : Colors.white,
        blod: true,
        fontSize: 16,
        padding: const EdgeInsets.all(7),
        raudis: BorderRadius.circular(30),
        width: 80,
        onTap: denided,
      ),
    ],
  );

  return Future.value(true);
}

void showFilterDialog(
    {required Widget content, String title = "filter_options"}) {
  Get.defaultDialog(
      title: title.tr,
      titleStyle: const TextStyle(
          fontFamily: AppFontFamilies.cairoFont,
          color: AppColors.blueLight,
          fontWeight: FontWeight.bold),
      content: content);
}
