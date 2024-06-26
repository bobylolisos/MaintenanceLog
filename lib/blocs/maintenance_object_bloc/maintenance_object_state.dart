import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_log/models/maintenance_object.dart';

@immutable
sealed class MaintenanceObjectState extends Equatable {}

final class MaintenanceObjectWorkInProgressState
    extends MaintenanceObjectState {
  @override
  List<Object?> get props => [];
}

final class MaintenanceObjectUpdatedState extends MaintenanceObjectState {
  final MaintenanceObject maintenanceObject;

  MaintenanceObjectUpdatedState({required this.maintenanceObject});
  @override
  List<Object?> get props => [maintenanceObject];
}
