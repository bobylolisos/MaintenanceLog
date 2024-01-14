import 'dart:convert';
import 'package:maintenance_log/models/consumption_item.dart';

import 'maintenance_item.dart';

class Maintenance {
  final String id;
  final String name;
  final List<MaintenanceItem> posts;
  final String description;
  final bool isActive;
//  final List<Reminder> reminders;

  Maintenance(this.id, this.name, this.posts, this.description, this.isActive);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'posts': posts.map((x) => x.toMap()).toList(),
      'description': description,
      'isActive': isActive,
    };
  }

  factory Maintenance.fromMap(Map<String, dynamic> map) {
    return Maintenance(
      map['id'] as String,
      map['name'] as String,
      List<MaintenanceItem>.from(
        (map['posts'] as List).map<MaintenanceItem>(
          (x) => MaintenanceItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      map['description'] as String,
      map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Maintenance.fromJson(String source) =>
      Maintenance.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Consumption {
  final String id;
  final String name;
  final List<ConsumptionItem> posts;
  final String description;
  final bool isActive;
//  final List<Reminder> reminders;

  Consumption(this.id, this.name, this.posts, this.description, this.isActive);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'posts': posts.map((x) => x.toMap()).toList(),
      'description': description,
      'isActive': isActive,
    };
  }

  factory Consumption.fromMap(Map<String, dynamic> map) {
    return Consumption(
      map['id'] as String,
      map['name'] as String,
      List<ConsumptionItem>.from(
        (map['posts'] as List).map<ConsumptionItem>(
          (x) => ConsumptionItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      map['description'] as String,
      map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Consumption.fromJson(String source) =>
      Consumption.fromMap(json.decode(source) as Map<String, dynamic>);
}
