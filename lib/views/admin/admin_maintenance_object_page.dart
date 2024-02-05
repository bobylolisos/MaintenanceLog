import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_event.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_state.dart';
import 'package:maintenance_log/models/maintenance.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'package:maintenance_log/views/admin/consumption_tab/admin_maintenance_object_consumption_tab_view.dart';
import 'package:maintenance_log/views/admin/information_tab/admin_maintenance_object_information_tab_view.dart';
import 'package:maintenance_log/views/admin/maintenance_tab/add_edit_maintenance_dialog.dart';
import 'package:maintenance_log/views/admin/maintenance_tab/admin_maintenance_object_maintenance_tab_view.dart';
import 'package:maintenance_log/widgets/sub_header_app_bar.dart';

class AdminMaintenanceObjectPage extends StatefulWidget {
  final String maintenanceObjectId;

  const AdminMaintenanceObjectPage(
      {required this.maintenanceObjectId, super.key});

  @override
  State<AdminMaintenanceObjectPage> createState() =>
      _AdminMaintenanceObjectPageState();
}

class _AdminMaintenanceObjectPageState
    extends State<AdminMaintenanceObjectPage> {
  late ValueNotifier<int> _selectedTabIndexNotifier;

  @override
  void initState() {
    _selectedTabIndexNotifier = ValueNotifier(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MaintenanceObjectBloc>(
      create: (context) =>
          MaintenanceObjectBloc(maintenanceObjectRepository: ioc.get())
            ..add(MaintenanceObjectSubscriptionEvent(
                maintenanceObjectId: widget.maintenanceObjectId)),
      child: ValueListenableBuilder(
        valueListenable: _selectedTabIndexNotifier,
        builder: (context, selectedTabIndex, child) {
          return BlocBuilder<MaintenanceObjectBloc, MaintenanceObjectState>(
            bloc: context.read<MaintenanceObjectBloc>(),
            builder: (context, state) {
              if (state is MaintenanceObjectUpdatedState) {
                final maintenanceObject = state.maintenanceObject;
                return Scaffold(
                  backgroundColor: colorLightGrey,
                  appBar: _resolveAppBar(
                      selectedTabIndex, maintenanceObject, context),
                  body: Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6, top: 6),
                    child: Builder(builder: (context) {
                      return _resolveTabView(
                          selectedTabIndex, maintenanceObject);
                    }),
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                      iconSize: 18,
                      selectedFontSize: 16,
                      currentIndex: _selectedTabIndexNotifier.value,
                      backgroundColor: colorBlue,
                      selectedItemColor: colorGold,
                      unselectedItemColor: colorGold.withOpacity(0.5),
                      onTap: (value) {
                        _selectedTabIndexNotifier.value = value;
                      },
                      items: [
                        BottomNavigationBarItem(
                            icon: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FaIcon(
                                FontAwesomeIcons.house,
                              ),
                            ),
                            label: 'Information'),
                        BottomNavigationBarItem(
                            icon: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FaIcon(
                                FontAwesomeIcons.gasPump,
                              ),
                            ),
                            label: 'Förbrukningar'),
                        BottomNavigationBarItem(
                            icon: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FaIcon(
                                FontAwesomeIcons.wrench,
                              ),
                            ),
                            label: 'Underhållspunkter'),
                      ]),
                );
              }

              return Center(
                child: SizedBox(
                    height: 60, width: 60, child: CircularProgressIndicator()),
              );
            },
          );
        },
      ),
    );
  }

  PreferredSizeWidget _resolveAppBar(
    int selectedTabIndex,
    MaintenanceObject maintenanceObject,
    BuildContext context,
  ) {
    if (selectedTabIndex == 1) {
      return SubHeaderAppBar(title: maintenanceObject.header);
    }

    if (selectedTabIndex == 2) {
      return SubHeaderAppBar(
          title: maintenanceObject.header,
          onTrailingAddTap: () async {
            final maintenanceObjectBloc = context.read<MaintenanceObjectBloc>();
            final addedMaintenance = await showDialog<Maintenance?>(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AddEditMaintenanceDialog(
                  maintenanceObject: maintenanceObject,
                );
              },
            );

            if (addedMaintenance != null) {
              maintenanceObjectBloc.add(
                MaintenanceAddedEvent(
                  maintenanceObject: maintenanceObject,
                  maintenance: addedMaintenance,
                ),
              );
            }
          });
    }

    return SubHeaderAppBar(title: maintenanceObject.header);
  }

  Widget _resolveTabView(
    int selectedTabIndex,
    MaintenanceObject maintenanceObject,
  ) {
    if (selectedTabIndex == 0) {
      return AdminMaintenanceObjectInformationTabView(
        maintenanceObject: maintenanceObject,
      );
    }
    if (selectedTabIndex == 1) {
      return AdminMaintenanceObjectConsumptionTabView(
        maintenanceObject: maintenanceObject,
      );
    }
    if (selectedTabIndex == 2) {
      return AdminMaintenanceObjectMaintenanceTabView(
        maintenanceObjectId: maintenanceObject.id,
      );
    }
    return Center(child: Text('N O T   I M P L E M E N T E D'));
  }

  @override
  void dispose() {
    _selectedTabIndexNotifier.dispose();
    super.dispose();
  }
}
