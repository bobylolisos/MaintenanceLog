import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_objects_bloc/maintenance_objects_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_objects_bloc/maintenance_objects_event.dart';
import 'package:maintenance_log/blocs/maintenance_objects_bloc/maintenance_objects_state.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'package:maintenance_log/views/maintenance_object/maintenance_object_page.dart';
import 'package:maintenance_log/widgets/drawer_menu.dart';
import 'package:maintenance_log/widgets/main_header.dart';
import 'package:maintenance_log/widgets/maintenace_object_card.dart';

class MaintenanceObjectsPage extends StatelessWidget {
  const MaintenanceObjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBlue,
      endDrawer: DrawerMenu(),
      body: SafeArea(
        child: Container(
          color: colorLightGrey,
          child: Column(
            children: [
              MainHeader(),
              BlocProvider<MaintenanceObjectsBloc>(
                create: (BuildContext context) => MaintenanceObjectsBloc(
                    maintenanceObjectRepository: ioc.get())
                  ..add(MaintenanceObjectsSubscriptionEvent()),
                child: Expanded(
                  child: BlocBuilder<MaintenanceObjectsBloc,
                      MaintenanceObjectsState>(
                    builder: (context, state) {
                      if (state is MaintenanceObjectsChangedState) {
                        final maintenanceObjects = state.maintenanceObjects
                            .where((element) => element.isActive)
                            .toList();
                        if (maintenanceObjects.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  'Välkommen!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: colorBlue,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  'Ser att du inte har några objekt att underhålla :)',
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontSize: 20, color: colorBlue),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Välj Administration i menyn för att där skapa ditt första objekt.',
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontSize: 20, color: colorBlue),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: maintenanceObjects.length,
                          itemBuilder: (context, index) {
                            final maintenanceObject =
                                maintenanceObjects.elementAt(index);
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 5),
                              child: MaintenanceObjectCard(
                                  maintenanceObject: maintenanceObject,
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          MaintenanceObjectPage(
                                        maintenanceObject: maintenanceObject,
                                      ),
                                    ));
                                  }),
                            );
                          },
                        );
                      }
                      return Center(
                        child: SizedBox(
                            height: 80,
                            width: 80,
                            child: CircularProgressIndicator()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
