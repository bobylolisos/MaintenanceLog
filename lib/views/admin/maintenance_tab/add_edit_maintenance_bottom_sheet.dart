import 'package:flutter/material.dart';
import 'package:maintenance_log/models/maintenance.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/widgets/bls_bottom_sheet.dart';
import 'package:maintenance_log/widgets/custom_text_form_field.dart';

class AddEditMaintenanceBottomSheet extends StatefulWidget {
  final MaintenanceObject maintenanceObject;
  final Maintenance? maintenance;
  const AddEditMaintenanceBottomSheet(
      {required this.maintenanceObject, this.maintenance, super.key});

  @override
  State<AddEditMaintenanceBottomSheet> createState() =>
      _AddEditMaintenanceBottomSheetState();
}

class _AddEditMaintenanceBottomSheetState
    extends State<AddEditMaintenanceBottomSheet> {
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
    return BlsBottomSheet(
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
