import 'dart:convert';
import 'package:maintenance_log/models/consumption_item.dart';
import 'package:maintenance_log/models/meter_type.dart';
import 'package:uuid/uuid.dart';

class Consumption {
  final String id;
  final String name;
  final String description;
  final MeterType meterType;
  final List<ConsumptionItem> posts;
  final bool isActive;
//  final List<Reminder> reminders;

  Consumption(this.id, this.name, this.description, this.meterType, this.posts,
      this.isActive);

  factory Consumption.createNew(
      {required String name,
      required String description,
      required MeterType meterType}) {
    return Consumption(
      Uuid().v4().toString(),
      name,
      description,
      meterType,
      [],
      true,
    );
  }

  Consumption copyWith({String? name, String? description, bool? isActive}) {
    return Consumption(
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

  factory Consumption.fromMap(Map<String, dynamic> map) {
    return Consumption(
      map['id'] as String,
      map['name'] as String,
      map['description'] as String,
      MeterType.values[map['meterType']],
      List<ConsumptionItem>.from(
        (map['posts'] as List).map<ConsumptionItem>(
          (x) => ConsumptionItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Consumption.fromJson(String source) =>
      Consumption.fromMap(json.decode(source) as Map<String, dynamic>);
}
