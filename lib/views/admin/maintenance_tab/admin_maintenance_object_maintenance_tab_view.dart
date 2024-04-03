import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_event.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_state.dart';
import 'package:maintenance_log/models/maintenance.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'package:maintenance_log/views/admin/maintenance_tab/add_edit_maintenance_bottom_sheet.dart';
import 'package:maintenance_log/widgets/maintenance_object_item_card.dart';

class AdminMaintenanceObjectMaintenanceTabView extends StatelessWidget {
  final String maintenanceObjectId;
  const AdminMaintenanceObjectMaintenanceTabView(
      {required this.maintenanceObjectId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MaintenanceObjectBloc>(
      create: (context) => MaintenanceObjectBloc(
        maintenanceObjectRepository: ioc.get(),
      ),
      child: Builder(builder: (context) {
        return BlocBuilder<MaintenanceObjectBloc, MaintenanceObjectState>(
            bloc: context.read<MaintenanceObjectBloc>()
              ..add(MaintenanceObjectGetEvent(
                  maintenanceObjectId: maintenanceObjectId)),
            builder: (context, state) {
              if (state is MaintenanceObjectUpdatedState) {
                final maintenanceObject = state.maintenanceObject;
                return ReorderableListView.builder(
                  proxyDecorator: (child, index, animation) => Material(
                    color: Colors.transparent,
                    // borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        child,
                        Container(
                          margin: EdgeInsets.only(top: 27, bottom: 20),
                          color: colorGold.withOpacity(0.7),
                        )
                      ],
                    ),
                  ),

                  // physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final maintenance =
                        maintenanceObject.maintenances.elementAt(index);
                    return Dismissible(
                      key: ValueKey(maintenance.id),
                      background: Container(
                        color: Colors.transparent,
                      ),
                      secondaryBackground: Container(
                        margin: EdgeInsets.only(top: 27, bottom: 20),
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
                              Text('Radera',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          var shouldDelete = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(maintenance.name),
                                content: const Text(
                                    'Underhållspunkten kommer nu tas bort och kan inte återskapas.\n\n Vill du fortsätta med att radera?'),
                                actions: <Widget>[
                                  SizedBox(
                                    width: 130,
                                    child: ElevatedButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              colorGold.withOpacity(0.5),
                                          foregroundColor: colorBlue),
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text('Nej'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: ElevatedButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: colorBlue,
                                          foregroundColor: colorGold),
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
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
                        context.read<MaintenanceObjectBloc>().add(
                              MaintenanceDeletedEvent(
                                  maintenanceObject: maintenanceObject,
                                  maintenanceId: maintenance.id),
                            );
                      },
                      child: MaintenanceObjectItemCard(
                        title: maintenance.name,
                        postCount: maintenance.posts.length,
                        onTap: () async {
                          var bloc = context.read<MaintenanceObjectBloc>();
                          final changedMaintenance =
                              await showModalBottomSheet<Maintenance?>(
                            context: context,
                            isScrollControlled: true,
                            isDismissible: false,
                            backgroundColor: colorBlue,
                            builder: (context) {
                              return AddEditMaintenanceBottomSheet(
                                maintenanceObject: maintenanceObject,
                                maintenance: maintenance,
                              );
                            },
                          );

                          if (changedMaintenance != null) {
                            var updatedMaintenances =
                                maintenanceObject.maintenances.toList();
                            final index = updatedMaintenances.indexWhere(
                                (x) => x.id == changedMaintenance.id);
                            updatedMaintenances.removeAt(index);
                            updatedMaintenances.insert(
                                index, changedMaintenance);
                            final updatedMaintenanceObject = maintenanceObject
                                .copyWith(maintenances: updatedMaintenances);
                            bloc.add(
                              MaintenanceObjectSaveEvent(
                                  maintenanceObject: updatedMaintenanceObject),
                            );
                          }
                        },
                        trailing: InkWell(
                          splashColor: colorGold.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {},
                          child: Icon(
                            Icons.reorder,
                            color: colorBlue,
                          ),
                        ),
                        trailingVerticalAlignment: CrossAxisAlignment.center,
                        child: Text(
                          maintenance.description,
                        ),
                      ),
                    );
                  },

                  itemCount: maintenanceObject.maintenances.length,
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item =
                        maintenanceObject.maintenances.removeAt(oldIndex);
                    maintenanceObject.maintenances.insert(newIndex, item);

                    final maintenanceObjectBloc =
                        context.read<MaintenanceObjectBloc>();
                    maintenanceObjectBloc.add(MaintenanceObjectSaveEvent(
                        maintenanceObject: maintenanceObject));
                  },
                );
              }

              return Center(
                child: SizedBox(
                    height: 60, width: 60, child: CircularProgressIndicator()),
              );
            });
      }),
    );
  }
}
