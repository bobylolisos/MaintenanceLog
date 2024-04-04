// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:maintenance_log/models/meter_type.dart';
import 'package:uuid/uuid.dart';

class MaintenanceItem {
  final String id;
  final String maintenanceId;
  final String header;
  final DateTime date;
  final int? meterValue;
  final num costs;
  final String note;

  MaintenanceItem(
    this.id,
    this.maintenanceId,
    this.header,
    this.date,
    this.meterValue,
    this.costs,
    this.note,
  );

  factory MaintenanceItem.createNew({
    required String maintenanceId,
    required String header,
    required DateTime date,
    int? meterValue,
    num? costs,
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
    );
  }

  MaintenanceItem copyWith({
    String? header,
    DateTime? date,
    int? meterValue,
    num? costs,
    String? note,
  }) {
    return MaintenanceItem(
      id,
      maintenanceId,
      header ?? this.header,
      date ?? this.date,
      meterValue ?? this.meterValue,
      costs ?? this.costs,
      note ?? this.note,
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
    };
  }

  factory MaintenanceItem.fromMap(Map<String, dynamic> map) {
    return MaintenanceItem(
      map['id'] as String,
      map['maintenanceId'] as String,
      map['header'] as String,
      DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      map['meterValue'] as int?,
      map['costs'] as num,
      map['note'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceItem.fromJson(String source) =>
      MaintenanceItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant MaintenanceItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.maintenanceId == maintenanceId &&
        other.header == header &&
        other.date == date &&
        other.meterValue == meterValue &&
        other.costs == costs &&
        other.note == note;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        maintenanceId.hashCode ^
        header.hashCode ^
        date.hashCode ^
        meterValue.hashCode ^
        costs.hashCode ^
        note.hashCode;
  }

  String toMeterValueString(MeterType meterType) {
    var str = meterValue?.toString() ?? '';

    if (meterType == MeterType.odometer) {
      if (str.length < 4) {
        return str;
      }

      return StringUtils.addCharAtPosition(str, '.', 3);
    }

    return str;
  }

  int? previousMeterValue;
  bool get invalidMeterValue =>
      previousMeterValue != null &&
      meterValue != null &&
      previousMeterValue! > meterValue!;
}
