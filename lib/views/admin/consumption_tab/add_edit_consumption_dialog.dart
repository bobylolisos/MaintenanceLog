import 'package:flutter/material.dart';
import 'package:maintenance_log/models/consumption.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/widgets/bls_dialog.dart';
import 'package:maintenance_log/widgets/custom_text_form_field.dart';

class AddEditConsumptionDialog extends StatefulWidget {
  final MaintenanceObject maintenanceObject;
  final Consumption? consumption;
  const AddEditConsumptionDialog(
      {required this.maintenanceObject, this.consumption, super.key});

  @override
  State<AddEditConsumptionDialog> createState() =>
      _AddEditConsumptionDialogState();
}

class _AddEditConsumptionDialogState extends State<AddEditConsumptionDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    if (widget.consumption != null) {
      nameController.text = widget.consumption!.name;
      descriptionController.text = widget.consumption!.description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlsDialog(
      title: widget.consumption != null
          ? 'Ändra drivmedel'
          : 'Lägg till nytt drivmedel',
      okText: 'Spara',
      cancelText: 'Avbryt',
      onOkPressed: () {
        if (formKey.currentState?.validate() == true) {
          final consumption = widget.consumption != null
              ? widget.consumption!.copyWith(
                  name: nameController.text.trim(),
                  description: descriptionController.text.trim(),
                )
              : Consumption.createNew(
                  name: nameController.text.trim(),
                  description: descriptionController.text.trim(),
                  meterType: widget.maintenanceObject!.meterType,
                );

          Navigator.pop(context, consumption);
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
          CustomTextFormField(
            label: 'Namn',
            textController: nameController,
            maxLength: 20,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Ett namn måste anges'
                : null,
          ),
          SizedBox(
            height: 10,
          ),
          CustomTextFormField(
            label: 'Beskrivning',
            textController: descriptionController,
            minLines: 3,
            maxLines: 6,
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();

    super.dispose();
  }
}
