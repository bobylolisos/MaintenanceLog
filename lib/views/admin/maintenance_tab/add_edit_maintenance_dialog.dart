import 'package:flutter/material.dart';
import 'package:maintenance_log/models/maintenance.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/views/admin/widgets/text_input_decoration.dart';
import 'package:maintenance_log/widgets/bls_dialog.dart';

class AddEditMaintenanceDialog extends StatefulWidget {
  final MaintenanceObject maintenanceObject;
  final Maintenance? maintenance;
  const AddEditMaintenanceDialog(
      {required this.maintenanceObject, this.maintenance, super.key});

  @override
  State<AddEditMaintenanceDialog> createState() =>
      _AddEditMaintenanceDialogState();
}

class _AddEditMaintenanceDialogState extends State<AddEditMaintenanceDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    if (widget.maintenance != null) {
      nameController.text = widget.maintenance!.name;
      descriptionController.text = widget.maintenance!.description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlsDialog(
      title: widget.maintenance != null
          ? 'Ändra underhållspunkt'
          : 'Lägg till ny underhållspunkt',
      okText: 'Spara',
      cancelText: 'Avbryt',
      onOkPressed: () {
        if (formKey.currentState?.validate() == true) {
          final maintenance = widget.maintenance != null
              ? widget.maintenance!.copyWith(
                  name: nameController.text.trim(),
                  description: descriptionController.text.trim(),
                )
              : Maintenance.createNew(
                  name: nameController.text.trim(),
                  description: descriptionController.text.trim(),
                  meterType: widget.maintenanceObject!.meterType,
                );

          Navigator.pop(context, maintenance);
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
            decoration: textInputDecoration('Namn'),
            controller: nameController,
            maxLength: 20,
            onChanged: (value) => formKey.currentState?.validate(),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Ett namn måste anges'
                : null,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: textInputDecoration('Beskrivning'),
            controller: descriptionController,
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
