import 'dart:convert';
import 'package:maintenance_log/models/maintenance_object.dart';

import 'consumption.dart';
import 'maintenance.dart';
import 'note.dart';

class Vehicle extends MaintenanceObject {
  final int startOdometerKm;
  final List<Consumption> consumptions;

  Vehicle(
      {required super.id,
      required super.name,
      required super.description,
      required super.sortOrder,
      required super.isActive,
      required super.notes,
      required super.maintenanceItems,
      required super.images,
      required this.startOdometerKm,
      required this.consumptions})
      : super(maintenaceObjectType: 1);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'startOdometerKm': startOdometerKm,
      'consumptions': consumptions.map((x) => x.toMap()).toList(),
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      sortOrder: map['sortOrder'] as int,
      isActive: map['isActive'] as bool,
      notes: List<Note>.from(
        (map['notes'] as List<int>).map<Note>(
          (x) => Note.fromMap(x as Map<String, dynamic>),
        ),
      ),
      maintenanceItems: List<Maintenance>.from(
        (map['maintenanceItems'] as List<int>).map<Maintenance>(
          (x) => Maintenance.fromMap(x as Map<String, dynamic>),
        ),
      ),
      images: List<String>.from(map['images'] as List<String>),
      startOdometerKm: map['startOdometerKm'] as int,
      consumptions: List<Consumption>.from(
        (map['consumptions'] as List<int>).map<Consumption>(
          (x) => Consumption.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory Vehicle.fromJson(String source) =>
      Vehicle.fromMap(json.decode(source) as Map<String, dynamic>);
}
