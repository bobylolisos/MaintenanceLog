import 'package:flutter/material.dart';
import 'package:maintenance_log/models/maintenance.dart';
import 'package:maintenance_log/models/maintenance_item.dart';
import 'package:maintenance_log/models/maintenance_object.dart';

@immutable
sealed class MaintenanceObjectEvent {}

final class MaintenanceObjectSubscriptionEvent extends MaintenanceObjectEvent {
  final String maintenanceObjectId;

  MaintenanceObjectSubscriptionEvent({required this.maintenanceObjectId});
}

final class MaintenanceObjectGetEvent extends MaintenanceObjectEvent {
  final String maintenanceObjectId;

  MaintenanceObjectGetEvent({required this.maintenanceObjectId});
}

final class MaintenanceObjectSaveEvent extends MaintenanceObjectEvent {
  final MaintenanceObject maintenanceObject;

  MaintenanceObjectSaveEvent({required this.maintenanceObject});
}

// M a i n t e n a n c e
final class MaintenanceAddedEvent extends MaintenanceObjectEvent {
  final MaintenanceObject maintenanceObject;
  final Maintenance maintenance;

  MaintenanceAddedEvent(
      {required this.maintenanceObject, required this.maintenance});
}

final class MaintenanceDeletedEvent extends MaintenanceObjectEvent {
  final MaintenanceObject maintenanceObject;
  final String maintenanceId;

  MaintenanceDeletedEvent(
      {required this.maintenanceObject, required this.maintenanceId});
}

// M a i n t e n a n c e I t e m
final class MaintenanceItemChangedEvent extends MaintenanceObjectEvent {
  final MaintenanceObject maintenanceObject;
  final MaintenanceItem maintenanceItem;

  MaintenanceItemChangedEvent(
      {required this.maintenanceObject, required this.maintenanceItem});
}

final class MaintenanceItemDeletedEvent extends MaintenanceObjectEvent {
  final MaintenanceObject maintenanceObject;
  final MaintenanceItem maintenanceItem;

  MaintenanceItemDeletedEvent(
      {required this.maintenanceObject, required this.maintenanceItem});
}
