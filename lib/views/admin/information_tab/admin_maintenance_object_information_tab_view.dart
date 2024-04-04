import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_event.dart';
import 'package:maintenance_log/extensions/meter_type_extensions.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/views/admin/information_tab/add_edit_maintenance_object_bottom_sheet.dart';
import 'package:maintenance_log/widgets/bls_bottom_sheet.dart';
import 'package:maintenance_log/widgets/maintenance_object_item_card.dart';

class AdminMaintenanceObjectInformationTabView extends StatelessWidget {
  final MaintenanceObject maintenanceObject;

  const AdminMaintenanceObjectInformationTabView(
      {required this.maintenanceObject, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MaintenanceObjectItemCard(
            title: 'Grunddata',
            onTap: () async {
              final maintenanceObjectBloc =
                  context.read<MaintenanceObjectBloc>();
              final changedMaintenanceObject =
                  await showBlsBottomSheet<MaintenanceObject?>(
                context: context,
                builder: (context) {
                  return AddEditMaintenanceObjectBottomSheet(
                    maintenanceObject: maintenanceObject,
                  );
                },
              );

              if (changedMaintenanceObject != null) {
                maintenanceObjectBloc.add(
                  MaintenanceObjectSaveEvent(
                      maintenanceObject: changedMaintenanceObject),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child:
                          _paddedText(maintenanceObject.header, fontSize: 24),
                    ),
                    SizedBox(
                      height: 40,
                      width: 60,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                          value: maintenanceObject.isActive,
                          inactiveThumbColor: Colors.red,
                          inactiveTrackColor: Colors.red.withOpacity(0.5),
                          trackOutlineColor:
                              MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return Colors.green.withOpacity(0.3);
                            }
                            return Colors.red.withOpacity(0.3);
                          }),
                          activeColor: Colors.green,
                          onChanged: (value) {
                            final maintenanceObjectBloc =
                                context.read<MaintenanceObjectBloc>();
                            maintenanceObjectBloc.add(
                              MaintenanceObjectSaveEvent(
                                maintenanceObject: maintenanceObject.copyWith(
                                    isActive: value, sortOrder: 2000),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                _paddedText(maintenanceObject.subHeader),
                _paddedText(maintenanceObject.meterType.displayName),
                _paddedText(maintenanceObject.description)
              ],
            ),
          ),
          MaintenanceObjectItemCard(
            title: 'Bilder',
            child: SizedBox(
              height: 300,
              child: Text('Fina bilder här'),
            ),
          )
        ],
      ),
    );
  }

  Widget _paddedText(String text, {double? fontSize, Color? fontColor}) {
    if (text.isEmpty) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Text(
        text,
        maxLines: 10,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: fontColor ?? colorBlue, fontSize: fontSize),
      ),
    );
  }
}
