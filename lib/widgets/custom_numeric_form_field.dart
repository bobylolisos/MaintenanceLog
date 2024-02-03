import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maintenance_log/resources/colors.dart';

class CustomNumericFormField extends StatelessWidget {
  const CustomNumericFormField({
    super.key,
    required this.label,
    this.controller,
    this.value,
    this.onChanged,
    this.allowDecimal = false,
  });

  final TextEditingController? controller;
  final String? value;
  final String label;
  final Function? onChanged;
  final bool allowDecimal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
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
        onChanged: onChanged as void Function(String)?,
        keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(_getRegexString())),
          TextInputFormatter.withFunction(
            (oldValue, newValue) => newValue.copyWith(
              text: newValue.text.replaceAll('.', ','),
            ),
          ),
        ],
      ),
    );
  }

  String _getRegexString() =>
      allowDecimal ? r'[0-9]+[,.]{0,1}[0-9]*' : r'[0-9]';
}
