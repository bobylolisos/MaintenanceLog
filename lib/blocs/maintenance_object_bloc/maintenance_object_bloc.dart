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
    on<MaintenanceObjectSubscriptionEvent>(
        onMaintenanceObjectSubscriptionEvent);

    on<MaintenanceObjectGetEvent>(onMaintenanceObjectGetEvent);

    on<MaintenanceObjectSaveEvent>(onMaintenanceObjectSaveEvent);

    // C o n s u m p t i o n
    on<ConsumptionAddedEvent>(onConsumptionAddedEvent);
    on<ConsumptionDeletedEvent>(onConsumptionDeletedEvent);

    // C o n s u m p t i o n I t e m
    on<ConsumptionItemChangedEvent>(onConsumptionItemChangedEvent);
    on<ConsumptionItemDeletedEvent>(onConsumptionItemDeletedEvent);

    // M a i n t e n a n c e
    on<MaintenanceAddedEvent>(onMaintenanceAddedEvent);
    on<MaintenanceDeletedEvent>(onMaintenanceDeletedEvent);

    // M a i n t e n a n c e I t e m
    on<MaintenanceItemChangedEvent>(onMaintenanceItemChangedEvent);
    on<MaintenanceItemDeletedEvent>(onMaintenanceItemDeletedEvent);
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

  // C o n s u m p t i o n

  FutureOr<void> onConsumptionAddedEvent(
      ConsumptionAddedEvent event, Emitter<MaintenanceObjectState> emit) async {
    emit(MaintenanceObjectWorkInProgressState());
    final consumptions = [
      ...[event.consumption],
      ...event.maintenanceObject.consumptions
    ];
    var maintenanceObject =
        await _maintenanceObjectRepository.setMaintenanceObject(
            event.maintenanceObject.copyWith(consumptions: consumptions));

    if (maintenanceObject != null) {
      emit(MaintenanceObjectUpdatedState(maintenanceObject: maintenanceObject));
    }
  }

  FutureOr<void> onConsumptionDeletedEvent(
      ConsumptionDeletedEvent event, Emitter<MaintenanceObjectState> emit) {
    final currentConsumptions = event.maintenanceObject.consumptions;
    currentConsumptions
        .removeWhere((element) => element.id == event.consumptionId);

    _maintenanceObjectRepository.setMaintenanceObject(
      event.maintenanceObject.copyWith(consumptions: currentConsumptions),
    );
  }

  // C o n s u m p t i o n I t e m

  FutureOr<void> onConsumptionItemChangedEvent(
      ConsumptionItemChangedEvent event, Emitter<MaintenanceObjectState> emit) {
    emit(MaintenanceObjectWorkInProgressState());
    final maintenanceObject = event.maintenanceObject;
    final consumption = maintenanceObject.consumptions.firstWhere(
        (element) => element.id == event.consumptionItem.consumptionId);
    final index = consumption.posts
        .indexWhere((element) => element.id == event.consumptionItem.id);

    if (index >= 0) {
      consumption.posts.removeAt(index);
      consumption.posts.insert(index, event.consumptionItem);
    } else {
      consumption.posts.add(event.consumptionItem);
    }

    consumption.posts.sort((a, b) =>
        b.date.millisecondsSinceEpoch.compareTo(a.date.millisecondsSinceEpoch));

    // Check so dates and metervalue are in equal sequence

    _maintenanceObjectRepository.setMaintenanceObject(maintenanceObject);
  }

  FutureOr<void> onConsumptionItemDeletedEvent(
      ConsumptionItemDeletedEvent event, Emitter<MaintenanceObjectState> emit) {
    emit(MaintenanceObjectWorkInProgressState());
    final maintenanceObject = event.maintenanceObject;
    final consumption = maintenanceObject.consumptions.firstWhere(
        (element) => element.id == event.consumptionItem.consumptionId);
    final index = consumption.posts
        .indexWhere((element) => element.id == event.consumptionItem.id);

    if (index >= 0) {
      consumption.posts.removeAt(index);
    }

    _maintenanceObjectRepository.setMaintenanceObject(maintenanceObject);
  }

  // M a i n t e n a n c e

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

  FutureOr<void> onMaintenanceDeletedEvent(
      MaintenanceDeletedEvent event, Emitter<MaintenanceObjectState> emit) {
    final currentMaintenances = event.maintenanceObject.maintenances;
    currentMaintenances
        .removeWhere((element) => element.id == event.maintenanceId);

    _maintenanceObjectRepository.setMaintenanceObject(
      event.maintenanceObject.copyWith(maintenances: currentMaintenances),
    );
  }

  // M a i n t e n a n c e I t e m

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

    // Check so dates and metervalue are in equal sequence

    _maintenanceObjectRepository.setMaintenanceObject(maintenanceObject);
  }

  FutureOr<void> onMaintenanceItemDeletedEvent(
      MaintenanceItemDeletedEvent event, Emitter<MaintenanceObjectState> emit) {
    emit(MaintenanceObjectWorkInProgressState());
    final maintenanceObject = event.maintenanceObject;
    final maintenance = maintenanceObject.maintenances.firstWhere(
        (element) => element.id == event.maintenanceItem.maintenanceId);
    final index = maintenance.posts
        .indexWhere((element) => element.id == event.maintenanceItem.id);

    if (index >= 0) {
      maintenance.posts.removeAt(index);
    }

    _maintenanceObjectRepository.setMaintenanceObject(maintenanceObject);
  }
}
