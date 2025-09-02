import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

class NotFoundData extends StatelessWidget {
  final String title;
  final String? value;
  final IconData? icon;
  final String? titleBtn;
  final Function()? onTap;

  const NotFoundData(
      {super.key,
      required this.title,
      this.value,
      this.onTap,
      this.titleBtn,
      this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon ?? Icons.precision_manufacturing_outlined,
              size: 64.r,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
          SizedBox(height: 16.h),
          McText(
            txt: title,
            fontSize: 16.sp,
            color: colorScheme.onSurface.withOpacity(0.6),
            blod: true,
          ),
          SizedBox(height: 8.h),
          if (value != null)
            McText(
              txt: value!,
              fontSize: 14.sp,
              blod: true,
              color: colorScheme.onSurface.withOpacity(0.4),
            ),
          SizedBox(height: 24.h),
          if (titleBtn != null && onTap != null)
            ElevatedButton.icon(
              onPressed: () => Get.toNamed('/client/add'),
              icon: const Icon(Icons.add),
              label: const Text('إضافة عميل جديد'),
            ),
        ],
      ),
    );
  }
}
