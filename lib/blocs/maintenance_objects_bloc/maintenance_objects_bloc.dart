import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/repositories/firestore_maintenance_repository.dart';

import 'maintenance_objects_event.dart';
import 'maintenance_objects_state.dart';

class MaintenanceObjectsBloc
    extends Bloc<MaintenanceObjectsEvent, MaintenanceObjectsState> {
  final FirestoreMaintenanceRepository _maintenanceObjectRepository;

  MaintenanceObjectsBloc(
      {required FirestoreMaintenanceRepository maintenanceObjectRepository})
      : _maintenanceObjectRepository = maintenanceObjectRepository,
        super(MaintenanceObjectsInitialState()) {
    on<MaintenanceObjectsSubscriptionEvent>(
        onMaintenanceObjectSubscriptionEvent);
    on<MaintenanceObjectsReorderEvent>(onMaintenanceObjectsReorderEvent);
    on<MaintenanceObjectsDeleteEvent>(onMaintenanceObjectsDeleteEvent);
  }

  FutureOr<void> onMaintenanceObjectSubscriptionEvent(
      MaintenanceObjectsSubscriptionEvent event,
      Emitter<MaintenanceObjectsState> emit) async {
    await emit.forEach(
      _maintenanceObjectRepository.subscribeForMaintenanceObjectChanges(),
      onData: (data) {
        final maintenanceObjects = List<MaintenanceObject>.from(data);
        maintenanceObjects.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        return MaintenanceObjectsChangedState(
            maintenanceObjects: maintenanceObjects);
      },
    );
  }

  FutureOr<void> onMaintenanceObjectsReorderEvent(
      MaintenanceObjectsReorderEvent event,
      Emitter<MaintenanceObjectsState> emit) {
    _maintenanceObjectRepository
        .reorderMaintenanceObjects(event.maintenanceObjects);
  }

  FutureOr<void> onMaintenanceObjectsDeleteEvent(
      MaintenanceObjectsDeleteEvent event,
      Emitter<MaintenanceObjectsState> emit) {
    _maintenanceObjectRepository
        .deleteMaintenanceObject(event.maintenanceObjectId);
  }
}
