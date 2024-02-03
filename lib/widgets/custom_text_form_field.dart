import 'package:flutter/material.dart';
import 'package:maintenance_log/resources/colors.dart';

class CustomTextFormField extends StatefulWidget {
  final String? label;
  final TextEditingController? textController;
  final int? maxLength;
  final FormFieldValidator<String>? validator;

  const CustomTextFormField({
    this.label,
    this.textController,
    this.maxLength,
    this.validator,
    super.key,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late ValueNotifier<int> textChangedNotifier;
  var textFormFieldKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    textChangedNotifier = ValueNotifier(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Stack(
        children: [
          TextFormField(
            key: textFormFieldKey,
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
              labelText: widget.label ?? '',
              labelStyle: TextStyle(color: colorBlue),
            ),
            controller: widget.textController,
            maxLength: widget.maxLength,
            onChanged: (value) {
              textFormFieldKey.currentState?.validate();
              textChangedNotifier.value = textChangedNotifier.value + 1;
            },
            validator: widget.validator,
          ),
          widget.textController != null && widget.maxLength != null
              ? Container(
                  height: 60,
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: textChangedNotifier,
                      builder: (context, value, child) {
                        return Text(
                          '${widget.textController!.text.length}/${widget.maxLength!}',
                          style: TextStyle(color: colorBlue, fontSize: 12),
                        );
                      },
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    textChangedNotifier.dispose();
    super.dispose();
  }
}
