import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_event.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_state.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'package:maintenance_log/views/admin/admin_maintenance_object_consumption_tab_view.dart';
import 'package:maintenance_log/views/admin/admin_maintenance_object_information_tab_view.dart';
import 'package:maintenance_log/views/admin/admin_maintenance_object_maintenance_tab_view.dart';
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
            ..add(MaintenanceObjectGetEvent(
                maintenanceObjectId: widget.maintenanceObjectId)),
      child: ValueListenableBuilder(
        valueListenable: _selectedTabIndexNotifier,
        builder: (context, value, child) {
          return BlocBuilder<MaintenanceObjectBloc, MaintenanceObjectState>(
            bloc: context.read<MaintenanceObjectBloc>(),
            builder: (context, state) {
              if (state is MaintenanceObjectUpdatedState) {
                final maintenanceObject = state.maintenanceObject;
                return Scaffold(
                  backgroundColor: colorLightGrey,
                  appBar: SubHeaderAppBar(title: maintenanceObject.name),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 6.0, right: 6, top: 6),
                      child: Builder(builder: (context) {
                        return _resolveTabView(maintenanceObject);
                      }),
                    ),
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
                            label: 'Underhållsobjekt'),
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

  Widget _resolveTabView(MaintenanceObject maintenanceObject) {
    if (_selectedTabIndexNotifier.value == 0) {
      return AdminMaintenanceObjectInformationTabView(
        maintenanceObject: maintenanceObject,
      );
    }
    if (_selectedTabIndexNotifier.value == 1) {
      return AdminMaintenanceObjectConsumptionTabView(
        maintenanceObject: maintenanceObject,
      );
    }
    if (_selectedTabIndexNotifier.value == 2) {
      return AdminMaintenanceObjectMaintenanceTabView(
        maintenanceObject: maintenanceObject,
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
