import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_objects_bloc/maintenance_objects_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_objects_bloc/maintenance_objects_event.dart';
import 'package:maintenance_log/blocs/maintenance_objects_bloc/maintenance_objects_state.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'package:maintenance_log/views/maintenance_object/maintenance_object_view.dart';
import 'package:maintenance_log/widgets/drawer_menu.dart';
import 'package:maintenance_log/widgets/main_header.dart';
import 'package:maintenance_log/widgets/maintenace_object_card.dart';

class MaintenanceObjectsView extends StatelessWidget {
  const MaintenanceObjectsView({super.key});

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
                        return ListView.builder(
                          itemCount: state.maintenanceObjects.length,
                          itemBuilder: (context, index) {
                            final maintenanceObject =
                                state.maintenanceObjects.elementAt(index);
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 5),
                              child: MaintenanceObjectCard(
                                  maintenanceObject: maintenanceObject,
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          MaintenanceObjectView(
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
