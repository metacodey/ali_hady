import 'package:flutter/material.dart';

/// [McText] is a customizable text widget that allows for various text styling
/// options, including font size, color, boldness, line limit, and text alignment.
/// It also includes an option to show only the first 5 words of the text.
class McText extends StatelessWidget {
  final double? fontSize;
  final Color? color;
  final bool blod;
  final int? line;
  final String? fontFamily;
  final TextAlign? txtAlign;
  final bool show5Words;
  final String txt;
  final TextDecoration? decoration;
  final EdgeInsetsGeometry? padding;

  /// The [McText] constructor allows you to specify the text and its styling options.
  ///
  /// [fontSize] sets the size of the text.
  ///
  /// [color] defines the color of the text.
  ///
  /// [blod] makes the text bold if set to true.
  ///
  /// [line] limits the number of lines the text can occupy.
  ///
  /// [fontFamily] sets the font family for the text.
  ///
  /// [txtAlign] allows you to align the text.
  ///
  /// [show5Words] when set to true, truncates the text to show only the first 5 words.
  ///
  /// [txt] is the text content to be displayed.
  ///
  /// [padding] is the padding of the text content .
  const McText({
    Key? key,
    this.fontSize,
    this.decoration,
    this.color,
    this.blod = false,
    this.line,
    this.fontFamily,
    this.txtAlign,
    this.show5Words = false,
    required this.txt,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract the first 5 words from the text
    List<String> words = txt.split(' ');
    String truncatedTxt =
        words.length > 5 ? '${words.sublist(0, 5).join(' ')}...' : txt;

    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: Text(
        show5Words ? truncatedTxt : txt,
        maxLines: line,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        textAlign: txtAlign,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          decoration: decoration,
          fontFamily:
              fontFamily ?? Theme.of(context).textTheme.titleLarge?.fontFamily,
          overflow: TextOverflow.ellipsis,
          fontWeight: blod ? FontWeight.bold : null,
        ),
      ),
    );
  }
}
