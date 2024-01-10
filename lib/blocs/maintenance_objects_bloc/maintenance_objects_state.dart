import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_log/models/maintenance_object.dart';

@immutable
sealed class MaintenanceObjectsState extends Equatable {}

final class MaintenanceObjectsInitialState extends MaintenanceObjectsState {
  @override
  List<Object?> get props => [];
}

final class MaintenanceObjectsChangedState extends MaintenanceObjectsState {
  final List<MaintenanceObject> maintenanceObjects;

  MaintenanceObjectsChangedState({required this.maintenanceObjects});
  @override
  List<Object?> get props => [maintenanceObjects];
}
