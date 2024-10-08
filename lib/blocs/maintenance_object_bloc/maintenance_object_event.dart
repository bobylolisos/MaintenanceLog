import 'package:flutter/material.dart';
import 'package:maintenance_log/models/consumption.dart';
import 'package:maintenance_log/models/consumption_item.dart';
import 'package:maintenance_log/models/maintenance.dart';
import 'package:maintenance_log/models/maintenance_item.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/models/note.dart';

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

// N o t e
final class NoteChangedEvent extends MaintenanceObjectEvent {
  final MaintenanceObject maintenanceObject;
  final Note note;

  NoteChangedEvent({required this.maintenanceObject, required this.note});
}

final class NoteDeletedEvent extends MaintenanceObjectEvent {
  final MaintenanceObject maintenanceObject;
  final Note note;

  NoteDeletedEvent({required this.maintenanceObject, required this.note});
}

// C o n s u m p t i o n
final class ConsumptionAddedEvent extends MaintenanceObjectEvent {
  final MaintenanceObject maintenanceObject;
  final Consumption consumption;

  ConsumptionAddedEvent(
      {required this.maintenanceObject, required this.consumption});
}

final class ConsumptionDeletedEvent extends MaintenanceObjectEvent {
  final MaintenanceObject maintenanceObject;
  final String consumptionId;

  ConsumptionDeletedEvent(
      {required this.maintenanceObject, required this.consumptionId});
}

// C o n s u m p t i o n I t e m
final class ConsumptionItemChangedEvent extends MaintenanceObjectEvent {
  final MaintenanceObject maintenanceObject;
  final ConsumptionItem consumptionItem;

  ConsumptionItemChangedEvent(
      {required this.maintenanceObject, required this.consumptionItem});
}

final class ConsumptionItemDeletedEvent extends MaintenanceObjectEvent {
  final MaintenanceObject maintenanceObject;
  final ConsumptionItem consumptionItem;

  ConsumptionItemDeletedEvent(
      {required this.maintenanceObject, required this.consumptionItem});
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
