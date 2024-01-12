// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:maintenance_log/models/consumption.dart';
import 'package:uuid/uuid.dart';

import 'maintenance.dart';
import 'meter_type.dart';

class MaintenanceObject {
  final String id;
  final String name;
  final String shortDescription;
  final String description;
  final MeterType meterType;
  final int sortOrder;
  final bool isActive;
  final List<Maintenance> maintenanceItems;
  final List<Consumption> consumptions;
  final List<String> images;

  MaintenanceObject(
      {required this.id,
      required this.name,
      required this.shortDescription,
      required this.description,
      required this.meterType,
      required this.sortOrder,
      required this.isActive,
      required this.maintenanceItems,
      required this.consumptions,
      required this.images});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'shortDescription': shortDescription,
      'description': description,
      'meterType': meterType.index,
      'sortOrder': sortOrder,
      'isActive': isActive,
      'maintenanceItems': maintenanceItems.map((x) => x.toMap()).toList(),
      'consumptions': consumptions.map((x) => x.toMap()).toList(),
      'images': images.toList(),
    };
  }

  MaintenanceObject copyWith(
      {String? name,
      String? shortDescription,
      String? description,
      MeterType? meterType,
      int? sortOrder,
      bool? isActive,
      List<Maintenance>? maintenanceItems,
      List<Consumption>? consumptions,
      List<String>? images}) {
    return MaintenanceObject(
        id: id,
        name: name ?? this.name,
        shortDescription: shortDescription ?? this.shortDescription,
        description: description ?? this.description,
        meterType: meterType ?? this.meterType,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
        maintenanceItems: maintenanceItems ?? this.maintenanceItems,
        consumptions: consumptions ?? this.consumptions,
        images: images ?? this.images);
  }

  factory MaintenanceObject.createNew(String name, String? description) {
    return MaintenanceObject(
        id: Uuid().v4().toString(),
        name: name,
        shortDescription: description ?? '',
        description: '',
        meterType: MeterType.none,
        sortOrder: 0,
        isActive: true,
        maintenanceItems: [],
        consumptions: [],
        images: []);
  }

  factory MaintenanceObject.fromMap(Map<String, dynamic> map) {
    return MaintenanceObject(
      id: map['id'] as String,
      name: map['name'] as String,
      shortDescription: map['shortDescription'] as String,
      description: map['description'] as String,
      sortOrder: map['sortOrder'] as int,
      meterType: MeterType.values[map['meterType']],
      isActive: map['isActive'] as bool,
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
