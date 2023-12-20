import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_event.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_state.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'package:maintenance_log/widgets/sub_header_app_bar.dart';

class MaintenanceObjectView extends StatelessWidget {
  final String maintenanceObjectId;
  const MaintenanceObjectView({required this.maintenanceObjectId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorLightGrey,
      appBar: SubHeaderAppBar(title: 'Maintenance'),
      body: BlocProvider<MaintenanceObjectBloc>(
        create: (BuildContext context) =>
            MaintenanceObjectBloc(maintenanceObjectRepository: ioc.get())
              ..add(MaintenanceObjectGetEvent(
                  maintenanceObjectId: maintenanceObjectId)),
        child: Builder(builder: (context) {
          return BlocBuilder<MaintenanceObjectBloc, MaintenanceObjectState>(
            builder: (BuildContext context, MaintenanceObjectState state) {
              if (state is MaintenanceObjectGetState) {
                return Center(
                  child: Text(state.maintenanceObject.name),
                );
              }

              return Center(
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
