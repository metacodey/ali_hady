import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

import '../../colors.dart';

class DropDown<T> extends StatelessWidget {
  final List<T> list;
  final String title;
  final String? titleEmpty;

  final bool isSearch;
  final EdgeInsets padding;
  final double radius;
  final T? model;
  final Border? closedBorder;
  final Border? expandedBorder;
  final TextStyle? headerStyle;
  final TextStyle? errorStyle;
  final TextStyle? hintStyle;
  final TextStyle? listItemStyle;
  final TextStyle? noResultFoundStyle;
  final ValueChanged<T?>? onChange;
  const DropDown({
    super.key,
    required this.list,
    required this.title,
    this.titleEmpty,
    this.isSearch = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    this.radius = 5,
    this.model,
    this.closedBorder,
    this.expandedBorder,
    this.headerStyle,
    this.errorStyle,
    this.hintStyle,
    this.listItemStyle,
    this.noResultFoundStyle,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return McDropDownBtn<T>(
      list: list,
      title: title.tr,
      isSearch: isSearch,
      closedHeaderPadding: padding,
      radius: radius,
      model: model,
      titleEmpty: titleEmpty,
      color: Theme.of(context).focusColor,
      closedBorder: closedBorder ??
          Border.all(color: AppColors.greenBlueVeryLight, width: 2),
      expandedBorder: expandedBorder ??
          Border.all(color: AppColors.greenBlueVeryLight, width: 2),
      headerStyle: headerStyle ??
          TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color),
      errorStyle: errorStyle ??
          TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color),
      hintStyle: hintStyle ??
          TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color),
      listItemStyle: listItemStyle ??
          TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color),
      noResultFoundStyle: noResultFoundStyle ??
          TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color),
      onChange: onChange,
    );
  }
}
