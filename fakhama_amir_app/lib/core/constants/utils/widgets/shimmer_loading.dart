import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShimmerLoading extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.isLoading = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return child;
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
      child: child,
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;

  const ShimmerContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }
}

// كلاس جديد للـ shimmer loading الخاص بقائمة العملاء
class ClientsShimmerLoading extends StatelessWidget {
  final int itemCount;

  const ClientsShimmerLoading({
    super.key,
    this.itemCount = 8,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      itemBuilder: (context, index) {
        return ShimmerLoading(
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // صورة العميل
                ShimmerContainer(
                  width: 50.w,
                  height: 50.h,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                SizedBox(width: 12.w),
                // معلومات العميل
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // اسم العميل
                      ShimmerContainer(
                        width: double.infinity,
                        height: 16.h,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      SizedBox(height: 8.h),
                      // رقم الهاتف
                      ShimmerContainer(
                        width: 120.w,
                        height: 14.h,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      SizedBox(height: 6.h),
                      // المنطقة
                      ShimmerContainer(
                        width: 80.w,
                        height: 12.h,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                // معلومات إضافية
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // الرصيد
                    ShimmerContainer(
                      width: 60.w,
                      height: 16.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    SizedBox(height: 8.h),
                    // المسافة
                    ShimmerContainer(
                      width: 40.w,
                      height: 12.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ],
                ),
                SizedBox(width: 8.w),
                // أزرار الإجراءات
                ShimmerContainer(
                  width: 24.w,
                  height: 24.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
