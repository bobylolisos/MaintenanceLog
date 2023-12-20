import 'package:flutter/material.dart';

@immutable
sealed class MaintenanceObjectEvent {}

final class MaintenanceObjectGetEvent extends MaintenanceObjectEvent {
  final String maintenanceObjectId;

  MaintenanceObjectGetEvent({required this.maintenanceObjectId});
}
