import 'package:flutter/material.dart';

extension TextEditingControllerExtensions on TextEditingController {
  String toTrimmedString() {
    return text.trim();
  }

  DateTime toDateTime() {
    return DateTime.parse(text.trim());
  }

  num toNumeric({num defaultValue = 0}) {
    var trimmedText = text.replaceAll(',', '.').trim();

    if (trimmedText.isEmpty) {
      return defaultValue;
    }

    return num.parse(trimmedText);
  }

  int toInt({int defaultValue = 0}) {
    var trimmedText = text.trim();

    if (trimmedText.isEmpty) {
      return defaultValue;
    }

    return int.parse(trimmedText);
  }

  int? toNullableInt() {
    if (text.trim().isNotEmpty) {
      return int.parse(text.trim());
    }

    return null;
  }
}
