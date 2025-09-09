import 'package:flutter/material.dart';

/// [McTextFieldTheme] provides static methods for customizing text field decorations and box shadows.
///
/// This class offers utility methods to easily apply consistent styling to text fields throughout the application.
/// It includes methods for setting input field decorations and box shadows for a more polished look.
/// A utility class for customizing text field decorations and box shadows.
class McTextFieldTheme {
  /// Creates an [InputDecoration] with customizable properties for text fields.
  ///
  /// This method provides an easy way to apply consistent styling to text fields throughout the application.
  ///
  /// Parameters:
  /// - [lableText]: The label text to display in the text field. Defaults to an empty string.
  /// - [hintText]: The hint text to display when the field is empty. Defaults to an empty string.
  /// - [prefixIcon]: A widget to display before the input text (e.g., an icon). Defaults to null.
  /// - [fillColor]: The background color of the text field. Defaults to null.
  /// - [labelStyle]: The style of the label text. Defaults to null.
  /// - [hintStyle]: The style of the hint text. Defaults to null.
  /// - [suffixIcon]: A widget to display after the input text (e.g., an icon). Defaults to null.
  /// - [contentPadding]: Padding inside the text field. Defaults to `EdgeInsets.fromLTRB(20, 10, 20, 10)` if not provided.
  /// - [borderRadius]: The border radius of the text field. Defaults to a circular radius of 10.
  /// - [borderSide]: The border side for the text field. Defaults to a color of `Color.fromRGBO(2, 57, 88, 1)` with a width of 1.
  /// - [errorBorder]: The border side for the error state. Defaults to `Colors.red`.
  ///
  /// Returns:
  /// - An [InputDecoration] with the specified customization.
  static InputDecoration textInputDecoration({
    String? lableText,
    String hintText = "",
    Widget? prefixIcon,
    Color? fillColor,
    bool showFilColor = false,
    TextStyle? labelStyle,
    TextStyle? hintStyle,
    Widget? suffixIcon,
    EdgeInsetsGeometry? contentPadding,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(10)),
    BorderSide? borderSide,
    BorderSide? errorBorder,
  }) {
    borderSide ??=
        const BorderSide(color: Color.fromRGBO(2, 57, 88, 1), width: 1);
    errorBorder ??= const BorderSide(color: Colors.red, width: 2.0);
    return InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      fillColor: fillColor,
      labelStyle: labelStyle,
      hintStyle: hintStyle,
      labelText: lableText,
      hintText: hintText,
      filled: fillColor != null ? true : showFilColor,
      contentPadding:
          contentPadding ?? const EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(
        borderSide: borderSide,
        borderRadius: borderRadius,
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: borderSide, borderRadius: borderRadius),
      disabledBorder: OutlineInputBorder(
          borderSide: borderSide, borderRadius: borderRadius),
      errorBorder: OutlineInputBorder(
          borderRadius: borderRadius, borderSide: errorBorder),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius, borderSide: errorBorder),
    );
  }

  /// Creates a [BoxDecoration] with a shadow effect for UI elements.
  ///
  /// This method provides a white shadow with a blur radius of 20 and an offset of (0, 5) to add a subtle depth effect.
  ///
  /// Returns:
  /// - A [BoxDecoration] with the specified shadow properties.
  static BoxDecoration inputBoxDecorationShaddow() {
    return const BoxDecoration(boxShadow: [
      BoxShadow(
        color: Colors.white,
        blurRadius: 20,
        offset: Offset(0, 5),
      )
    ]);
  }
}
