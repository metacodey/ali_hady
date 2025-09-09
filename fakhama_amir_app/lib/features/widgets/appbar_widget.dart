import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mc_utils/mc_utils.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? children;
  final bool showWidget;
  final Color? color;
  final Widget? widget;
  final double? appBarWidth;
  final bool isCenter;
  final Function()? onTapWidget;
  final double spaceTitle;
  const AppbarWidget(
      {super.key,
      this.title,
      this.color,
      this.children,
      this.widget,
      this.onTapWidget,
      this.appBarWidth = 0.0,
      this.isCenter = false,
      this.spaceTitle = 20,
      this.showWidget = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color,
      leadingWidth: appBarWidth,
      titleSpacing: spaceTitle,
      title: title != null
          ? McText(
              txt: title!.tr,
              blod: true,
            )
          : null,
      leading: showWidget ? InkWell(onTap: onTapWidget, child: widget) : null,
      centerTitle: isCenter,
      actions: children ??
          [
            IconButton(
              icon: Icon(
                LucideIcons.settings,
                size: 25.sp,
              ),
              onPressed: () {
                Get.toNamed("/settings");
              },
            ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
