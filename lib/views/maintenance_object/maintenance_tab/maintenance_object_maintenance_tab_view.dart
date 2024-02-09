import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_state.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'package:maintenance_log/views/maintenance_object/maintenance_tab/builders/consumption_items_cards_builder.dart';
import 'package:maintenance_log/views/maintenance_object/maintenance_tab/builders/maintenance_items_cards_builder.dart';
import 'package:maintenance_log/views/maintenance_object/maintenance_tab/builders/maintenance_object_information_card_builder.dart';

// ignore: must_be_immutable
class MaintenanceObjectMaintenanceTabView extends StatelessWidget {
  MaintenanceObject maintenanceObject;
  MaintenanceObjectMaintenanceTabView(
      {required this.maintenanceObject, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MaintenanceObjectBloc>(
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
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // ----------- Object information ----------
                  MaintenanceObjectInformationCardBuilder.create(
                      maintenanceObject),
                  SizedBox(
                    height: 10,
                  ),

                  maintenanceObject.consumptions.isEmpty &&
                          maintenanceObject.maintenances.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Hoppsan, här var det tomt',
                                style:
                                    TextStyle(color: colorBlue, fontSize: 22),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Gå in i administration för att lägga till underhållspunkter och förbrukningar',
                                style:
                                    TextStyle(color: colorBlue, fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),

                  // ----------- Consumption ----------
                  Column(
                    children: ConsumptionItemsCardsBuilder.create(
                        context, maintenanceObject),
                  ),
                  maintenanceObject.consumptions.isNotEmpty
                      ? SizedBox(
                          height: 10,
                        )
                      : SizedBox(),

                  // ----------- Maintenance items ----------
                  Column(
                    children: MaintenanceItemsCardsBuilder.create(
                        context, maintenanceObject),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
