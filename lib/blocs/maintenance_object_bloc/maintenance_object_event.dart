import 'package:flutter/material.dart';
import 'package:maintenance_log/models/maintenance_object.dart';

@immutable
sealed class MaintenanceObjectEvent {}

final class MaintenanceObjectGetEvent extends MaintenanceObjectEvent {
  final String maintenanceObjectId;

  MaintenanceObjectGetEvent({required this.maintenanceObjectId});
}

final class MaintenanceObjectSaveEvent extends MaintenanceObjectEvent {
  final MaintenanceObject maintenanceObject;

  MaintenanceObjectSaveEvent({required this.maintenanceObject});
}
