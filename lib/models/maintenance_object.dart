// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:maintenance_log/models/consumption.dart';
import 'package:maintenance_log/models/property_value.dart';
import 'package:uuid/uuid.dart';

import 'maintenance.dart';
import 'meter_type.dart';
import 'note.dart';

class MaintenanceObject {
  final String id;
  final String name;
  final String shortDescription;
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
      required this.shortDescription,
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
      'shortDescription': shortDescription,
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

  MaintenanceObject copyWith(
      {String? name,
      String? shortDescription,
      MeterType? meterType,
      int? sortOrder,
      bool? isActive,
      List<PropertyValue>? propertyValues, // Brand, Model, Year, LicensePlate
      List<Note>? notes,
      List<Maintenance>? maintenanceItems,
      List<Consumption>? consumptions,
      List<String>? images}) {
    return MaintenanceObject(
        id: id,
        name: name ?? this.name,
        shortDescription: shortDescription ?? this.shortDescription,
        meterType: meterType ?? this.meterType,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
        propertyValues: propertyValues ?? this.propertyValues,
        notes: notes ?? this.notes,
        maintenanceItems: maintenanceItems ?? this.maintenanceItems,
        consumptions: consumptions ?? this.consumptions,
        images: images ?? this.images);
  }

  factory MaintenanceObject.createNew(String name, String? description) {
    return MaintenanceObject(
        id: Uuid().v4().toString(),
        name: name,
        shortDescription: description ?? '',
        meterType: MeterType.none,
        sortOrder: 0,
        isActive: true,
        propertyValues: [],
        notes: [],
        maintenanceItems: [],
        consumptions: [],
        images: []);
  }

  factory MaintenanceObject.fromMap(Map<String, dynamic> map) {
    return MaintenanceObject(
      id: map['id'] as String,
      name: map['name'] as String,
      shortDescription: map['shortDescription'] as String,
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
