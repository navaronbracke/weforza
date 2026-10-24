/// @docImport 'package:weforza/database/rides.dart';
library;

import 'package:flutter/widgets.dart' show BuildContext, Localizations;
import 'package:intl/intl.dart' show DateFormat;

enum DateFormatPattern {
  /// The long date formatting pattern for [Rides.date].
  long('EEEE d MMMM yyyy'),

  /// The short date formatting pattern for [Rides.date].
  short('EEE d MMM yyyy');

  const new(this.value);

  final String value;
}

extension DayMonthYear on DateTime {
  /// Convert this date into a day-month-year string.
  String get asDayMonthYear => '$day-$month-$year';

  /// Format this [DateTime] to a given [pattern].
  String formatWithPattern(BuildContext context, {DateFormatPattern pattern = .short}) {
    return DateFormat(pattern.value, Localizations.localeOf(context).languageCode).format(this);
  }
}
