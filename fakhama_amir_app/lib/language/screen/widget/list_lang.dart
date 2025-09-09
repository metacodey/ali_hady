import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';
import 'dart:ui' as ui;
import '../../controller/localization_controller.dart';
import 'item_lang.dart';

class ListLang extends GetView<LocalizationController> {
  const ListLang({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
        ),
        itemCount: controller.languages.length,
        itemBuilder: (context, index) {
          return ItemLang(
            model: controller.languages[index],
            index: index,
          );
        },
      ),
    );
  }
}
