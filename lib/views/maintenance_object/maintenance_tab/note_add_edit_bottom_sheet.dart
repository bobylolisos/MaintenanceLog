import 'package:flutter/material.dart';
import 'package:maintenance_log/extensions/text_editing_controller_extensions.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/models/note.dart';
import 'package:maintenance_log/widgets/bls_bottom_sheet.dart';
import 'package:maintenance_log/widgets/custom_text_form_field.dart';

class NoteAddEditBottomSheet extends StatefulWidget {
  final MaintenanceObject maintenanceObject;
  final Note? note;
  const NoteAddEditBottomSheet(
      {required this.maintenanceObject, this.note, super.key});

  @override
  State<NoteAddEditBottomSheet> createState() => _NoteAddEditBottomSheetState();
}

class _NoteAddEditBottomSheetState extends State<NoteAddEditBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final headerController = TextEditingController();
  final subHeaderController = TextEditingController();
  final textController = TextEditingController();

  @override
  void initState() {
    if (widget.note != null) {
      headerController.text = widget.note!.header;
      subHeaderController.text = widget.note!.subHeader;
      textController.text = widget.note!.text;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlsBottomSheet(
      title:
          widget.note != null ? 'Redigera notering' : 'Lägg till ny notering',
      okText: 'Spara',
      cancelText: 'Avbryt',
      onOkPressed: () {
        if (formKey.currentState?.validate() == true) {
          if (widget.note != null) {
            final note = widget.note!;
            final newNote = note.copyWith(
              header: headerController.toTrimmedString(),
              subHeader: subHeaderController.toTrimmedString(),
              text: textController.toTrimmedString(),
            );

            if (newNote == note) {
              // Nothing changed
              Navigator.pop(context);
            } else {
              Navigator.pop(context, newNote);
            }
          } else {
            final note = Note.createNew(
              headerController.text.trim(),
              subHeaderController.text.trim(),
              textController.toTrimmedString(),
            );

            Navigator.pop(context, note);
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
          CustomTextFormField(
            label: 'Rubrik',
            textController: headerController,
            maxLength: 30,
            validator: (value) =>
                headerController.text.isEmpty ? 'En rubrik måste anges' : null,
          ),
          CustomTextFormField(
            label: 'Beskrivning',
            textController: subHeaderController,
            maxLength: 30,
          ),
          CustomTextFormField(
            label: 'Notering',
            textController: textController,
            minLines: 10,
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    headerController.dispose();
    subHeaderController.dispose();
    textController.dispose();

    super.dispose();
  }
}
