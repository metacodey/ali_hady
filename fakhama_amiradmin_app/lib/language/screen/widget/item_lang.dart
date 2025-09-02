import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../controller/localization_controller.dart';
import '../../model/language.dart';

class ItemLang extends StatelessWidget {
  final LanguageModel model;
  final int index;
  const ItemLang({super.key, required this.model, this.index = 0});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<LocalizationController>();
    var theme = Theme.of(context);
    return InkWell(
      onTap: () => controller.setSelectIndex(index),
      child: Container(
        decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(5.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // الشفافية
                offset: const Offset(0.0, 1.0), // ظل للأسفل
                blurRadius: 4.0.r, // تمويه
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.0),
                offset: const Offset(0.0, -1.0), // ظل للأعلى
                blurRadius: 5.0.r,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(1.0, 0.0), // ظل لليمين
                blurRadius: 4.0.r,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.0),
                offset: const Offset(-1.0, 0.0), // ظل لليسار
                blurRadius: 5.0.r,
              ),
            ]),
        child: Stack(
          children: [
            Container(
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  McCardItem(
                    showShdow: false,
                    colorBorder: Colors.black,
                    color: theme.canvasColor,
                    widthBorder: 1.w,
                    radius: BorderRadius.circular(5),
                    child: McImageAssets(
                      path: model.imageUrl ?? "",
                      width: 36.w,
                      height: 30.h,
                    ),
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  McText(
                    txt: model.languageName ?? "",
                    fontSize: 12.5.sp,
                    color: theme.textTheme.bodyLarge?.color,
                  )
                ],
              ),
            ),
            GetBuilder<LocalizationController>(builder: (controller) {
              if (index == controller.selectedIndex) {
                return Positioned(
                  right: 10.w,
                  top: 10.h,
                  child: Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                  ),
                );
              }
              return Container();
            })
          ],
        ),
      ),
    );
  }
}
