import 'package:flutter/material.dart';
import 'package:maintenance_log/resources/colors.dart';

InputDecoration textInputDecoration(String labelText) {
  return InputDecoration(
    counterStyle: TextStyle(color: colorBlue, fontSize: 12),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorBlue),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorBlue),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
    labelText: labelText,
    labelStyle: TextStyle(color: colorBlue),
  );
}
