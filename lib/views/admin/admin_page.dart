import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_event.dart';
import 'package:maintenance_log/blocs/maintenance_objects_bloc/maintenance_objects_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_objects_bloc/maintenance_objects_event.dart';
import 'package:maintenance_log/blocs/maintenance_objects_bloc/maintenance_objects_state.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'package:maintenance_log/views/admin/information_tab/add_edit_maintenance_object_dialog.dart';
import 'package:maintenance_log/views/admin/admin_maintenance_object_page.dart';
import 'package:maintenance_log/widgets/add_card.dart';
import 'package:maintenance_log/widgets/maintenace_object_card.dart';
import 'package:maintenance_log/widgets/sub_header_app_bar.dart';

class AdminPage extends StatelessWidget {
  AdminPage({super.key});
  int _lowestSortOrder = 1000;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MaintenanceObjectBloc>(
      create: (context) =>
          MaintenanceObjectBloc(maintenanceObjectRepository: ioc.get()),
      child: Scaffold(
        backgroundColor: colorLightGrey,
        appBar: SubHeaderAppBar(title: 'Administrera'),
        body: Builder(builder: (context) {
          return Material(
            child: SafeArea(
              child: Container(
                color: colorLightGrey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 5),
                      child: AddCard(
                        text: 'Nytt objekt',
                        onTap: () async {
                          final maintenanceObjectBloc =
                              context.read<MaintenanceObjectBloc>();

                          final addedMaintenanceObject =
                              await showDialog<MaintenanceObject?>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AddEditMaintenanceObjectDialog();
                            },
                          );

                          if (addedMaintenanceObject != null) {
                            maintenanceObjectBloc.add(
                              MaintenanceObjectSaveEvent(
                                  maintenanceObject: addedMaintenanceObject!
                                      .copyWith(sortOrder: --_lowestSortOrder)),
                            );
                          }
                        },
                      ),
                    ),
                    BlocProvider<MaintenanceObjectsBloc>(
                      create: (BuildContext context) => MaintenanceObjectsBloc(
                          maintenanceObjectRepository: ioc.get())
                        ..add(MaintenanceObjectsSubscriptionEvent()),
                      child: Expanded(
                        child: BlocBuilder<MaintenanceObjectsBloc,
                            MaintenanceObjectsState>(
                          builder: (context, state) {
                            if (state is MaintenanceObjectsChangedState) {
                              final maintenanceObjects =
                                  state.maintenanceObjects;
                              if (maintenanceObjects.isNotEmpty) {
                                _lowestSortOrder = maintenanceObjects
                                    .reduce((a, b) =>
                                        a.sortOrder < b.sortOrder ? a : b)
                                    .sortOrder;
                              }
                              return ReorderableListView.builder(
                                proxyDecorator: (child, index, animation) =>
                                    Material(
                                  color: Colors.transparent,
                                  // borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    children: [
                                      child,
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 4),
                                        decoration: BoxDecoration(
                                            color: colorGold.withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ],
                                  ),
                                ),
                                itemCount: state.maintenanceObjects.length,
                                itemBuilder: (context, index) {
                                  final maintenanceObject =
                                      state.maintenanceObjects.elementAt(index);
                                  return Padding(
                                    key: ValueKey(maintenanceObject.id),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 5),
                                    child: Dismissible(
                                      key: ValueKey(maintenanceObject.id),
                                      background: Container(
                                        color: Colors.transparent,
                                      ),
                                      secondaryBackground: Container(
                                        color: Colors.red,
                                        child: const Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(Icons.delete,
                                                  color: Colors.white),
                                              SizedBox(
                                                width: 8.0,
                                              ),
                                              Text('Radera',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      confirmDismiss: (direction) async {
                                        if (direction ==
                                            DismissDirection.endToStart) {
                                          var shouldDelete = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Radera underhållsobjekt'),
                                                content: const Text(
                                                    'Underhållsobjektet kommer nu tas bort och kan inte återskapas. Du vet väl att du kan inaktivera ditt underhållsobjekt istället? Då kan du fortfarande återaktivera objektet samt att du kan fortfarande se utförda underhåll. \n\n Vill du fortsätta med att radera?'),
                                                actions: <Widget>[
                                                  SizedBox(
                                                    width: 130,
                                                    child: ElevatedButton(
                                                      style: TextButton.styleFrom(
                                                          backgroundColor:
                                                              colorGold
                                                                  .withOpacity(
                                                                      0.5),
                                                          foregroundColor:
                                                              colorBlue),
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child: Text('Nej'),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 130,
                                                    child: ElevatedButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                              backgroundColor:
                                                                  colorBlue,
                                                              foregroundColor:
                                                                  colorGold),
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(true),
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
                                      onDismissed: (direction) {
                                        context
                                            .read<MaintenanceObjectsBloc>()
                                            .add(MaintenanceObjectsDeleteEvent(
                                                maintenanceObjectId:
                                                    maintenanceObject.id));
                                      },
                                      child: MaintenanceObjectCard(
                                        maintenanceObject: maintenanceObject,
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminMaintenanceObjectPage(
                                                  maintenanceObjectId:
                                                      maintenanceObject.id,
                                                ),
                                              ));
                                        },
                                        trailing: Icon(Icons.reorder,
                                            color: colorBlue),
                                      ),
                                    ),
                                  );
                                },
                                onReorder: (int oldIndex, int newIndex) {
                                  print(newIndex.toString());
                                  if (oldIndex < newIndex) {
                                    newIndex -= 1;
                                  }
                                  final item =
                                      maintenanceObjects.removeAt(oldIndex);
                                  maintenanceObjects.insert(newIndex, item);
                                  context.read<MaintenanceObjectsBloc>().add(
                                      MaintenanceObjectsReorderEvent(
                                          maintenanceObjects:
                                              maintenanceObjects));
                                },
                              );
                            }
                            return Center(
                              child: SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: CircularProgressIndicator()),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
