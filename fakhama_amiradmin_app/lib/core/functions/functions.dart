import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';

import '../../language/controller/localization_controller.dart';
import '../constants/utils/widgets/snak_bar.dart';

String formatLargeNumber(int number) {
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}K';
  } else {
    return number.toString();
  }
}

Future<DateTime?> pickerDateTime(
    BuildContext context, DateTime initDateTime) async {
  try {
    final datePicker = McDateAndTimePicker();
    await datePicker.selectDateAndTime(
      materialDatePickerFirstDate: DateTime(2000),
      materialDatePickerInitialDate: initDateTime,
      materialDatePickerInitialEntryMode: DatePickerEntryMode.calendar,
      materialDatePickerLastDate: DateTime(2099),
      materialInitialTime: TimeOfDay.now(),
      materialTimePickerUse24hrFormat: false,
      materialTimePickerInitialEntryMode: TimePickerEntryMode.dial,
      preferredDateFormat: DateFormat.yMEd(),
      materialDatePickerLocale: Get.find<LocalizationController>().locale,
      cupertinoDatePickerMaximumDate: DateTime(2099),
      cupertinoDatePickerMinimumDate: DateTime(1990),
      cupertinoDatePickerBackgroundColor: Colors.white,
      cupertinoDatePickerMaximumYear: 2099,
      cupertinoDatePickerMinimumYear: 1990,
      cupertinoTimePickerUse24hFormat: false,
      cupertinoTimePickerMinuteInterval: 1,
      cupertinoDateInitialDateTime: initDateTime,
      context: context,
    );

    if (datePicker.selectedDate != null) {
      return datePicker.selectedDate;
    }
  } catch (e) {
    showSnakBar(
        title: e.toString(), msg: "date_selection_error".tr, color: Colors.red);
  }
  return null;
}
