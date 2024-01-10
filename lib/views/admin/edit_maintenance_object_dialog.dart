import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_event.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/repositories/firestore_maintenance_repository.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'package:maintenance_log/widgets/bls_dialog.dart';

class EditMaintenanceObjectDialog extends StatefulWidget {
  const EditMaintenanceObjectDialog({super.key});

  @override
  State<EditMaintenanceObjectDialog> createState() =>
      _EditMaintenanceObjectDialogState();
}

class _EditMaintenanceObjectDialogState
    extends State<EditMaintenanceObjectDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlsDialog(
      title: 'Lägg till nytt objekt',
      okText: 'Spara',
      cancelText: 'Avbryt',
      onOkPressed: () {
        if (formKey.currentState?.validate() == true) {
          final maintenanceObject = MaintenanceObject.createNew(
              nameController.text.trim(), descriptionController.text.trim());

          MaintenanceObjectBloc(
            maintenanceObjectRepository: ioc.get(),
          ).add(
              MaintenanceObjectSaveEvent(maintenanceObject: maintenanceObject));

          Navigator.pop(context);
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
            decoration: _inputDecoration('Namn'),
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
            decoration: _inputDecoration('Beskrivning'),
            controller: descriptionController,
            maxLength: 30,
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
    nameController.dispose();
    descriptionController.dispose();

    super.dispose();
  }
}
