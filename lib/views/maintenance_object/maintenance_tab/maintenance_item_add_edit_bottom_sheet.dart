import 'package:flutter/material.dart';
import 'package:maintenance_log/extensions/date_time_extensions.dart';
import 'package:maintenance_log/extensions/text_editing_controller_extensions.dart';
import 'package:maintenance_log/models/maintenance.dart';
import 'package:maintenance_log/models/maintenance_item.dart';
import 'package:maintenance_log/models/meter_type.dart';
import 'package:maintenance_log/widgets/bls_bottom_sheet.dart';
import 'package:maintenance_log/widgets/custom_date_time_picker.dart';
import 'package:maintenance_log/widgets/custom_text_form_field.dart';
import 'package:maintenance_log/widgets/custom_numeric_form_field.dart';

class MaintenanceItemAddEditBottomSheet extends StatefulWidget {
  final Maintenance maintenance;
  final MaintenanceItem? maintenanceItem;
  const MaintenanceItemAddEditBottomSheet(
      {required this.maintenance, this.maintenanceItem, super.key});

  @override
  State<MaintenanceItemAddEditBottomSheet> createState() =>
      _MaintenanceItemAddEditBottomSheetState();
}

class _MaintenanceItemAddEditBottomSheetState
    extends State<MaintenanceItemAddEditBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final headerController = TextEditingController();
  final meterController = TextEditingController();
  final costController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void initState() {
    if (widget.maintenanceItem != null) {
      dateController.text = widget.maintenanceItem!.date.toDateAndTime();
      headerController.text = widget.maintenanceItem!.header;
      meterController.text =
          widget.maintenanceItem!.meterValue?.toString() ?? '';
      costController.text = widget.maintenanceItem!.costs.toString();
      noteController.text = widget.maintenanceItem!.note;
    } else {
      dateController.text = DateTime.now().toDateAndTime();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlsBottomSheet(
      title: widget.maintenanceItem != null
          ? 'Redigera post'
          : 'Lägg till ny post',
      okText: 'Spara',
      cancelText: 'Avbryt',
      onOkPressed: () {
        if (formKey.currentState?.validate() == true) {
          if (widget.maintenanceItem != null) {
            final maintenanceItem = widget.maintenanceItem!;
            final newMaintenanceItem = maintenanceItem.copyWith(
              header: headerController.toTrimmedString(),
              date: dateController.toDateTime(),
              meterValue: meterController.toNullableInt(),
              costs: costController.toNumeric(),
              note: noteController.toTrimmedString(),
            );

            if (newMaintenanceItem == maintenanceItem) {
              // Nothing changed
              Navigator.pop(context);
            } else {
              Navigator.pop(context, newMaintenanceItem);
            }
          } else {
            final maintenanceItem = MaintenanceItem.createNew(
              maintenanceId: widget.maintenance.id,
              header: headerController.text.trim(),
              date: dateController.toDateTime(),
              meterValue: meterController.toNullableInt(),
              costs: costController.toNumeric(),
              note: noteController.toTrimmedString(),
            );

            Navigator.pop(context, maintenanceItem);
          }
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
              : const SizedBox(),
          widget.maintenance.meterType == MeterType.hourmeter
              ? CustomNumericFormField(
                  label: 'Mätarvärde (timmar)',
                  allowDecimal: false,
                  controller: meterController,
                )
              : const SizedBox(),
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
