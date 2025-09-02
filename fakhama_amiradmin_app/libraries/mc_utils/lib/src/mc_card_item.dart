import 'package:flutter/material.dart';

/// [McCardItem] is a customizable card widget that can contain a child widget and supports various styling options.
/// It allows for customization of width, height, border color, shadow visibility, padding, margin, and border radius.
class McCardItem extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? widthBorder;

  final double? hight;
  final BorderRadius? radius;
  final Color? colorBorder;
  final bool showShdow;
  final bool withoutColor;

  final Color? color;
  final Function()? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;

  /// The [McCardItem] constructor allows you to specify various properties for the card widget.
  ///
  /// [child] is the widget displayed inside the card.
  ///
  /// [width] defines the width of the card.
  ///
  /// [hight] defines the height of the card.
  ///
  /// [colorBorder] sets the color of the card's border. If null, no border is displayed.
  ///
  /// [showShdow] determines whether the card should display a shadow.
  ///
  /// [padding] specifies the padding inside the card.
  ///
  /// [margin] sets the margin outside the card.
  ///
  /// [radius] defines the border radius of the card's corners.
  ///
  /// [alignment] specifies the alignment of the child widget inside the card.
  const McCardItem({
    super.key,
    this.child,
    this.width,
    this.widthBorder,
    this.hight,
    this.colorBorder,
    this.padding,
    this.margin,
    this.showShdow = true,
    this.withoutColor = false,
    this.radius,
    this.alignment,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          padding: padding ?? const EdgeInsets.all(15),
          width: width,
          height: hight,
          margin: margin ?? const EdgeInsets.all(0.50),
          alignment: alignment,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: color ?? (!withoutColor ? Colors.white : null),
            border: colorBorder != null
                ? Border.all(width: widthBorder ?? 2, color: colorBorder!)
                : null,
            borderRadius: radius ?? const BorderRadius.all(Radius.circular(10)),
            boxShadow: showShdow
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0.0, 1.5),
                      blurRadius: 7.0,
                    )
                  ]
                : [],
          ),
          child: child,
        ));
  }
}
