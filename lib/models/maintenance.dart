import 'dart:convert';

import 'package:maintenance_log/models/meter_type.dart';
import 'package:uuid/uuid.dart';

import 'maintenance_item.dart';

class Maintenance {
  final String id;
  final String name;
  final String description;
  final MeterType meterType;
  final List<MaintenanceItem> posts;
  final bool isActive;
//  final List<Reminder> reminders;

  Maintenance(this.id, this.name, this.description, this.meterType, this.posts,
      this.isActive);

  factory Maintenance.createNew(
      {required String name,
      required String description,
      required MeterType meterType}) {
    return Maintenance(
      Uuid().v4().toString(),
      name,
      description,
      meterType,
      [],
      true,
    );
  }

  Maintenance copyWith({String? name, String? description, bool? isActive}) {
    return Maintenance(
      id,
      name ?? this.name,
      description ?? this.description,
      meterType,
      posts,
      isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'meterType': meterType.index,
      'posts': posts.map((x) => x.toMap()).toList(),
      'isActive': isActive,
    };
  }

  factory Maintenance.fromMap(Map<String, dynamic> map) {
    return Maintenance(
      map['id'] as String,
      map['name'] as String,
      map['description'] as String,
      MeterType.values[map['meterType']],
      mapPosts(map),
      map['isActive'] as bool,
    );
  }

  static List<MaintenanceItem> mapPosts(Map<String, dynamic> map) {
    final list = List<MaintenanceItem>.from(
      (map['posts'] as List).map<MaintenanceItem>(
        (x) => MaintenanceItem.fromMap(x as Map<String, dynamic>),
      ),
    );

    int? previousMeterValue;
    for (var i = list.length - 1; i > 0; i--) {
      if (list[i].meterValue != null) {
        previousMeterValue = list[i].meterValue;
      }
      if (i > 0) {
        list[i - 1].previousMeterValue = previousMeterValue;
      }
    }

    return list;
  }

  String toJson() => json.encode(toMap());

  factory Maintenance.fromJson(String source) =>
      Maintenance.fromMap(json.decode(source) as Map<String, dynamic>);
}
