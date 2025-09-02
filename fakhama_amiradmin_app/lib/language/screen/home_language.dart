import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

import 'widget/bar_language.dart';
import 'widget/footer_lang.dart';
import 'widget/list_lang.dart';

class HomeLanguage extends StatelessWidget {
  const HomeLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: Get.height * 0.1.h,
                ),
                const BarLanguage(),
                SizedBox(
                  height: 10.h,
                ),
                const Expanded(child: ListLang()),
                const FooterLang(),
              ],
            ),
          ),
        ));
  }
}
