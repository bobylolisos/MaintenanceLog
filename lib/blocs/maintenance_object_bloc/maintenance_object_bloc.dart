import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_log/main.dart';
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
    on<MaintenanceObjectSubscriptionEvent>(
        onMaintenanceObjectSubscriptionEvent);

    on<MaintenanceObjectGetEvent>(onMaintenanceObjectGetEvent);

    on<MaintenanceObjectSaveEvent>(onMaintenanceObjectSaveEvent);

    on<MaintenanceAddedEvent>(onMaintenanceAddedEvent);

    on<MaintenanceItemChangedEvent>(onMaintenanceItemChangedEvent);
  }

  FutureOr<void> onMaintenanceObjectSubscriptionEvent(
      MaintenanceObjectSubscriptionEvent event,
      Emitter<MaintenanceObjectState> emit) async {
    await emit.forEach(
      _maintenanceObjectRepository
          .subscribeForMaintenanceObjectChanges(event.maintenanceObjectId),
      onData: (data) {
        return MaintenanceObjectUpdatedState(maintenanceObject: data);
      },
    );
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

  FutureOr<void> onMaintenanceItemChangedEvent(
      MaintenanceItemChangedEvent event, Emitter<MaintenanceObjectState> emit) {
    emit(MaintenanceObjectWorkInProgressState());
    final maintenanceObject = event.maintenanceObject;
    final maintenance = maintenanceObject.maintenances.firstWhere(
        (element) => element.id == event.maintenanceItem.maintenanceId);
    final index = maintenance.posts
        .indexWhere((element) => element.id == event.maintenanceItem.id);

    if (index >= 0) {
      maintenance.posts.removeAt(index);
      maintenance.posts.insert(index, event.maintenanceItem);
    } else {
      maintenance.posts.add(event.maintenanceItem);
    }

    maintenance.posts.sort((a, b) =>
        b.date.millisecondsSinceEpoch.compareTo(a.date.millisecondsSinceEpoch));

    _maintenanceObjectRepository.setMaintenanceObject(maintenanceObject);
  }
}
