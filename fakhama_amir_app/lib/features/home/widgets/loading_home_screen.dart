import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

class LoadingHomeScreen extends StatelessWidget {
  const LoadingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // شعار بسيط وأنيق
            _buildSimpleLogo(context),

            SizedBox(height: 40.h),

            // مؤشر التحميل البسيط
            _buildSimpleLoadingIndicator(context),

            SizedBox(height: 30.h),

            // نص التحميل
            Text(
              'loading'.tr,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: colorScheme.onBackground,
              ),
            ),

            SizedBox(height: 8.h),

            // نص فرعي
            Text(
              'please_wait'.tr,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                color: colorScheme.onBackground.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// شعار بسيط وأنيق
  Widget _buildSimpleLogo(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Icon(
        Icons.water_drop,
        size: 50.sp,
        color: colorScheme.primary,
      ),
    );
  }

  /// مؤشر التحميل البسيط
  Widget _buildSimpleLoadingIndicator(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(
            colorScheme.primary,
          ),
          backgroundColor: colorScheme.primary.withOpacity(0.1),
        ),
      ),
    );
  }
}
