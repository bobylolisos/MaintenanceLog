import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_event.dart';
import 'package:maintenance_log/extensions/meter_type_extensions.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/views/admin/add_edit_maintenance_object_dialog.dart';
import 'package:maintenance_log/widgets/maintenance_object_item_card.dart';

class AdminMaintenanceObjectInformationTabView extends StatelessWidget {
  final MaintenanceObject maintenanceObject;

  const AdminMaintenanceObjectInformationTabView(
      {required this.maintenanceObject, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MaintenanceObjectItemCard(
          title: 'Grunddata',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _paddedText(maintenanceObject.header, fontSize: 24),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 35,
                    decoration: BoxDecoration(
                      color: colorBlue,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorBlue,
                        width: 2.0,
                      ),
                    ),
                    child: InkWell(
                      splashColor: colorGold,
                      borderRadius: BorderRadius.circular(20),
                      onTap: () async {
                        final maintenanceObjectBloc =
                            context.read<MaintenanceObjectBloc>();
                        final changedMaintenanceObject =
                            await showDialog<MaintenanceObject?>(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AddEditMaintenanceObjectDialog(
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
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: FaIcon(
                          FontAwesomeIcons.pen,
                          color: colorGold,
                          size: 15,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              _paddedText(maintenanceObject.subHeader),
              _paddedText(maintenanceObject.meterType.displayName),
              maintenanceObject.isActive
                  ? _paddedText('Aktiv')
                  : _paddedText('Inaktiv', fontColor: Colors.red),
              SizedBox(
                height: 10,
              ),
              _paddedText(maintenanceObject.description)
            ],
          ),
        ),
      ],
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
