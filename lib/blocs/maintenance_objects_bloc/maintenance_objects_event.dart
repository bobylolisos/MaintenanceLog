import 'package:flutter/material.dart';

@immutable
sealed class MaintenanceObjectsEvent {}

final class MaintenanceObjectsSubscriptionEvent
    extends MaintenanceObjectsEvent {}
