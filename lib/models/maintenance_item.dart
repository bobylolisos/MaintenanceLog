import 'dart:convert';

import 'package:uuid/uuid.dart';

class MaintenanceItem {
  final String id;
  final String maintenanceId;
  final String header;
  final DateTime date;
  final int? meterValue;
  final int costs;
  final String note;
  final List<String> images;

  MaintenanceItem(this.id, this.maintenanceId, this.header, this.date,
      this.meterValue, this.costs, this.note, this.images);

  factory MaintenanceItem.createNew({
    required String maintenanceId,
    required String header,
    required DateTime date,
    int? meterValue,
    int? costs,
    String? note,
  }) {
    return MaintenanceItem(
      Uuid().v4().toString(),
      maintenanceId,
      header,
      date,
      meterValue,
      costs ?? 0,
      note ?? '',
      [],
    );
  }

  MaintenanceItem copyWith({
    String? header,
    DateTime? date,
    int? meterValue,
    int? costs,
    String? note,
    List<String>? images,
  }) {
    return MaintenanceItem(
      id,
      maintenanceId,
      header ?? this.header,
      date ?? this.date,
      meterValue ?? this.meterValue,
      costs ?? this.costs,
      note ?? this.note,
      images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'maintenanceId': maintenanceId,
      'header': header,
      'date': date.millisecondsSinceEpoch,
      'meterValue': meterValue,
      'costs': costs,
      'note': note,
      'images': images.toList(),
    };
  }

  factory MaintenanceItem.fromMap(Map<String, dynamic> map) {
    return MaintenanceItem(
      map['id'] as String,
      map['maintenanceId'] as String,
      map['header'] as String,
      DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      map['meterValue'] as int?,
      map['costs'] as int,
      map['note'] as String,
      List<String>.from(map['images'] as List),
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceItem.fromJson(String source) =>
      MaintenanceItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
