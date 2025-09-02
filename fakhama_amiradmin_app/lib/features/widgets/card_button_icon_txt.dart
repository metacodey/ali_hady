import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

class CardButtonIconTxt extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Function()? onTap;

  const CardButtonIconTxt({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(isDark ? 0.3 : 0.2),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: color.withOpacity(isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: color.withOpacity(isDark ? 0.5 : 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 16.sp,
                ),
                SizedBox(width: 6.w),
                McText(
                  txt: label,
                  color: color,
                  fontSize: 12.sp,
                  blod: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
