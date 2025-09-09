import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart' as mc_utils;

/// [McStepLine] is a widget that displays a progress indicator with steps and a title.
/// It allows customization of the step count, current step, title, line color, font size, and font color.
class McStepLine extends StatelessWidget {
  final int countStep;
  final int step;
  final String title;
  final Color colorLine;
  final double fontSize;
  final Color colorFont;

  /// The [McStepLine] constructor allows you to specify the properties of the step indicator.
  ///
  /// [countStep] defines the total number of steps in the progress indicator.
  ///
  /// [step] specifies the current step that should be highlighted.
  ///
  /// [title] is the title displayed next to the progress indicator.
  ///
  /// [colorLine] sets the color of the progress indicator line.
  ///
  /// [fontSize] specifies the size of the text for the title and step count.
  ///
  /// [colorFont] defines the color of the text for the title and step count.
  const McStepLine({
    Key? key,
    this.countStep = 6,
    this.step = 1,
    this.colorFont = const Color(0xFF252B5C),
    this.colorLine = const Color(0xFF252B5C),
    this.fontSize = 14,
    this.title = 'Step',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Creates the progress indicator with steps.
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              // Loops through the steps to create the progress indicator.
              for (int i = 1; i <= countStep; i++)
                Opacity(
                  // Adjusts opacity based on whether the step is completed.
                  opacity: step >= i ? 1 : 0.5,
                  child: Container(
                    color: colorLine,
                    width: 25,
                    height: 5.5,
                  ),
                )
            ],
          ),
        ),
        const SizedBox(width: 10),
        // Displays the title using the McText widget.
        mc_utils.McText(
          txt: title,
          fontSize: fontSize,
          color: colorFont,
          show5Words: true,
          line: 1,
          blod: true,
        ),
        // Displays the current step out of the total steps.
        mc_utils.McText(
          txt: " $step/$countStep ",
          fontSize: fontSize,
          color: colorFont,
          show5Words: true,
          blod: true,
          line: 1,
        ),
      ],
    );
  }
}
