import 'package:flutter/material.dart';
import 'package:maintenance_log/extensions/text_editing_controller_extensions.dart';
import 'package:maintenance_log/widgets/bls_dialog.dart';
import 'package:maintenance_log/widgets/custom_numeric_form_field.dart';

class TripHourMeterDialog extends StatefulWidget {
  final num? previousMeterValue;
  final num? currentMeterValue;

  const TripHourMeterDialog(
      {required this.previousMeterValue,
      required this.currentMeterValue,
      super.key});

  @override
  State<TripHourMeterDialog> createState() => _TripHourMeterDialogState();
}

class _TripHourMeterDialogState extends State<TripHourMeterDialog> {
  final tripController = TextEditingController();

  @override
  void initState() {
    if (widget.previousMeterValue != null &&
        widget.previousMeterValue! > 0 &&
        widget.currentMeterValue != null &&
        widget.currentMeterValue! > 0 &&
        widget.currentMeterValue! >= widget.currentMeterValue!) {
      tripController.text =
          (widget.currentMeterValue! - widget.previousMeterValue!).toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlsDialog(
      title: 'Ange trip',
      okText: 'Ok',
      onOkPressed: () {
        if (widget.previousMeterValue != null) {
          var tripValue = tripController.toNumeric();
          var meterValue = widget.previousMeterValue! + tripValue;

          Navigator.of(context).pop(meterValue);
        } else {
          Navigator.of(context).pop(tripController.toInt());
        }
      },
      cancelText: 'Avbryt',
      onCancelPressed: () {
        Navigator.of(context).pop();
      },
      child: CustomNumericFormField(
        label: 'Trip (timmar)',
        allowDecimal: false,
        controller: tripController,
      ),
    );
  }

  @override
  void dispose() {
    tripController.dispose();

    super.dispose();
  }
}
