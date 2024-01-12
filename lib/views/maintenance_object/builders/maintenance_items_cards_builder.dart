import 'package:flutter/material.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/widgets/maintenance_object_item_card.dart';

class MaintenanceItemsCardsBuilder {
  static List<Widget> create(MaintenanceObject maintenanceObject) {
    final result = List<Widget>.empty(growable: true);

    final items = maintenanceObject.maintenanceItems;
    items.sort(
      (a, b) => a.sortOrder.compareTo(b.sortOrder),
    );

    for (var item in items) {
      var totalCosts = 0;
      for (var element in item.posts) {
        totalCosts += element.costs;
      }

      var postCount = item.posts.length;
      result.add(
        MaintenanceObjectItemCard(
          title: item.name,
          postCount: postCount,
          onTap: () {},
          onAddTap: () {},
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
