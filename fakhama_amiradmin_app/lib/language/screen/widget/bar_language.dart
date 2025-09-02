import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

import '../../../core/constants/utils/assets/fonts.dart';
import '../../../core/constants/utils/assets/images.dart';

class BarLanguage extends StatelessWidget {
  const BarLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppImages.apple,
            width: 120.w,
            height: 120.h,
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            "فوتره".tr,
            style: TextStyle(
              fontFamily: AppFontFamilies.hacenTypographer,
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
              letterSpacing: 1.2,
              shadows: const [
                Shadow(
                  blurRadius: 4.0,
                  color: Colors.black26,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
          SizedBox(
            height: Get.height * 0.060.h,
          ),
          Row(
            children: [
              McText(
                txt: "select_language".tr,
                fontSize: 12.5.sp,
              )
            ],
          )
        ],
      ),
    );
  }
}
