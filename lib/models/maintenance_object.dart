// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:maintenance_log/models/note.dart';
import 'package:uuid/uuid.dart';

import 'consumption.dart';
import 'maintenance.dart';
import 'meter_type.dart';

class MaintenanceObject {
  final String id;
  final String header;
  final String subHeader;
  final String description;
  final MeterType meterType;
  final int sortOrder;
  final bool isActive;
  final List<Note> notes;
  final List<Maintenance> maintenances;
  final List<Consumption> consumptions;
  final List<String> images;

  MaintenanceObject(
      {required this.id,
      required this.header,
      required this.subHeader,
      required this.description,
      required this.meterType,
      required this.sortOrder,
      required this.isActive,
      required this.notes,
      required this.maintenances,
      required this.consumptions,
      required this.images});

  factory MaintenanceObject.createNew(String header, String subHeader,
      String description, MeterType meterType) {
    return MaintenanceObject(
        id: Uuid().v4().toString(),
        header: header,
        subHeader: subHeader,
        description: description,
        meterType: meterType,
        sortOrder: 0,
        isActive: true,
        notes: [],
        maintenances: [
          Maintenance.createNew(
            name: 'Övrigt',
            description:
                'Övriga åtgärder och kostnader som inte behöver egen underhållspunkt.',
            meterType: meterType,
          ),
        ],
        consumptions: [],
        images: []);
  }

  MaintenanceObject copyWith(
      {String? header,
      String? subHeader,
      String? description,
      MeterType? meterType,
      int? sortOrder,
      bool? isActive,
      List<Note>? notes,
      List<Maintenance>? maintenances,
      List<Consumption>? consumptions,
      List<String>? images}) {
    return MaintenanceObject(
        id: id,
        header: header ?? this.header,
        subHeader: subHeader ?? this.subHeader,
        description: description ?? this.description,
        meterType: meterType ?? this.meterType,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
        notes: notes ?? this.notes,
        maintenances: maintenances ?? this.maintenances,
        consumptions: consumptions ?? this.consumptions,
        images: images ?? this.images);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'header': header,
      'subHeader': subHeader,
      'description': description,
      'meterType': meterType.index,
      'sortOrder': sortOrder,
      'isActive': isActive,
      'notes': notes.map((x) => x.toMap()).toList(),
      'maintenances': maintenances.map((x) => x.toMap()).toList(),
      'consumptions': consumptions.map((x) => x.toMap()).toList(),
      'images': images.toList(),
    };
  }

  factory MaintenanceObject.fromMap(Map<String, dynamic> map) {
    return MaintenanceObject(
      id: map['id'] as String,
      header: map['header'] as String,
      subHeader: map['subHeader'] as String,
      description: map['description'] as String,
      sortOrder: map['sortOrder'] as int,
      meterType: MeterType.values[map['meterType']],
      isActive: map['isActive'] as bool,
      notes: List<Note>.from(
        (map['notes'] as List).map<Note>(
          (x) => Note.fromMap(x as Map<String, dynamic>),
        ),
      ),
      maintenances: List<Maintenance>.from(
        (map['maintenances'] as List).map<Maintenance>(
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
