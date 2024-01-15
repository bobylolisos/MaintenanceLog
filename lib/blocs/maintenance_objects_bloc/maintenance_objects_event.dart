import 'package:flutter/material.dart';
import 'package:maintenance_log/models/maintenance_object.dart';

@immutable
sealed class MaintenanceObjectsEvent {}

final class MaintenanceObjectsSubscriptionEvent
    extends MaintenanceObjectsEvent {}

final class MaintenanceObjectsReorderEvent extends MaintenanceObjectsEvent {
  final List<MaintenanceObject> maintenanceObjects;

  MaintenanceObjectsReorderEvent({required this.maintenanceObjects});
}

final class MaintenanceObjectsDeleteEvent extends MaintenanceObjectsEvent {
  final String maintenanceObjectId;

  MaintenanceObjectsDeleteEvent({required this.maintenanceObjectId});
}
