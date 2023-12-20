// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:maintenance_log/models/consumption.dart';
import 'package:maintenance_log/models/property_value.dart';

import 'maintenance.dart';
import 'meter_type.dart';
import 'note.dart';

class MaintenanceObject {
  final String id;
  final String name;
  final MeterType meterType;
  final int sortOrder; // ?????
  final bool isActive;
  final List<PropertyValue> propertyValues;
  final List<Note> notes;
  final List<Maintenance> maintenanceItems;
  final List<Consumption> consumptions;
  final List<String> images;

  MaintenanceObject(
      {required this.id,
      required this.name,
      required this.meterType,
      required this.sortOrder,
      required this.isActive,
      required this.propertyValues, // Brand, Model, Year, LicensePlate
      required this.notes,
      required this.maintenanceItems,
      required this.consumptions,
      required this.images});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'meterType': meterType.index,
      'sortOrder': sortOrder,
      'isActive': isActive,
      'propertyValues': propertyValues.map((x) => x.toMap()).toList(),
      'notes': notes.map((x) => x.toMap()).toList(),
      'maintenanceItems': maintenanceItems.map((x) => x.toMap()).toList(),
      'consumptions': consumptions.map((x) => x.toMap()).toList(),
      'images': images.toList(),
    };
  }

  factory MaintenanceObject.fromMap(Map<String, dynamic> map) {
    return MaintenanceObject(
      id: map['id'] as String,
      name: map['name'] as String,
      sortOrder: map['sortOrder'] as int,
      meterType: MeterType.values[map['meterType']],
      isActive: map['isActive'] as bool,
      propertyValues: List<PropertyValue>.from(
        (map['propertyValues'] as List).map<PropertyValue>(
          (x) => PropertyValue.fromMap(x as Map<String, dynamic>),
        ),
      ),
      notes: List<Note>.from(
        (map['notes'] as List).map<Note>(
          (x) => Note.fromMap(x as Map<String, dynamic>),
        ),
      ),
      maintenanceItems: List<Maintenance>.from(
        (map['maintenanceItems'] as List).map<Maintenance>(
          (x) => Maintenance.fromMap(x as Map<String, dynamic>),
        ),
      ),
      consumptions: List<Consumption>.from(
        (map['consumptions'] as List).map<Consumption>(
          (x) => Consumption.fromMap(x as Map<String, dynamic>),
        ),
      ),
      images: List<String>.from(map['images'] as List),
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceObject.fromJson(String source) =>
      MaintenanceObject.fromMap(json.decode(source) as Map<String, dynamic>);
}
