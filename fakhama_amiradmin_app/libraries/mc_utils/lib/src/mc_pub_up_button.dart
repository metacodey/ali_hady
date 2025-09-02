import 'package:flutter/material.dart';

/// [McPopUpMenChat] is a customizable popup menu button widget that displays a list of menu items.
/// It allows for various styling options, such as shape, color, and animation style, and supports
/// custom icons, padding, and behavior configurations.
class McPopUpMenChat extends StatelessWidget {
  final List<PopupMenuEntry> menuList;
  final Widget child;
  final ShapeBorder? shape;
  final Color? color;
  final PopupMenuPosition? position;
  final Offset? offset;
  final Function()? onCanceled;
  final dynamic initialValue;
  final double? elevation;
  final bool enabled;
  final Widget? icon;
  final Color? iconColor;
  final Color? surfaceTintColor;
  final String? semanticLabel;
  final bool useRootNavigator;
  final BoxConstraints? constraints;
  final Clip clipBehavior = Clip.none;
  final RouteSettings? routeSettings;
  final AnimationStyle? popUpAnimationStyle;
  final Function()? onOpened;
  final Function(dynamic)? onSelected;
  final EdgeInsetsGeometry padding = const EdgeInsets.all(8.0);
  final ButtonStyle? style;
  final Color? shadowColor;
  final double? splashRadius;
  final double? iconSize;

  /// The [McPopUpMenChat] constructor allows you to specify various properties for the popup menu button.
  ///
  /// [menuList] is the list of [PopupMenuEntry] items to be displayed in the popup menu.
  ///
  /// [child] is the widget that triggers the popup menu when pressed.
  ///
  /// [shape] sets the shape of the popup menu's background.
  ///
  /// [color] defines the background color of the popup menu.
  ///
  /// [position] determines where the popup menu should be displayed relative to the [child].
  ///
  /// [offset] specifies the offset of the popup menu from its position.
  ///
  /// [onCanceled] is a callback function that is called when the menu is dismissed without selection.
  ///
  /// [elevation] sets the elevation of the popup menu, affecting its shadow.
  ///
  /// [surfaceTintColor] defines the tint color applied to the surface of the popup menu.
  ///
  /// [semanticLabel] provides a label for accessibility purposes.
  ///
  /// [useRootNavigator] determines whether the popup menu uses the root navigator.
  ///
  /// [routeSettings] contains route settings for the popup menu.
  ///
  /// [popUpAnimationStyle] defines the animation style for the popup menu.
  ///
  /// [initialValue] specifies the initial value of the popup menu.
  ///
  /// [constraints] sets constraints on the popup menu's size.
  ///
  /// [enabled] controls whether the popup menu is enabled or disabled.
  ///
  /// [icon] is the widget displayed as the trigger for the popup menu.
  ///
  /// [iconColor] defines the color of the trigger icon.
  ///
  /// [onOpened] is a callback function that is called when the popup menu is opened.
  ///
  /// [onSelected] is a callback function that is called when a menu item is selected.
  ///
  /// [style] allows for additional styling of the popup menu button.
  ///
  /// [shadowColor] sets the color of the shadow cast by the popup menu.
  ///
  /// [splashRadius] defines the radius of the splash effect when the trigger icon is pressed.
  ///
  /// [iconSize] specifies the size of the trigger icon.
  const McPopUpMenChat({
    Key? key,
    required this.menuList,
    required this.child,
    this.shape,
    this.color,
    this.offset,
    this.position,
    this.onCanceled,
    this.elevation,
    this.surfaceTintColor,
    this.semanticLabel,
    this.useRootNavigator = false,
    this.routeSettings,
    this.popUpAnimationStyle,
    this.initialValue,
    this.constraints,
    this.enabled = true,
    this.icon,
    this.iconColor,
    this.onOpened,
    this.onSelected,
    this.style,
    this.shadowColor,
    this.splashRadius,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onCanceled: onCanceled,
      constraints: constraints,
      enabled: enabled,
      icon: icon,
      iconColor: iconColor,
      iconSize: iconSize,
      initialValue: initialValue,
      onOpened: onOpened,
      onSelected: onSelected,
      padding: padding,
      routeSettings: routeSettings,
      style: style,
      popUpAnimationStyle: popUpAnimationStyle,
      useRootNavigator: useRootNavigator,
      elevation: elevation,
      shadowColor: shadowColor,
      splashRadius: splashRadius,
      clipBehavior: clipBehavior,
      surfaceTintColor: surfaceTintColor,
      position: position ?? PopupMenuPosition.under,
      offset: offset ?? const Offset(-0, 10),
      color: color ?? Theme.of(context).colorScheme.surface,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
      itemBuilder: ((context) => menuList),
      child: child,
    );
  }
}
