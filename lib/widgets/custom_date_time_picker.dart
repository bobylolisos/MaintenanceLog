import 'package:flutter/material.dart';
import 'package:maintenance_log/extensions/date_time_extensions.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/widgets/custom_text_form_field.dart';

class CustomDateTimePicker extends StatelessWidget {
  final String label;
  final TextEditingController textController;
  const CustomDateTimePicker(this.label, this.textController, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Stack(
        children: [
          CustomTextFormField(
            label: label,
            textController: textController,
            readOnly: true,
          ),
          Row(
            children: [
              Expanded(child: const SizedBox()),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                      context: context,
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: colorBlue,
                              onPrimary: colorGold,
                              onSurface: colorBlue,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: colorBlue,
                              ),
                            ),
                          ),
                          child: MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child ?? const SizedBox(),
                          ),
                        );
                      },
                      cancelText: 'Avbryt',
                      confirmText: 'Ok',
                      fieldLabelText: '',
                      helpText: '',
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      initialDate: textController.text.isNotEmpty
                          ? DateTime.parse(textController.text)
                          : DateTime.now(),
                      firstDate: DateTime(1900, 01, 01),
                      lastDate: DateTime.now().add(const Duration(days: 1000)));
                  if (date != null) {
                    // ignore: use_build_context_synchronously
                    final TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: colorGold,
                              onPrimary: colorBlue,
                              onSurface: colorBlue,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: colorBlue,
                              ),
                            ),
                          ),
                          child: MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child ?? const SizedBox(),
                          ),
                        );
                      },
                      cancelText: 'Avbryt',
                      confirmText: 'Ok',
                      helpText: '',
                      initialEntryMode: TimePickerEntryMode.dialOnly,
                      initialTime: textController.text.isNotEmpty
                          ? TimeOfDay.fromDateTime(
                              DateTime.parse(textController.text))
                          : TimeOfDay.fromDateTime(DateTime.now()),
                    );
                    if (selectedTime != null) {
                      textController.text = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      ).toDateAndTime();
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(right: 10),
                  height: 60,
                  alignment: Alignment.centerRight,
                  child: Icon(
                    size: 30,
                    Icons.calendar_month,
                    color: colorBlue,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
