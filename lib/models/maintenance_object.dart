// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'maintenance.dart';
import 'note.dart';

class MaintenanceObject {
  final int maintenaceObjectType;
  final String id;
  final String name;
  final String description;
  final int sortOrder; // ?????
  final bool isActive;
  final List<Note> notes;
  final List<Maintenance> maintenanceItems;
  final List<String> images;

  MaintenanceObject(
      {this.maintenaceObjectType = 0,
      required this.id,
      required this.name,
      required this.description,
      required this.sortOrder,
      required this.isActive,
      required this.notes, // Brand, Model, Year, LicensePlate
      required this.maintenanceItems,
      required this.images});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'maintenaceObjectType': maintenaceObjectType,
      'id': id,
      'name': name,
      'description': description,
      'sortOrder': sortOrder,
      'isActive': isActive,
      'notes': notes.map((x) => x.toMap()).toList(),
      'maintenanceItems': maintenanceItems.map((x) => x.toMap()).toList(),
      'images': images.toList(),
    };
  }

  factory MaintenanceObject.fromMap(Map<String, dynamic> map) {
    return MaintenanceObject(
      maintenaceObjectType: map['maintenaceObjectType'] as int,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceObject.fromJson(String source) =>
      MaintenanceObject.fromMap(json.decode(source) as Map<String, dynamic>);
}
