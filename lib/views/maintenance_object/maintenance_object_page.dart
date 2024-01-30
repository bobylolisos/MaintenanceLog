import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_state.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'package:maintenance_log/views/maintenance_object/builders/consumption_card_builder.dart';
import 'package:maintenance_log/widgets/maintenance_object_item_card.dart';
import 'package:maintenance_log/widgets/sub_header_app_bar.dart';

import 'builders/maintenance_items_cards_builder.dart';
import 'builders/maintenance_object_information_card_builder.dart';

// ignore: must_be_immutable
class MaintenanceObjectPage extends StatelessWidget {
  MaintenanceObject maintenanceObject;
  MaintenanceObjectPage({required this.maintenanceObject, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorLightGrey,
      appBar: SubHeaderAppBar(title: 'Underhåll'),
      body: BlocProvider<MaintenanceObjectBloc>(
        create: (BuildContext context) => MaintenanceObjectBloc(
          maintenanceObjectRepository: ioc.get(),
        ),
        child: Builder(builder: (context) {
          return BlocBuilder<MaintenanceObjectBloc, MaintenanceObjectState>(
            builder: (BuildContext context, MaintenanceObjectState state) {
              if (state is MaintenanceObjectUpdatedState) {
                maintenanceObject = state.maintenanceObject;
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 6.0, right: 6, top: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // ----------- Object information ----------
                      MaintenanceObjectInformationCardBuilder.create(
                          maintenanceObject),
                      SizedBox(
                        height: 10,
                      ),

                      // ----------- Consumption ----------
                      ConsumptionCardBuilder.create(maintenanceObject),
                      SizedBox(
                        height: 10,
                      ),

                      // ----------- Maintenance items ----------
                      Column(
                        children: MaintenanceItemsCardsBuilder.create(
                            maintenanceObject),
                      ),

                      MaintenanceObjectItemCard(
                          title: 'Insurance',
                          postCount: 999,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Posts: 5',
                                style:
                                    TextStyle(color: colorBlue, fontSize: 14),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                '2023-12-15',
                                style:
                                    TextStyle(color: colorBlue, fontSize: 14),
                              ),
                              Text(
                                '10219 km',
                                style:
                                    TextStyle(color: colorBlue, fontSize: 14),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                '6131 kr',
                                style:
                                    TextStyle(color: colorBlue, fontSize: 14),
                              ),
                              Text(
                                'Volvia',
                                style:
                                    TextStyle(color: colorBlue, fontSize: 14),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      MaintenanceObjectItemCard(
                          title: 'title',
                          child: Column(
                            children: [
                              Text(
                                'En ganska så jävla lång beskrivning av vad detta är för1 nått som beskriver denna',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style:
                                    TextStyle(color: colorBlue, fontSize: 14),
                              ),
                              Icon(Icons.abc),
                            ],
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      MaintenanceObjectItemCard(
                          title: 'title', child: Icon(Icons.abc)),
                      SizedBox(
                        height: 10,
                      ),
                      MaintenanceObjectItemCard(
                          title: 'title', child: Icon(Icons.abc)),
                      SizedBox(
                        height: 10,
                      ),
                      MaintenanceObjectItemCard(
                          title: 'title', child: Icon(Icons.abc)),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
