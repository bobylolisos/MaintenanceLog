import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_event.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_state.dart';
import 'package:maintenance_log/extensions/meter_type_extensions.dart';
import 'package:maintenance_log/models/maintenance.dart';
import 'package:maintenance_log/models/maintenance_item.dart';
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
                              children: _createPosts(maintenance),
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

  List<Widget> _createPosts(Maintenance maintenance) {
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
      final post = maintenance.posts.elementAt(i);

      result.add(_createPost(post, maintenance.meterType));
    }
    return result;
  }

  Widget _createPost(MaintenanceItem post, MeterType meterType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          splashColor: colorGold.withOpacity(0.4),
          highlightColor: Colors.transparent,
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.date.toString().substring(0, 16),
                style: TextStyle(fontSize: 18, color: colorBlue),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                post.header,
                style: TextStyle(fontSize: 12, color: colorBlue),
              ),
              meterType != MeterType.none && post.meterValue != null
                  ? Text(
                      '${post.meterValue} ${meterType.displaySuffix}',
                      style: TextStyle(fontSize: 12, color: colorBlue),
                    )
                  : Container(),
              Text(
                '${post.costs} kr',
                style: TextStyle(fontSize: 12, color: colorBlue),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
