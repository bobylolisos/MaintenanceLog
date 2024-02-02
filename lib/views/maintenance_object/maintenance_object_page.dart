import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_event.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_state.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'package:maintenance_log/views/maintenance_object/maintenance_tab/maintenance_object_maintenance_tab_view.dart';
import 'package:maintenance_log/views/maintenance_object/statistics_tab/maintenance_object_statistic_tab_view.dart';
import 'package:maintenance_log/views/maintenance_object/timeline_tab/maintenance_object_timeline_tab_view.dart';
import 'package:maintenance_log/widgets/sub_header_app_bar.dart';

// ignore: must_be_immutable
class MaintenanceObjectPage extends StatefulWidget {
  MaintenanceObject maintenanceObject;
  MaintenanceObjectPage({required this.maintenanceObject, super.key});

  @override
  State<MaintenanceObjectPage> createState() => _MaintenanceObjectPageState();
}

class _MaintenanceObjectPageState extends State<MaintenanceObjectPage> {
  late ValueNotifier<int> _selectedTabIndexNotifier;

  @override
  void initState() {
    _selectedTabIndexNotifier = ValueNotifier(0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MaintenanceObjectBloc>(
      create: (BuildContext context) => MaintenanceObjectBloc(
        maintenanceObjectRepository: ioc.get(),
      )..add(MaintenanceObjectSubscriptionEvent(
          maintenanceObjectId: widget.maintenanceObject.id)),
      child: ValueListenableBuilder(
        valueListenable: _selectedTabIndexNotifier,
        builder: (context, value, child) {
          return Scaffold(
            backgroundColor: colorLightGrey,
            appBar: SubHeaderAppBar(title: widget.maintenanceObject.header),
            body: Padding(
              padding: const EdgeInsets.only(left: 6.0, right: 6, top: 6),
              child: BlocBuilder<MaintenanceObjectBloc, MaintenanceObjectState>(
                bloc: context.read<MaintenanceObjectBloc>(),
                builder: (BuildContext context, MaintenanceObjectState state) {
                  if (state is MaintenanceObjectUpdatedState) {
                    return _resolveTabView(state.maintenanceObject);
                  }
                  return Center(
                      child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ));
                },
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
                          FontAwesomeIcons.wrench,
                        ),
                      ),
                      label: 'Underhåll'),
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: FaIcon(
                            size: 14,
                            FontAwesomeIcons.timeline,
                          ),
                        ),
                      ),
                      label: 'Tidslinje'),
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: FaIcon(
                          FontAwesomeIcons.chartLine,
                        ),
                      ),
                      label: 'Statistik'),
                ]),
          );
        },
      ),
    );
  }

  Widget _resolveTabView(MaintenanceObject maintenanceObject) {
    if (_selectedTabIndexNotifier.value == 0) {
      return MaintenanceObjectMaintenanceTabView(
        maintenanceObject: maintenanceObject,
      );
    }
    if (_selectedTabIndexNotifier.value == 1) {
      return MaintenanceObjectTimelineTabView();
    }
    if (_selectedTabIndexNotifier.value == 2) {
      return MaintenanceObjectStatisticTabView();
    }
    return Center(child: Text('N O T   I M P L E M E N T E D'));
  }

  @override
  void dispose() {
    _selectedTabIndexNotifier.dispose();
    super.dispose();
  }
}
