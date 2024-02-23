import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_event.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_state.dart';
import 'package:maintenance_log/extensions/date_time_extensions.dart';
import 'package:maintenance_log/models/consumption.dart';
import 'package:maintenance_log/models/consumption_item.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/models/meter_type.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'package:maintenance_log/widgets/maintenance_object_item_card.dart';
import 'package:maintenance_log/widgets/sub_header_app_bar.dart';

class ConsumptionPage extends StatelessWidget {
  final String maintenanceObjectId;
  final String maintenanceObjectName;
  final String consumptionId;
  late MaintenanceObject maintenanceObject;
  late Consumption consumption;

  ConsumptionPage(
      {required this.maintenanceObjectId,
      required this.maintenanceObjectName,
      required this.consumptionId,
      super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MaintenanceObjectBloc>(
      create: (context) => MaintenanceObjectBloc(
        maintenanceObjectRepository: ioc.get(),
      ),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: colorLightGrey,
          appBar: SubHeaderAppBar(
            title: maintenanceObjectName,
            onTrailingAddTap: () async {
              final maintenanceObjectBloc =
                  context.read<MaintenanceObjectBloc>();
              final changedConsumptionItem = await showDialog<ConsumptionItem?>(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return Placeholder();
                  // return AddEditMaintenanceItemDialog(
                  //   maintenance: maintenance,
                  // );
                },
              );

              if (changedConsumptionItem != null) {
                // maintenanceObjectBloc.add(
                //   ConsumptionItemChangedEvent(
                //       maintenanceObject: maintenanceObject,
                //       maintenanceItem: changedConsumptionItem),
                // );
              }
            },
          ),
          body: Builder(builder: (context) {
            return BlocBuilder<MaintenanceObjectBloc, MaintenanceObjectState>(
                bloc: context.read<MaintenanceObjectBloc>()
                  ..add(MaintenanceObjectSubscriptionEvent(
                      maintenanceObjectId: maintenanceObjectId)),
                builder: (context, state) {
                  if (state is MaintenanceObjectUpdatedState) {
                    maintenanceObject = state.maintenanceObject;
                    consumption = state.maintenanceObject.consumptions
                        .firstWhere((x) => x.id == consumptionId);

                    var totalCosts = consumption.posts.isNotEmpty
                        ? consumption.posts
                            .map((e) => e.costs)
                            .reduce((a, b) => a + b)
                        : 0;
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 6.0, right: 6, top: 6),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  MaintenanceObjectItemCard(
                                    title: 'Förbrukning',
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            consumption.name,
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: colorBlue,
                                            ),
                                          ),
                                        ),
                                        consumption.description.isNotEmpty
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Text(
                                                  consumption.description,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: colorBlue,
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                        Row(
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.coins,
                                              color: colorBlue,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '$totalCosts kr',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: colorBlue,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.coins,
                                              color: colorBlue,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '${totalCosts} kr/km', // TODO
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: colorBlue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  MaintenanceObjectItemCard(
                                    title: 'Poster',
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: _createPosts(context,
                                          state.maintenanceObject, consumption),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Center(
                    child: SizedBox(
                        height: 60,
                        width: 60,
                        child: CircularProgressIndicator()),
                  );
                });
          }),
        );
      }),
    );
  }

  List<Widget> _createPosts(BuildContext context,
      MaintenanceObject maintenanceObject, Consumption consumption) {
    if (consumption.posts.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              'Inga poster finns registrerade ännu.',
              style: TextStyle(fontSize: 18, color: colorBlue.withOpacity(0.5)),
            ),
          ),
        )
      ];
    }

    final result = List<Widget>.empty(growable: true);
    for (var i = 0; i < consumption.posts.length; i++) {
      final maintenanceItem = consumption.posts.elementAt(i);

      result.add(_createPost(
          context, maintenanceObject, maintenanceItem, consumption.meterType));
    }
    return result;
  }

  Widget _createPost(BuildContext context, MaintenanceObject maintenanceObject,
      ConsumptionItem consumptionItem, MeterType meterType) {
    final maintenanceObjectBloc = context.read<MaintenanceObjectBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Dismissible(
          key: ValueKey(consumptionItem.id),
          background: Container(
            color: Colors.transparent,
          ),
          secondaryBackground: Container(
            color: Colors.red,
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.delete, color: Colors.white),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text('Radera', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              var shouldDelete = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Radera post'),
                    content: const Text(
                        'Posten kommer nu tas bort och kan inte återskapas. \n\n Vill du fortsätta med att radera?'),
                    actions: <Widget>[
                      SizedBox(
                        width: 130,
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                              backgroundColor: colorGold.withOpacity(0.5),
                              foregroundColor: colorBlue),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Nej'),
                        ),
                      ),
                      SizedBox(
                        width: 130,
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                              backgroundColor: colorBlue,
                              foregroundColor: colorGold),
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Ja'),
                        ),
                      ),
                    ],
                  );
                },
              );

              if (shouldDelete) {
                return Future.value(true);
              }
            }

            return Future.value(false);
          },
          onDismissed: (direction) {
            // maintenanceObjectBloc.add(
            //   MaintenanceItemDeletedEvent(
            //       maintenanceObject: maintenanceObject,
            //       maintenanceItem: consumptionItem),
            // );
          },
          child: InkWell(
            splashColor: colorGold.withOpacity(0.4),
            highlightColor: Colors.transparent,
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => MaintenanceItemEditPage(
              //     maintenanceObject: maintenanceObject,
              //     maintenance: maintenance,
              //     maintenanceItem: consumptionItem,
              //   ),
              // ));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  consumptionItem.date.toDateText(),
                  style: TextStyle(fontSize: 20, color: colorBlue),
                ),
                SizedBox(
                  height: 5,
                ),
                _row(consumptionItem.date.toTime(), FontAwesomeIcons.clock),
                // meterType != MeterType.none
                //     ? _row(
                //         consumptionItem.meterValue != null
                //             ? '${consumptionItem.meterValue} ${meterType.displaySuffix}'
                //             : '-',
                //         FontAwesomeIcons.leftRight)
                //     : Container(),
                _row('${consumptionItem.costs} kr', FontAwesomeIcons.coins),
                _row(
                    consumptionItem.note.isNotEmpty
                        ? consumptionItem.note
                        : '-',
                    FontAwesomeIcons.clipboard),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _row(String text, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, right: 10, bottom: 2, top: 2),
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
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
            style: TextStyle(fontSize: 12, color: colorBlue),
          ),
        ),
      ],
    );
  }
}
