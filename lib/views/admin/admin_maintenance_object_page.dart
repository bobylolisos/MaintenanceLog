import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/views/admin/admin_maintenance_object_consumption_tab_view.dart';
import 'package:maintenance_log/views/admin/admin_maintenance_object_information_tab_view.dart';
import 'package:maintenance_log/views/admin/admin_maintenance_object_maintenance_tab_view.dart';
import 'package:maintenance_log/widgets/sub_header_app_bar.dart';

class AdminMaintenanceObjectPage extends StatefulWidget {
  final MaintenanceObject maintenanceObject;

  const AdminMaintenanceObjectPage(
      {required this.maintenanceObject, super.key});

  @override
  State<AdminMaintenanceObjectPage> createState() =>
      _AdminMaintenanceObjectPageState();
}

class _AdminMaintenanceObjectPageState
    extends State<AdminMaintenanceObjectPage> {
  final ValueNotifier<int> _selectedTabIndexNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _selectedTabIndexNotifier,
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: colorLightGrey,
          appBar: SubHeaderAppBar(title: widget.maintenanceObject.name),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 6.0, right: 6, top: 6),
              child: Builder(builder: (context) {
                return _resolveTabView();
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
      },
    );
  }

  Widget _resolveTabView() {
    if (_selectedTabIndexNotifier.value == 0) {
      return AdminMaintenanceObjectInformationTabView(
        maintenanceObject: widget.maintenanceObject,
      );
    }
    if (_selectedTabIndexNotifier.value == 1) {
      return AdminMaintenanceObjectConsumptionTabView(
        maintenanceObject: widget.maintenanceObject,
      );
    }
    if (_selectedTabIndexNotifier.value == 2) {
      return AdminMaintenanceObjectMaintenanceTabView(
        maintenanceObject: widget.maintenanceObject,
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
