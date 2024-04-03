import 'package:flutter/material.dart';
import 'package:maintenance_log/extensions/date_time_extensions.dart';
import 'package:maintenance_log/models/consumption.dart';
import 'package:maintenance_log/models/consumption_item.dart';
import 'package:maintenance_log/models/meter_type.dart';
import 'package:maintenance_log/widgets/bls_bottom_sheet.dart';
import 'package:maintenance_log/widgets/custom_date_time_picker.dart';
import 'package:maintenance_log/widgets/custom_text_form_field.dart';
import 'package:maintenance_log/widgets/custom_numeric_form_field.dart';

class ConsumptionItemAddBottomSheet extends StatefulWidget {
  final Consumption consumption;
  const ConsumptionItemAddBottomSheet({required this.consumption, super.key});

  @override
  State<ConsumptionItemAddBottomSheet> createState() =>
      _ConsumptionItemAddBottomSheetState();
}

class _ConsumptionItemAddBottomSheetState
    extends State<ConsumptionItemAddBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final pricePerLitreController = TextEditingController();
  final litreController = TextEditingController();
  final meterController = TextEditingController();
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
          final consumptionItem = ConsumptionItem.createNew(
            consumptionId: widget.consumption.id,
            date: DateTime.parse(
              dateController.text.trim(),
            ),
            pricePerLitre:
                num.parse(pricePerLitreController.text.replaceAll(',', '.')),
            litre: num.parse(litreController.text.replaceAll(',', '.')),
            meterValue: meterController.text.trim().isNotEmpty
                ? int.parse(meterController.text.trim())
                : null,
            note: noteController.text.trim(),
          );

          Navigator.pop(context, consumptionItem);
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
          widget.consumption.meterType == MeterType.odometer
              ? CustomNumericFormField(
                  label: 'Mätarvärde (km)',
                  allowDecimal: false,
                  controller: meterController,
                )
              : Container(),
          widget.consumption.meterType == MeterType.hourmeter
              ? CustomNumericFormField(
                  label: 'Mätarvärde (timmar)',
                  allowDecimal: false,
                  controller: meterController,
                )
              : Container(),
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
