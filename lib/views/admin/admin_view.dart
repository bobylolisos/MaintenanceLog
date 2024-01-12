import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/blocs/maintenance_objects_bloc/maintenance_objects_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_objects_bloc/maintenance_objects_event.dart';
import 'package:maintenance_log/blocs/maintenance_objects_bloc/maintenance_objects_state.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'package:maintenance_log/views/admin/add_maintenance_object_dialog.dart';
import 'package:maintenance_log/views/admin/admin_maintenance_object_view.dart';
import 'package:maintenance_log/widgets/maintenace_object_card.dart';
import 'package:maintenance_log/widgets/sub_header_app_bar.dart';

import '../../widgets/add_card.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                    child: AddCard(
                      text: 'Lägg till nytt objekt',
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AddMaintenanceObjectDialog();
                          },
                        );
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
                            final maintenanceObjects = state.maintenanceObjects;
                            return ReorderableListView.builder(
                              proxyDecorator: (child, index, animation) =>
                                  Material(
                                color: colorGold.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                                child: child,
                              ),
                              itemCount: state.maintenanceObjects.length,
                              itemBuilder: (context, index) {
                                final maintenanceObject =
                                    state.maintenanceObjects.elementAt(index);
                                return Padding(
                                  key: ValueKey(maintenanceObject.id),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 5),
                                  child: MaintenanceObjectCard(
                                    maintenanceObject: maintenanceObject,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AdminMaintenanceObjectView(
                                              maintenanceObject:
                                                  maintenanceObject,
                                            ),
                                          ));
                                    },
                                    trailing:
                                        Icon(Icons.reorder, color: colorBlue),
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
    );
  }
}
