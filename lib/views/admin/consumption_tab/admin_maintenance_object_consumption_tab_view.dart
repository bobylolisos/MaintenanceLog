import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_event.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_state.dart';
import 'package:maintenance_log/models/consumption.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'package:maintenance_log/views/admin/consumption_tab/add_edit_consumption_bottom_sheet.dart';
import 'package:maintenance_log/widgets/maintenance_object_item_card.dart';

import '../../../widgets/bls_bottom_sheet.dart';

class AdminMaintenanceObjectConsumptionTabView extends StatelessWidget {
  final String maintenanceObjectId;
  const AdminMaintenanceObjectConsumptionTabView(
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
                    final consumption =
                        maintenanceObject.consumptions.elementAt(index);
                    return Dismissible(
                      key: ValueKey(consumption.id),
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
                                title: Text(consumption.name),
                                content: const Text(
                                    'Drivmedlet kommer nu tas bort och kan inte återskapas.\n\n Vill du fortsätta med att radera?'),
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
                              ConsumptionDeletedEvent(
                                  maintenanceObject: maintenanceObject,
                                  consumptionId: consumption.id),
                            );
                      },
                      child: MaintenanceObjectItemCard(
                        title: consumption.name,
                        postCount: consumption.posts.length,
                        onTap: () async {
                          var bloc = context.read<MaintenanceObjectBloc>();
                          final changedConsumption =
                              await showBlsBottomSheet<Consumption?>(
                            context: context,
                            builder: (context) {
                              return AddEditConsumptionBottomSheet(
                                maintenanceObject: maintenanceObject,
                                consumption: consumption,
                              );
                            },
                          );

                          if (changedConsumption != null) {
                            var updatedConsumptions =
                                maintenanceObject.consumptions.toList();
                            final index = updatedConsumptions.indexWhere(
                                (x) => x.id == changedConsumption.id);
                            updatedConsumptions.removeAt(index);
                            updatedConsumptions.insert(
                                index, changedConsumption);
                            final updatedMaintenanceObject = maintenanceObject
                                .copyWith(consumptions: updatedConsumptions);
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
                          consumption.description,
                        ),
                      ),
                    );
                  },

                  itemCount: maintenanceObject.consumptions.length,
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item =
                        maintenanceObject.consumptions.removeAt(oldIndex);
                    maintenanceObject.consumptions.insert(newIndex, item);

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
