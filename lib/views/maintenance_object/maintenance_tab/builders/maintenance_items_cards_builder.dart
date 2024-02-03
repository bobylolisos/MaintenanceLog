import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_event.dart';
import 'package:maintenance_log/extensions/meter_type_extensions.dart';
import 'package:maintenance_log/models/maintenance_item.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/views/maintenance_object/maintenance_tab/add_edit_maintenance_item_dialog.dart';
import 'package:maintenance_log/views/maintenance_object/maintenance_tab/maintenance_overview_page.dart';
import 'package:maintenance_log/widgets/maintenance_object_item_card.dart';

class MaintenanceItemsCardsBuilder {
  static List<Widget> create(
      BuildContext context, MaintenanceObject maintenanceObject) {
    final result = List<Widget>.empty(growable: true);

    final items = maintenanceObject.maintenances;

    for (var item in items) {
      var totalCosts = 0;
      for (var post in item.posts) {
        totalCosts += post.costs;
      }

      var postCount = item.posts.length;
      result.add(
        MaintenanceObjectItemCard(
          title: item.name,
          postCount: postCount,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MaintenanceOverviewPage(
                maintenanceObjectId: maintenanceObject.id,
                maintenanceObjectName: maintenanceObject.header,
                maintenanceId: item.id,
              ),
            ));
          },
          trailing: Container(
            height: 35,
            decoration: BoxDecoration(
              color: colorBlue,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorBlue,
                width: 2.0,
              ),
            ),
            child: Builder(builder: (context) {
              return InkWell(
                splashColor: colorGold.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                onTap: () async {
                  final maintenanceObjectBloc =
                      context.read<MaintenanceObjectBloc>();
                  final changedMaintenanceItem =
                      await showDialog<MaintenanceItem?>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AddEditMaintenanceItemDialog(
                        maintenance: item,
                      );
                    },
                  );

                  if (changedMaintenanceItem != null) {
                    maintenanceObjectBloc.add(
                      MaintenanceItemChangedEvent(
                          maintenanceObject: maintenanceObject,
                          maintenanceItem: changedMaintenanceItem),
                    );
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.add,
                    color: colorGold,
                  ),
                ),
              );
            }),
          ),
          trailingVerticalAlignment: CrossAxisAlignment.end,
          child: Builder(builder: (context) {
            final latestPost = postCount > 0 ? item.posts.first : null;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                item.description.isNotEmpty
                    ? Text(
                        item.description,
                        style: TextStyle(color: colorBlue),
                      )
                    : Container(),
                item.description.isNotEmpty
                    ? SizedBox(
                        height: 10,
                      )
                    : Container(),
                Row(
                  children: [
                    SizedBox(
                      width: 2,
                    ),
                    FaIcon(
                      FontAwesomeIcons.coins,
                      size: 18,
                      color: colorBlue,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '$totalCosts kr',
                      style: TextStyle(color: colorBlue),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                latestPost != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              'Föregående post',
                              style: TextStyle(
                                  color: colorBlue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),
                          ),
                          _previousPostRowItem(
                            latestPost.date.toString().substring(0, 10),
                            FontAwesomeIcons.calendar,
                          ),
                          _previousPostRowItem(
                            latestPost.header,
                            FontAwesomeIcons.tag,
                          ),
                          _previousPostRowItem(
                              '${latestPost.meterValue} ${maintenanceObject.meterType.displaySuffix}',
                              FontAwesomeIcons.leftRight,
                              additionalValidation: () =>
                                  latestPost.meterValue != null),
                          _previousPostRowItem(
                            '${latestPost.costs} kr',
                            FontAwesomeIcons.coins,
                          ),
                          _previousPostRowItem(
                            latestPost.note,
                            FontAwesomeIcons.clipboard,
                          ),
                        ],
                      )
                    : Container(),
              ],
            );
          }),
        ),
      );

      result.add(
        SizedBox(
          height: 10,
        ),
      );
    }

    return result;
  }

  static Widget _previousPostRowItem(String value, IconData icon,
      {bool Function()? additionalValidation}) {
    return additionalValidation == null || additionalValidation()
        ? Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 4, right: 10, bottom: 2, top: 2),
                child: SizedBox(
                  width: 15,
                  height: 15,
                  child: Center(
                    child: FaIcon(
                      icon,
                      size: 14,
                      color: colorBlue,
                    ),
                  ),
                ),
              ),
              Text(
                value,
                style: TextStyle(color: colorBlue),
              ),
            ],
          )
        : Container();
  }
}
