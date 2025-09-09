import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mc_utils/mc_utils.dart';

class ShimmerWidget extends StatelessWidget {
  final Widget child;
  final bool enabled;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerWidget({
    super.key,
    required this.child,
    this.enabled = true,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    final isDark = Get.isDarkMode;
    
    return Shimmer.fromColors(
      baseColor: baseColor ?? 
          (isDark ? Colors.grey[800]! : Colors.grey[300]!),
      highlightColor: highlightColor ?? 
          (isDark ? Colors.grey[700]! : Colors.grey[100]!),
      child: child,
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[300],
        borderRadius: borderRadius ?? BorderRadius.circular(4.r),
      ),
    );
  }
}

class ShimmerLine extends StatelessWidget {
  final double? width;
  final double height;
  final EdgeInsetsGeometry? margin;

  const ShimmerLine({
    super.key,
    this.width,
    this.height = 12,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      width: width,
      height: height.h,
      margin: margin,
      borderRadius: BorderRadius.circular(6.r),
    );
  }
}

class ShimmerCircle extends StatelessWidget {
  final double size;
  final EdgeInsetsGeometry? margin;

  const ShimmerCircle({
    super.key,
    required this.size,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    
    return Container(
      width: size,
      height: size,
      margin: margin,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }
}