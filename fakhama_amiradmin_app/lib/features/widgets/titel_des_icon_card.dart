import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

class TitelDesIconCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const TitelDesIconCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle,
      required this.color,
      required this.isDark,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140.h,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: isDark
              ? Border.all(color: const Color(0xFF475569), width: 1)
              : null,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الأيقونة
            Container(
              width: 52.w,
              height: 52.h,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                icon,
                size: 26.sp,
                color: color,
              ),
            ),

            SizedBox(height: 12.h),

            // العنوان
            Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 6.h),

            // العنوان الفرعي
            McText(
              txt: subtitle,
              fontSize: 9.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              txtAlign: TextAlign.center,
              line: 2,
            ),
          ],
        ),
      ),
    );
  }
}
