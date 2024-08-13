import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_event.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_state.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/models/note.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'package:maintenance_log/views/maintenance_object/maintenance_tab/note_add_edit_bottom_sheet.dart';
import 'package:maintenance_log/widgets/bls_bottom_sheet.dart';
import 'package:maintenance_log/widgets/maintenance_object_item_card.dart';
import 'package:maintenance_log/widgets/sub_header_app_bar.dart';

// ignore: must_be_immutable
class InformationPage extends StatelessWidget {
  final String maintenanceObjectId;
  final String maintenanceObjectName;
  late MaintenanceObject maintenanceObject;

  InformationPage(
      {required this.maintenanceObjectId,
      required this.maintenanceObjectName,
      super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MaintenanceObjectBloc>(
      create: (context) => MaintenanceObjectBloc(
        maintenanceObjectRepository: ioc.get(),
      ),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: colorLightGrey,
          appBar: SubHeaderAppBar(
            title: maintenanceObjectName,
            onTrailingAddTap: () async {
              final maintenanceObjectBloc =
                  context.read<MaintenanceObjectBloc>();
              final addedNote = await showBlsBottomSheet<Note?>(
                  context: context,
                  builder: (context) {
                    return NoteAddEditBottomSheet(
                      maintenanceObject: maintenanceObject,
                    );
                  });

              if (addedNote != null) {
                maintenanceObjectBloc.add(
                  NoteChangedEvent(
                      maintenanceObject: maintenanceObject, note: addedNote),
                );
              }
            },
          ),
          body: Builder(builder: (context) {
            return BlocBuilder<MaintenanceObjectBloc, MaintenanceObjectState>(
                bloc: context.read<MaintenanceObjectBloc>()
                  ..add(MaintenanceObjectSubscriptionEvent(
                      maintenanceObjectId: maintenanceObjectId)),
                builder: (context, state) {
                  if (state is MaintenanceObjectUpdatedState) {
                    maintenanceObject = state.maintenanceObject;
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 6.0, right: 6, top: 6),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  MaintenanceObjectItemCard(
                                    title: 'Noteringar',
                                    postCount:
                                        state.maintenanceObject.notes.length,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: _createNotes(
                                          context, state.maintenanceObject),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Center(
                    child: SizedBox(
                        height: 60,
                        width: 60,
                        child: CircularProgressIndicator()),
                  );
                });
          }),
        );
      }),
    );
  }

  List<Widget> _createNotes(
      BuildContext context, MaintenanceObject maintenanceObject) {
    if (maintenanceObject.notes.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              'Inga noteringar finns registrerade ännu.',
              style: TextStyle(fontSize: 18, color: colorBlue.withOpacity(0.5)),
            ),
          ),
        )
      ];
    }

    final result = List<Widget>.empty(growable: true);
    for (var i = 0; i < maintenanceObject.notes.length; i++) {
      if (i > 0) {
        result.add(Divider());
      }
      final note = maintenanceObject.notes.elementAt(i);

      result.add(_createNote(context, maintenanceObject, note));
    }
    return result;
  }

  Widget _createNote(
      BuildContext context, MaintenanceObject maintenanceObject, Note note) {
    final maintenanceObjectBloc = context.read<MaintenanceObjectBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Dismissible(
          key: ValueKey(note.id),
          background: Container(
            color: Colors.green,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.edit, color: Colors.white),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text('Ändra', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.delete, color: Colors.white),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text('Radera', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          confirmDismiss: (direction) async {
            final maintenanceObjectBloc = context.read<MaintenanceObjectBloc>();

            if (direction == DismissDirection.startToEnd) {
              var changedNote = await showBlsBottomSheet<Note?>(
                context: context,
                builder: (context) => NoteAddEditBottomSheet(
                  maintenanceObject: maintenanceObject,
                  note: note,
                ),
              );

              if (changedNote != null) {
                maintenanceObjectBloc.add(
                  NoteChangedEvent(
                    maintenanceObject: maintenanceObject,
                    note: changedNote,
                  ),
                );
              }

              return Future.value(false);
            }

            if (direction == DismissDirection.endToStart) {
              var shouldDelete = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Radera notering'),
                    content: const Text(
                        'Noteringen kommer nu tas bort och kan inte återskapas. \n\n Vill du fortsätta med att radera?'),
                    actions: <Widget>[
                      SizedBox(
                        width: 130,
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                              backgroundColor: colorGold.withOpacity(0.5),
                              foregroundColor: colorBlue),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Nej'),
                        ),
                      ),
                      SizedBox(
                        width: 130,
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                              backgroundColor: colorBlue,
                              foregroundColor: colorGold),
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Ja'),
                        ),
                      ),
                    ],
                  );
                },
              );

              if (shouldDelete) {
                return Future.value(true);
              }
            }

            return Future.value(false);
          },
          onDismissed: (direction) async {
            if (direction == DismissDirection.endToStart) {
              maintenanceObjectBloc.add(
                NoteDeletedEvent(
                    maintenanceObject: maintenanceObject, note: note),
              );
            }
          },
          child: InkWell(
            splashColor: colorGold.withOpacity(0.4),
            highlightColor: Colors.transparent,
            onTap: () async {
              // Show readonly note
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      note.header,
                      style: TextStyle(fontSize: 20, color: colorBlue),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(note.subHeader),
              ],
            ),
          ),
        ),
        // Divider(),
      ],
    );
  }
}
