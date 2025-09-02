// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

class RefreshEmptyWidget extends StatelessWidget {
  final Future Function() onRefresh;
  final String emptyText;
  final String? value;

  final IconData? icon;
  final ScrollController? controller;
  const RefreshEmptyWidget({
    super.key,
    required this.onRefresh,
    required this.emptyText,
    this.icon,
    this.value,
    this.controller,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: controller,
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Container(
                width: Get.width,
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (icon != null)
                        Icon(
                          icon,
                          size: 70.sp,
                          color: colorScheme.onSurface.withOpacity(0.3),
                        ),
                      SizedBox(height: 15.h),
                      McText(
                        txt: emptyText.tr,
                        fontSize: 16.sp,
                        blod: true,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      SizedBox(height: 5.h),
                      if (value != null)
                        McText(
                          txt: value!,
                          fontSize: 14.sp,
                          blod: true,
                          color: colorScheme.onSurface.withOpacity(0.4),
                        ),
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
