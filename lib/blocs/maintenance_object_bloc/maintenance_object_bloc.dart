import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_log/repositories/firestore_maintenance_repository.dart';

import 'maintenance_object_event.dart';
import 'maintenance_object_state.dart';

class MaintenanceObjectBloc
    extends Bloc<MaintenanceObjectEvent, MaintenanceObjectState> {
  final FirestoreMaintenanceRepository _maintenanceObjectRepository;

  MaintenanceObjectBloc(
      {required FirestoreMaintenanceRepository maintenanceObjectRepository})
      : _maintenanceObjectRepository = maintenanceObjectRepository,
        super(MaintenanceObjectInitialState()) {
    on<MaintenanceObjectGetEvent>(onMaintenanceObjectGetEvent);
  }

  FutureOr<void> onMaintenanceObjectGetEvent(
      MaintenanceObjectGetEvent event, Emitter<MaintenanceObjectState> emit) {
    var id = event.maintenanceObjectId;
    // Load object
  }
}
