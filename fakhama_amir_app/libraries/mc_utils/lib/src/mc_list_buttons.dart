import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';
import 'package:mc_utils/src/controller/list_buttons_controller.dart';

/// [McListButtons] is a widget that displays a list of buttons, where each button represents an item in the list.
/// It supports customization of button appearance, including colors, font size, and padding, and allows for horizontal or vertical scrolling.
class McListButtons extends StatelessWidget {
  final List<String> list;
  final Color colorSelected;
  final Color colorBtn;
  final BorderRadius? radius;
  final Color fontColor;
  final Color fontColorSelected;
  final double sizeFont;
  final Color colorBorder;
  final bool isHorizontal;
  final EdgeInsetsGeometry? paddingContect;
  final EdgeInsetsGeometry? paddingBtn;
  final Function(int) onSelected;

  /// The [McListButtons] constructor allows you to specify various properties for the button list.
  ///
  /// [list] is the list of button labels to be displayed.
  ///
  /// [onSelected] is a callback function that is called when a button is selected, providing the index of the selected item.
  ///
  /// [colorBtn] defines the background color of the buttons when not selected.
  ///
  /// [fontColor] sets the color of the text on the buttons when not selected.
  ///
  /// [fontColorSelected] defines the color of the text on the selected button.
  ///
  /// [sizeFont] specifies the font size of the button text.
  ///
  /// [radius] sets the corner radius of the buttons.
  ///
  /// [colorSelected] defines the background color of the selected button.
  ///
  /// [paddingContect] specifies the padding around each button.
  ///
  /// [paddingBtn] sets the padding inside each button.
  ///
  /// [colorBorder] defines the color of the button border.
  ///
  /// [isHorizontal] determines whether the buttons should be arranged horizontally or vertically.
  const McListButtons({
    super.key,
    required this.list,
    required this.onSelected,
    this.colorBtn = Colors.white,
    this.fontColor = const Color(0xFF252B5C),
    this.fontColorSelected = Colors.white,
    this.sizeFont = 14,
    this.radius,
    this.colorSelected = const Color(0xFF252B5C),
    this.paddingContect,
    this.paddingBtn,
    this.colorBorder = const Color(0xFF252B5C),
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: isHorizontal ? Axis.vertical : Axis.horizontal,
        child: isHorizontal
            ? Column(
                children:
                    List.generate(list.length, (index) => item(index)).toList(),
              )
            : Row(
                children:
                    List.generate(list.length, (index) => item(index)).toList(),
              ),
      ),
    );
  }

  /// Creates a button widget for each item in the list.
  ///
  /// [index] specifies the index of the item in the list.
  Widget item(int index) {
    var tag = list.toString();

    return Padding(
      padding: paddingContect ?? const EdgeInsets.all(5),
      child: GetBuilder<ListButtonsController>(
        init: Get.put(ListButtonsController(), tag: tag),
        tag: tag,
        builder: (controller) {
          return McButton(
            txt: list[index],
            colorBtn:
                controller.active.value == index ? colorSelected : colorBtn,
            raudis: radius,
            color: controller.active.value == index
                ? fontColorSelected
                : fontColor,
            colorBorder: colorBorder,
            show5Words: true,
            blod: true,
            padding: paddingBtn,
            line: 1,
            fontSize: sizeFont,
            onTap: () => controller.changeStateBtnMenu(
              selected: index,
              onSelected: onSelected,
            ),
          );
        },
      ),
    );
  }
}
