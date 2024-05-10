import 'package:flutter/material.dart';
import 'package:maintenance_log/extensions/date_time_extensions.dart';
import 'package:maintenance_log/extensions/text_editing_controller_extensions.dart';
import 'package:maintenance_log/models/consumption.dart';
import 'package:maintenance_log/models/consumption_item.dart';
import 'package:maintenance_log/models/meter_type.dart';
import 'package:maintenance_log/widgets/bls_bottom_sheet.dart';
import 'package:maintenance_log/widgets/custom_date_time_picker.dart';
import 'package:maintenance_log/widgets/custom_text_form_field.dart';
import 'package:maintenance_log/widgets/custom_numeric_form_field.dart';

class ConsumptionItemAddEditBottomSheet extends StatefulWidget {
  final Consumption consumption;
  final ConsumptionItem? consumptionItem;
  const ConsumptionItemAddEditBottomSheet(
      {required this.consumption, this.consumptionItem, super.key});

  @override
  State<ConsumptionItemAddEditBottomSheet> createState() =>
      _ConsumptionItemAddEditBottomSheetState();
}

class _ConsumptionItemAddEditBottomSheetState
    extends State<ConsumptionItemAddEditBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final pricePerLitreController = TextEditingController();
  final litreController = TextEditingController();
  final meterController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void initState() {
    if (widget.consumptionItem != null) {
      dateController.text = widget.consumptionItem!.date.toDateAndTime();
      pricePerLitreController.text =
          widget.consumptionItem!.pricePerLitre.toString();
      litreController.text = widget.consumptionItem!.litre.toString();
      meterController.text = widget.consumptionItem!.meterValue.toString();
      noteController.text = widget.consumptionItem!.note;
    } else {
      dateController.text = DateTime.now().toDateAndTime();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlsBottomSheet(
      title: widget.consumptionItem != null
          ? 'Redigera post'
          : 'Lägg till ny post',
      okText: 'Spara',
      cancelText: 'Avbryt',
      onOkPressed: () {
        if (formKey.currentState?.validate() == true) {
          if (widget.consumptionItem != null) {
            final consumptionItem = widget.consumptionItem!;
            final newConsumptionItem = consumptionItem.copyWith(
              date: DateTime.parse(dateController.text.trim()),
              meterValue: meterController.toNullableInt(),
              pricePerLitre: pricePerLitreController.toNumeric(),
              litre: litreController.toNumeric(),
              note: noteController.toTrimmedString(),
            );
            if (newConsumptionItem == consumptionItem) {
              // Nothing changed
              Navigator.pop(context);
            } else {
              Navigator.pop(context, newConsumptionItem);
            }
          } else {
            final consumptionItem = ConsumptionItem.createNew(
              consumptionId: widget.consumption.id,
              date: DateTime.parse(
                dateController.text.trim(),
              ),
              pricePerLitre: pricePerLitreController.toNumeric(),
              litre: litreController.toNumeric(),
              meterValue: meterController.toNullableInt(),
              note: noteController.toTrimmedString(),
            );

            Navigator.pop(context, consumptionItem);
          }
        }
      },
      onCancelPressed: () {
        Navigator.pop(context);
      },
      child: Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            // Needed for text in border to be visible when scroll is used
            height: 10,
          ),
          CustomDateTimePicker('Datum', dateController),
          widget.consumption.meterType == MeterType.odometer
              ? CustomNumericFormField(
                  label: 'Mätarvärde (km)',
                  allowDecimal: false,
                  controller: meterController,
                )
              : const SizedBox(),
          widget.consumption.meterType == MeterType.hourmeter
              ? CustomNumericFormField(
                  label: 'Mätarvärde (timmar)',
                  allowDecimal: false,
                  controller: meterController,
                )
              : const SizedBox(),
          CustomNumericFormField(
            label: 'Literpris',
            allowDecimal: true,
            controller: pricePerLitreController,
            validator: (value) => pricePerLitreController.text.isEmpty
                ? 'Ett literpris måste anges'
                : null,
          ),
          CustomNumericFormField(
            label: 'Antal liter',
            allowDecimal: true,
            controller: litreController,
            validator: (value) =>
                litreController.text.isEmpty ? 'Antal liter måste anges' : null,
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
    meterController.dispose();
    pricePerLitreController.dispose();
    litreController.dispose();
    noteController.dispose();

    super.dispose();
  }
}
