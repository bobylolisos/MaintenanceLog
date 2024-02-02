import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_event.dart';
import 'package:maintenance_log/models/maintenance_item.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/views/maintenance_object/maintenance_tab/add_edit_maintenance_item_dialog.dart';
import 'package:maintenance_log/widgets/maintenance_object_item_card.dart';

class MaintenanceItemsCardsBuilder {
  static List<Widget> create(MaintenanceObject maintenanceObject) {
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
          onTap: () {},
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
                splashColor: colorGold,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item.description.isNotEmpty
                  ? Text(item.description)
                  : Container(),
              item.description.isNotEmpty
                  ? SizedBox(
                      height: 6,
                    )
                  : Container(),
              Text('Total utgift: $totalCosts kr'),
              SizedBox(
                height: 6,
              ),
              postCount > 0
                  ? Text(
                      'Föregående post',
                      style: TextStyle(
                          color: colorBlue, fontWeight: FontWeight.w600),
                    )
                  : Container(),
              postCount > 0
                  ? Text(
                      ' ${item.posts.first.header}',
                      style: TextStyle(color: colorBlue),
                    )
                  : Container(),
              postCount > 0
                  ? Text(
                      ' ${item.posts.first.date.toString().substring(0, 10)}',
                      style: TextStyle(color: colorBlue),
                    )
                  : Container(),
              postCount > 0
                  ? Text(
                      ' ${item.posts.first.meterValue.toString()} km', //Todo: Can be hour
                      style: TextStyle(color: colorBlue),
                    )
                  : Container(),
              postCount > 0
                  ? Text(
                      ' ${item.posts.first.costs.toString()} kr',
                      style: TextStyle(color: colorBlue),
                    )
                  : Container(),
              postCount > 0
                  ? Text(
                      ' ${item.posts.first.note}',
                      style: TextStyle(color: colorBlue),
                    )
                  : Container(),
            ],
          ),
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
}
