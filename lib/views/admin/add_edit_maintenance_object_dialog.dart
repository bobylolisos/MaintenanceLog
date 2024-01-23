import 'package:flutter/material.dart';
import 'package:maintenance_log/extensions/meter_type_extensions.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/models/meter_type.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/widgets/bls_dialog.dart';

class AddEditMaintenanceObjectDialog extends StatefulWidget {
  final MaintenanceObject? maintenanceObject;
  const AddEditMaintenanceObjectDialog({this.maintenanceObject, super.key});

  @override
  State<AddEditMaintenanceObjectDialog> createState() =>
      _AddEditMaintenanceObjectDialogState();
}

class _AddEditMaintenanceObjectDialogState
    extends State<AddEditMaintenanceObjectDialog> {
  final formKey = GlobalKey<FormState>();
  final headerController = TextEditingController();
  final subHeaderController = TextEditingController();
  final descriptionController = TextEditingController();
  MeterType selectedMeterType = MeterType.none;

  @override
  void initState() {
    if (widget.maintenanceObject != null) {
      headerController.text = widget.maintenanceObject!.header;
      subHeaderController.text = widget.maintenanceObject!.subHeader;
      descriptionController.text = widget.maintenanceObject!.description;
      selectedMeterType = widget.maintenanceObject!.meterType;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlsDialog(
      title: widget.maintenanceObject != null
          ? 'Ändra objekt'
          : 'Lägg till nytt objekt',
      okText: 'Spara',
      cancelText: 'Avbryt',
      onOkPressed: () {
        if (formKey.currentState?.validate() == true) {
          final maintenanceObject = widget.maintenanceObject != null
              ? widget.maintenanceObject!.copyWith(
                  header: headerController.text.trim(),
                  subHeader: subHeaderController.text.trim(),
                  description: descriptionController.text.trim(),
                )
              : MaintenanceObject.createNew(
                  headerController.text.trim(),
                  subHeaderController.text.trim(),
                  descriptionController.text.trim(),
                  selectedMeterType,
                );

          Navigator.pop(context, maintenanceObject);
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
          TextFormField(
            decoration: _inputDecoration('Rubrik'),
            controller: headerController,
            maxLength: 20,
            onChanged: (value) => formKey.currentState?.validate(),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'En rubrik måste anges'
                : null,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: _inputDecoration('Underrubrik'),
            controller: subHeaderController,
            maxLength: 30,
          ),
          SizedBox(
            height: 10,
          ),
          DropdownButtonFormField(
            items: [
              DropdownMenuItem<MeterType>(
                value: MeterType.none,
                child: Text(MeterType.none.displayName),
              ),
              DropdownMenuItem<MeterType>(
                value: MeterType.odometer,
                child: Text(MeterType.odometer.displayName),
              ),
              DropdownMenuItem<MeterType>(
                value: MeterType.hourmeter,
                child: Text(MeterType.hourmeter.displayName),
              ),
            ],
            focusColor: Colors.transparent,
            dropdownColor: Colors.white,
            style: TextStyle(color: colorBlue, fontSize: 16),
            decoration: InputDecoration(
              // prefixIcon: Icon(Icons.radar),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorBlue),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorBlue),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorBlue),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorBlue),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: widget.maintenanceObject == null
                ? (value) {
                    selectedMeterType = value as MeterType;
                  }
                : null,
            value: selectedMeterType,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: _inputDecoration('Notering'),
            controller: descriptionController,
            minLines: 3,
            maxLines: 6,
          ),
        ]),
      ),
    );
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      counterStyle: TextStyle(color: colorBlue, fontSize: 12),
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
      labelText: labelText,
      labelStyle: TextStyle(color: colorBlue),
    );
  }

  @override
  void dispose() {
    headerController.dispose();
    subHeaderController.dispose();
    descriptionController.dispose();

    super.dispose();
  }
}
