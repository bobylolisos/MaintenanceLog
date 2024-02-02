import 'package:flutter/material.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/views/admin/widgets/text_input_decoration.dart';

class CustomDateTimePicker extends StatelessWidget {
  final String label;
  final TextEditingController textController;
  const CustomDateTimePicker(this.label, this.textController, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Stack(
        children: [
          TextFormField(
            decoration: textInputDecoration(label),
            controller: textController,
            onChanged: (value) => {},
            validator: (value) => null,
          ),
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
                        child: child ?? Container(),
                      ),
                    );
                  },
                  cancelText: 'Avbryt',
                  confirmText: 'Ok',
                  fieldLabelText: '',
                  helpText: '',
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 100)),
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
                        child: child ?? Container(),
                      ),
                    );
                  },
                  cancelText: 'Avbryt',
                  confirmText: 'Ok',
                  helpText: '',
                  initialEntryMode: TimePickerEntryMode.dialOnly,
                  initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                );
                if (selectedTime != null) {
                  textController.text = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  ).toString().substring(0, 16);
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
          )
        ],
      ),
    );
  }
}
