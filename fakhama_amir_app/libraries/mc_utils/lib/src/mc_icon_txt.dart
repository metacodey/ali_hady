import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';

/// [McIconTxt] is a widget that combines an icon with an optional text label.
/// It supports customization of the icon's appearance, background color, and text style,
/// and provides an onPress callback for user interaction.
class McIconTxt extends StatelessWidget {
  final IconData icons;
  final Color? bgColor;
  final Color icColor;
  final Color? tiColor;
  final String? text;
  final Function()? onPress;
  final bool blod;
  final bool isVertical;
  final bool isRight;
  final EdgeInsetsGeometry padding;
  final TextAlign? aligen;
  final bool enabeOverflow;
  final double sizeIcon;
  final double? rudisIcon;
  final double sizeTitle;
  final int line;

  /// The [McIconTxt] constructor allows you to specify various properties for the icon and text widget.
  ///
  /// [icons] specifies the icon to be displayed.
  ///
  /// [bgColor] defines the background color of the circle surrounding the icon.
  ///
  /// [icColor] sets the color of the icon.
  ///
  /// [tiColor] defines the color of the text.
  ///
  /// [text] is the optional text to be displayed below the icon.
  ///
  /// [onPress] is a callback function that is called when the widget is tapped.
  ///
  /// [blod] makes the text bold if set to true.
  ///
  /// [sizeIcon] specifies the size of the icon.
  ///
  /// [rudisIcon] sets the radius of the circle surrounding the icon.
  ///
  /// [sizeTitle] specifies the font size of the text.
  const McIconTxt({
    Key? key,
    required this.icons,
    this.bgColor,
    this.text,
    this.enabeOverflow = false,
    this.blod = false,
    this.icColor = Colors.white,
    this.tiColor,
    this.sizeTitle = 12,
    this.rudisIcon,
    this.aligen,
    this.sizeIcon = 21,
    this.isVertical = false,
    this.isRight = false,
    this.onPress,
    this.line = 1,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: padding,
        child: isVertical
            ? itemRows()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Displays the icon inside a circle with optional background color.
                  if (rudisIcon != null)
                    CircleAvatar(
                      radius: rudisIcon,
                      backgroundColor: bgColor,
                      child: Icon(
                        icons,
                        size: sizeIcon,
                        color: icColor,
                      ),
                    )
                  else
                    Icon(
                      icons,
                      size: sizeIcon,
                      color: icColor,
                    ),
                  if (text != null)
                    const SizedBox(
                      height: 5,
                    ),
                  // Displays the optional text below the icon, if provided.
                  if (text != null)
                    McText(
                      txt: text!,
                      txtAlign: aligen,
                      fontSize: sizeTitle,
                      color: tiColor,
                      blod: blod,
                    ),
                ],
              ),
      ),
    );
  }

  Widget itemRows() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Displays the optional text below the icon, if provided.
        if (text != null && isRight)
          Expanded(
            child: McText(
              txt: text!,
              blod: blod,
              color: tiColor,
              fontSize: sizeTitle,
              line: line,
            ),
          ),
        if (text != null && isRight)
          const SizedBox(
            width: 5,
          ),
        // Displays the icon inside a circle with optional background color.
        if (rudisIcon != null)
          CircleAvatar(
            radius: rudisIcon,
            backgroundColor: bgColor,
            child: Icon(
              icons,
              size: sizeIcon,
              color: icColor,
            ),
          ),
        Icon(
          icons,
          size: sizeIcon,
          color: icColor,
        ),
        if (text != null && !isRight)
          const SizedBox(
            width: 5,
          ),
        // Displays the optional text below the icon, if provided.
        if (text != null && !isRight)
          Expanded(
            child: McText(
              txt: text!,
              blod: blod,
              color: tiColor,
              fontSize: sizeTitle,
              line: line,
            ),
          )
      ],
    );
  }
}
