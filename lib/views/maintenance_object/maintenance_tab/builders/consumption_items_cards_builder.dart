import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/extensions/date_time_extensions.dart';
import 'package:maintenance_log/extensions/meter_type_extensions.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/models/meter_type.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/views/maintenance_object/maintenance_tab/consumption_page.dart';
import 'package:maintenance_log/widgets/maintenance_object_item_card.dart';

class ConsumptionItemsCardsBuilder {
  static List<Widget> create(
      BuildContext context, MaintenanceObject maintenanceObject) {
    final result = List<Widget>.empty(growable: true);

    final items = maintenanceObject.consumptions;

    for (var item in items) {
      num totalCosts = 0;
      for (var post in item.posts) {
        totalCosts += post.pricePerLitre * post.litre;
      }

      var postCount = item.posts.length;
      result.add(
        MaintenanceObjectItemCard(
          title: item.name,
          postCount: postCount,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ConsumptionPage(
                maintenanceObjectId: maintenanceObject.id,
                maintenanceObjectName: maintenanceObject.header,
                consumptionId: item.id,
              ),
            ));
            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) => MaintenancePage(
            //     maintenanceObjectId: maintenanceObject.id,
            //     maintenanceObjectName: maintenanceObject.header,
            //     maintenanceId: item.id,
            //   ),
            // ));
          },
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
                    : SizedBox(
                        height: 5,
                      ),
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
                      '${totalCosts.toStringAsFixed(0)} kr',
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
                            latestPost.date.toDate(),
                            FontAwesomeIcons.calendar,
                          ),
                          _previousPostRowItem(
                              latestPost.meterValue != null
                                  ? '${latestPost.meterValueString} ${maintenanceObject.meterType.displaySuffix}'
                                  : '-',
                              FontAwesomeIcons.rightToBracket,
                              additionalValidation: () =>
                                  maintenanceObject.meterType !=
                                  MeterType.none),
                          _previousPostRowItem(
                            '${(latestPost.pricePerLitre * latestPost.litre).toStringAsFixed(0)} kr',
                            FontAwesomeIcons.coins,
                          ),
                          _previousPostRowItem(
                            latestPost.note.isNotEmpty ? latestPost.note : '-',
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
    }

    return result;
  }

  static Widget _previousPostRowItem(String value, IconData icon,
      {bool Function()? additionalValidation}) {
    return additionalValidation == null || additionalValidation()
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(color: colorBlue),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )
        : Container();
  }
}