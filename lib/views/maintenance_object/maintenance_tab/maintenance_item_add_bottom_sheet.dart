import 'package:flutter/material.dart';
import 'package:maintenance_log/extensions/date_time_extensions.dart';
import 'package:maintenance_log/models/maintenance.dart';
import 'package:maintenance_log/models/maintenance_item.dart';
import 'package:maintenance_log/models/meter_type.dart';
import 'package:maintenance_log/widgets/bls_bottom_sheet.dart';
import 'package:maintenance_log/widgets/custom_date_time_picker.dart';
import 'package:maintenance_log/widgets/custom_text_form_field.dart';
import 'package:maintenance_log/widgets/custom_numeric_form_field.dart';

class MaintenanceItemAddBottomSheet extends StatefulWidget {
  final Maintenance maintenance;
  const MaintenanceItemAddBottomSheet({required this.maintenance, super.key});

  @override
  State<MaintenanceItemAddBottomSheet> createState() =>
      _MaintenanceItemAddBottomSheetState();
}

class _MaintenanceItemAddBottomSheetState
    extends State<MaintenanceItemAddBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final headerController = TextEditingController();
  final meterController = TextEditingController();
  final costController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void initState() {
    dateController.text = DateTime.now().toDateAndTime();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlsBottomSheet(
      title: 'Lägg till ny post',
      okText: 'Spara',
      cancelText: 'Avbryt',
      onOkPressed: () {
        if (formKey.currentState?.validate() == true) {
          final maintenanceItem = MaintenanceItem.createNew(
            maintenanceId: widget.maintenance.id,
            header: headerController.text.trim(),
            date: DateTime.parse(
              dateController.text.trim(),
            ),
            meterValue: meterController.text.trim().isNotEmpty
                ? int.parse(meterController.text.trim())
                : null,
            costs: costController.text.trim().isNotEmpty
                ? num.parse(costController.text.replaceAll(',', '.').trim())
                : 0,
            note: noteController.text.trim(),
          );

          Navigator.pop(context, maintenanceItem);
        }
      },
      onCancelPressed: () {
        Navigator.pop(context);
      },
      child: Form(
        key: formKey,
        child: Column(children: [
          SizedBox(
            // Needed for text in border to be visible when scroll is used
            height: 10,
          ),
          CustomDateTimePicker('Datum', dateController),
          CustomTextFormField(
            label: 'Rubrik',
            textController: headerController,
            maxLength: 30,
            validator: (value) =>
                headerController.text.isEmpty ? 'En rubrik måste anges' : null,
          ),
          widget.maintenance.meterType == MeterType.odometer
              ? CustomNumericFormField(
                  label: 'Mätarvärde (km)',
                  allowDecimal: false,
                  controller: meterController,
                )
              : Container(),
          widget.maintenance.meterType == MeterType.hourmeter
              ? CustomNumericFormField(
                  label: 'Mätarvärde (timmar)',
                  allowDecimal: false,
                  controller: meterController,
                )
              : Container(),
          CustomNumericFormField(
            label: 'Utgift (kr)',
            allowDecimal: true,
            controller: costController,
          ),
          CustomTextFormField(
            label: 'Notering',
            textController: noteController,
            minLines: 3,
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    headerController.dispose();
    meterController.dispose();
    costController.dispose();
    noteController.dispose();

    super.dispose();
  }
}