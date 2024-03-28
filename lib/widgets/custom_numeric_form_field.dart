import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maintenance_log/resources/colors.dart';

class CustomNumericFormField extends StatelessWidget {
  const CustomNumericFormField({
    super.key,
    required this.label,
    // this.formKey,
    this.controller,
    this.value,
    this.onChanged,
    this.validator,
    this.allowDecimal = false,
  });

  // final GlobalKey<FormState>? formKey;
  final TextEditingController? controller;
  final String? value;
  final String label;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool allowDecimal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        // key: formKey,
        controller: controller,
        style: TextStyle(color: colorBlue),
        decoration: InputDecoration(
          counterText: '',
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
          labelText: label,
          labelStyle: TextStyle(color: colorBlue),
        ),
        initialValue: value,
        onChanged: onChanged,
        keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(_getRegexString())),
          // TextInputFormatter.withFunction(
          //   (oldValue, newValue) => newValue.copyWith(
          //     text: newValue.text.replaceAll('.', ','),
          //   ),
          // ),
        ],
        validator: validator,
      ),
    );
  }

  String _getRegexString() => allowDecimal ? r'^\d+\.?\d{0,2}' : r'[0-9]';
}
