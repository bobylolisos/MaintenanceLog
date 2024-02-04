import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_event.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_state.dart';
import 'package:maintenance_log/extensions/meter_type_extensions.dart';
import 'package:maintenance_log/models/maintenance.dart';
import 'package:maintenance_log/models/maintenance_item.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/models/meter_type.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'package:maintenance_log/widgets/maintenance_object_item_card.dart';
import 'package:maintenance_log/widgets/sub_header_app_bar.dart';

class MaintenanceOverviewPage extends StatelessWidget {
  final String maintenanceObjectId;
  final String maintenanceObjectName;
  final String maintenanceId;
  const MaintenanceOverviewPage(
      {required this.maintenanceObjectId,
      required this.maintenanceObjectName,
      required this.maintenanceId,
      super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MaintenanceObjectBloc>(
      create: (context) => MaintenanceObjectBloc(
        maintenanceObjectRepository: ioc.get(),
      ),
      child: Scaffold(
        backgroundColor: colorLightGrey,
        appBar: SubHeaderAppBar(title: maintenanceObjectName),
        body: Builder(builder: (context) {
          return BlocBuilder<MaintenanceObjectBloc, MaintenanceObjectState>(
              bloc: context.read<MaintenanceObjectBloc>()
                ..add(MaintenanceObjectSubscriptionEvent(
                    maintenanceObjectId: maintenanceObjectId)),
              builder: (context, state) {
                if (state is MaintenanceObjectUpdatedState) {
                  final maintenance = state.maintenanceObject.maintenances
                      .firstWhere((x) => x.id == maintenanceId);

                  var totalCosts = maintenance.posts.isNotEmpty
                      ? maintenance.posts
                          .map((e) => e.costs)
                          .reduce((a, b) => a + b)
                      : 0;
                  return Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6, top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MaintenanceObjectItemCard(
                          title: 'Underhållspunkt',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                maintenance.name,
                                style: TextStyle(
                                  fontSize: 22,
                                  color: colorBlue,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                maintenance.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorBlue,
                                ),
                              ),
                              SizedBox(
                                height: 10,
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
                        SizedBox(
                          height: 10,
                        ),
                        MaintenanceObjectItemCard(
                          title: 'Poster',
                          child: Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _createPosts(context,
                                  state.maintenanceObject, maintenance),
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
      ),
    );
  }

  List<Widget> _createPosts(BuildContext context,
      MaintenanceObject maintenanceObject, Maintenance maintenance) {
    if (maintenance.posts.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              'Inga poster finns gjorda ännu.',
              style: TextStyle(fontSize: 18, color: colorBlue.withOpacity(0.5)),
            ),
          ),
        )
      ];
    }

    final result = List<Widget>.empty(growable: true);
    for (var i = 0; i < maintenance.posts.length; i++) {
      final maintenanceItem = maintenance.posts.elementAt(i);

      result.add(_createPost(
          context, maintenanceObject, maintenanceItem, maintenance.meterType));
    }
    return result;
  }

  Widget _createPost(BuildContext context, MaintenanceObject maintenanceObject,
      MaintenanceItem maintenanceItem, MeterType meterType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Dismissible(
          key: ValueKey(maintenanceItem.id),
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
              final maintenanceObjectBloc =
                  context.read<MaintenanceObjectBloc>();
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
                maintenanceObjectBloc.add(
                  MaintenanceItemDeletedEvent(
                      maintenanceObject: maintenanceObject,
                      maintenanceItem: maintenanceItem),
                );
              }
            }

            return Future.value(false);
          },
          onDismissed: (direction) {
            // Do STUFF
          },
          child: InkWell(
            splashColor: colorGold.withOpacity(0.4),
            highlightColor: Colors.transparent,
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  maintenanceItem.date.toString().substring(0, 16),
                  style: TextStyle(fontSize: 18, color: colorBlue),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  maintenanceItem.header,
                  style: TextStyle(fontSize: 12, color: colorBlue),
                ),
                meterType != MeterType.none &&
                        maintenanceItem.meterValue != null
                    ? Text(
                        '${maintenanceItem.meterValue} ${meterType.displaySuffix}',
                        style: TextStyle(fontSize: 12, color: colorBlue),
                      )
                    : Container(),
                Text(
                  '${maintenanceItem.costs} kr',
                  style: TextStyle(fontSize: 12, color: colorBlue),
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
