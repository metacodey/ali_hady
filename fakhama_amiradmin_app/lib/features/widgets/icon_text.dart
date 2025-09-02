import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

class IconText extends StatelessWidget {
  final String title;
  final Widget child;
  final Function()? onTap;
  final Color? color;
  final bool isBlod;
  final bool isSpaceBetween;
  final double horizontal;
  final double vertical;
  final double fSize;
  const IconText(
      {super.key,
      required this.title,
      required this.child,
      this.onTap,
      this.color,
      this.fSize = 14,
      this.isSpaceBetween = false,
      this.isBlod = false,
      this.vertical = 7,
      this.horizontal = 10});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: horizontal.w, vertical: vertical.h),
        child: Row(
          mainAxisAlignment: isSpaceBetween
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
          crossAxisAlignment: isSpaceBetween
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.end,
          children: [
            if (!isSpaceBetween) child,
            if (!isSpaceBetween)
              SizedBox(
                width: 15.w,
              ),
            McText(
              txt: title.tr,
              blod: isBlod,
              fontSize: fSize.sp,
              color: color,
            ),
            if (isSpaceBetween)
              SizedBox(
                width: 15.w,
              ),
            if (isSpaceBetween) child,
          ],
        ),
      ),
    );
  }
}
