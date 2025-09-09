import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';

import '../constants/colors.dart';
import '../constants/utils/assets/fonts.dart';

class FiltersOpations {
  static sortUp({Function()? onTap}) {
    return ListTile(
        title: McText(
          txt: "sort_up".tr,
          fontFamily: AppFontFamilies.cairoFont,
          color: AppColors.blueVeryLight,
          blod: true,
        ),
        onTap: onTap);
  }

  static sortDown({Function()? onTap}) {
    return ListTile(
        title: McText(
          txt: "sort_down".tr,
          fontFamily: AppFontFamilies.cairoFont,
          color: AppColors.blueVeryLight,
          blod: true,
        ),
        onTap: onTap);
  }

  static showCheckBox(
      {required String title, bool value = false, Function(bool?)? onTap}) {
    return CheckboxListTile(
      onChanged: onTap,
      value: value,
      title: McText(
        txt: title.tr,
        fontFamily: AppFontFamilies.cairoFont,
        color: AppColors.blueVeryLight,
        blod: true,
      ),
    );
  }
}

class TxtFilter extends StatelessWidget {
  final String title;
  const TxtFilter({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return McText(
      txt: title,
      fontFamily: AppFontFamilies.cairoFont,
      color: AppColors.blueVeryLight,
      blod: true,
    );
  }
}
