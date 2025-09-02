import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

/// [McDropDownBtn] is a customizable dropdown button widget that supports both searchable and non-searchable dropdowns.
/// It allows for customization of the dropdown's appearance, including color, border radius, and padding,
/// and supports callbacks for item selection changes.
class McDropDownBtn<T> extends StatelessWidget {
  final String title;
  final String? titleEmpty;

  final T? model;
  final List<T> list;
  final bool isSearch;
  final Color color;
  final double radius;
  final BoxBorder? closedBorder;
  final BoxBorder? expandedBorder;
  final TextStyle? headerStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final TextStyle? listItemStyle;
  final TextStyle? noResultFoundStyle;
  final EdgeInsets? closedHeaderPadding;
  final SingleSelectController<T>? controller;
  final void Function(T?)? onChange;

  /// The [McDropDownBtn] constructor allows you to specify various properties for the dropdown button.
  ///
  /// [title] is the hint text displayed when the dropdown is closed.
  ///
  /// [model] is the initially selected item in the dropdown.
  ///
  /// [list] is the list of items to be displayed in the dropdown.
  ///
  /// [isSearch] determines whether the dropdown should support searching for items.
  ///
  /// [color] sets the background color of the dropdown when closed.
  ///
  /// [radius] specifies the border radius of the dropdown.
  ///
  /// [closedHeaderPadding] defines the padding around the closed dropdown header.
  ///
  /// [controller] allows for programmatic control of the dropdown selection.
  ///
  /// [onChange] is a callback function that is called when an item is selected from the dropdown.
  const McDropDownBtn(
      {super.key,
      required this.title,
      required this.list,
      this.titleEmpty,
      this.onChange,
      this.isSearch = true,
      this.radius = 15,
      this.controller,
      this.closedHeaderPadding =
          const EdgeInsets.only(bottom: 15, top: 15, left: 25, right: 25),
      this.color = Colors.white,
      this.model,
      this.errorStyle,
      this.headerStyle,
      this.closedBorder,
      this.expandedBorder,
      this.hintStyle,
      this.listItemStyle,
      this.noResultFoundStyle});

  @override
  Widget build(BuildContext context) {
    return isSearch
        ? CustomDropdown<T>.search(
            closedHeaderPadding: closedHeaderPadding,
            hintText: title,
            items: list,
            decoration: CustomDropdownDecoration(
                closedBorder: closedBorder,
                expandedFillColor: color,
                listItemDecoration:
                    ListItemDecoration(selectedColor: Colors.grey.shade300),
                expandedBorder: expandedBorder,
                headerStyle:
                    headerStyle ?? Theme.of(context).textTheme.titleLarge,
                hintStyle: hintStyle ?? Theme.of(context).textTheme.titleLarge,
                errorStyle:
                    errorStyle ?? Theme.of(context).textTheme.titleLarge,
                listItemStyle:
                    listItemStyle ?? Theme.of(context).textTheme.titleLarge,
                noResultFoundStyle: noResultFoundStyle ??
                    Theme.of(context).textTheme.titleLarge,
                closedFillColor: color,
                closedBorderRadius: BorderRadius.circular(radius)),
            initialItem: model,
            controller: controller,
            excludeSelected: false,
            onChanged: onChange,
          )
        : CustomDropdown<T>(
            closedHeaderPadding: closedHeaderPadding,
            hintText: title,
            items: list,
            noResultFoundText: titleEmpty,
            hideSelectedFieldWhenExpanded: true,
            decoration: CustomDropdownDecoration(
                closedBorder: closedBorder,
                expandedFillColor: color,
                listItemDecoration:
                    ListItemDecoration(selectedColor: Colors.grey.shade300),
                expandedBorder: expandedBorder,
                headerStyle:
                    headerStyle ?? Theme.of(context).textTheme.titleLarge,
                hintStyle: hintStyle ?? Theme.of(context).textTheme.titleLarge,
                errorStyle:
                    errorStyle ?? Theme.of(context).textTheme.titleLarge,
                listItemStyle:
                    listItemStyle ?? Theme.of(context).textTheme.titleLarge,
                noResultFoundStyle: noResultFoundStyle ??
                    Theme.of(context).textTheme.titleLarge,
                closedFillColor: color,
                closedBorderRadius: BorderRadius.circular(radius)),
            initialItem: model,
            controller: controller,
            excludeSelected: false,
            onChanged: onChange,
          );
  }
}
