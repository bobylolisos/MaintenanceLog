// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:uuid/uuid.dart';

import 'package:maintenance_log/models/meter_type.dart';

class ConsumptionItem {
  final String id;
  final String consumptionId;
  final DateTime date;
  final num pricePerLitre;
  final num litre;
  final int? meterValue;
  final String note;

  ConsumptionItem(this.id, this.consumptionId, this.date, this.pricePerLitre,
      this.litre, this.meterValue, this.note);

  num get costs => pricePerLitre * litre;

  factory ConsumptionItem.createNew({
    required String consumptionId,
    required DateTime date,
    required num pricePerLitre,
    required num litre,
    int? meterValue,
    String? note,
  }) {
    return ConsumptionItem(
      Uuid().v4().toString(),
      consumptionId,
      date,
      pricePerLitre,
      litre,
      meterValue,
      note ?? '',
    );
  }

  ConsumptionItem copyWith({
    DateTime? date,
    required int? meterValue,
    num? pricePerLitre,
    num? litre,
    String? note,
  }) {
    return ConsumptionItem(
      id,
      consumptionId,
      date ?? this.date,
      pricePerLitre ?? this.pricePerLitre,
      litre ?? this.litre,
      meterValue,
      note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'consumptionId': consumptionId,
      'date': date.millisecondsSinceEpoch,
      'pricePerLitre': pricePerLitre,
      'litre': litre,
      'meterValue': meterValue,
      'note': note,
    };
  }

  factory ConsumptionItem.fromMap(Map<String, dynamic> map) {
    return ConsumptionItem(
      map['id'] as String,
      map['consumptionId'] as String,
      DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      map['pricePerLitre'] as num,
      map['litre'] as num,
      map['meterValue'] as int?,
      map['note'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConsumptionItem.fromJson(String source) =>
      ConsumptionItem.fromMap(json.decode(source) as Map<String, dynamic>);

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

  @override
  bool operator ==(covariant ConsumptionItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.consumptionId == consumptionId &&
        other.date == date &&
        other.pricePerLitre == pricePerLitre &&
        other.litre == litre &&
        other.meterValue == meterValue &&
        other.note == note;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        consumptionId.hashCode ^
        date.hashCode ^
        pricePerLitre.hashCode ^
        litre.hashCode ^
        meterValue.hashCode ^
        note.hashCode;
  }
}
