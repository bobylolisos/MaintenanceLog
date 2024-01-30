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
        super(MaintenanceObjectWorkInProgressState()) {
    on<MaintenanceObjectGetEvent>(onMaintenanceObjectGetEvent);

    on<MaintenanceObjectSaveEvent>(onMaintenanceObjectSaveEvent);

    on<MaintenanceAddedEvent>(onMaintenanceAddedEvent);
  }

  FutureOr<void> onMaintenanceObjectGetEvent(MaintenanceObjectGetEvent event,
      Emitter<MaintenanceObjectState> emit) async {
    emit(MaintenanceObjectWorkInProgressState());
    var maintenanceObject = await _maintenanceObjectRepository
        .getMaintenanceObject(event.maintenanceObjectId);

    if (maintenanceObject != null) {
      emit(MaintenanceObjectUpdatedState(maintenanceObject: maintenanceObject));
    }
  }

  FutureOr<void> onMaintenanceObjectSaveEvent(MaintenanceObjectSaveEvent event,
      Emitter<MaintenanceObjectState> emit) async {
    emit(MaintenanceObjectWorkInProgressState());

    var maintenanceObject = await _maintenanceObjectRepository
        .setMaintenanceObject(event.maintenanceObject);

    if (maintenanceObject != null) {
      emit(MaintenanceObjectUpdatedState(maintenanceObject: maintenanceObject));
    }
  }

  FutureOr<void> onMaintenanceAddedEvent(
      MaintenanceAddedEvent event, Emitter<MaintenanceObjectState> emit) async {
    emit(MaintenanceObjectWorkInProgressState());
    final maintenances = [
      ...[event.maintenance],
      ...event.maintenanceObject.maintenances
    ];
    var maintenanceObject =
        await _maintenanceObjectRepository.setMaintenanceObject(
            event.maintenanceObject.copyWith(maintenances: maintenances));

    if (maintenanceObject != null) {
      emit(MaintenanceObjectUpdatedState(maintenanceObject: maintenanceObject));
    }
  }
}
