import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:maintenance_log/models/meter_type.dart';
import 'package:uuid/uuid.dart';

class ConsumptionItem {
  final String id;
  final String consumptionId;
  final DateTime date;
  final num pricePerLitre;
  final num litre;
  final int? meterValue;
  final String note;
  final List<String> images;

  ConsumptionItem(this.id, this.consumptionId, this.date, this.pricePerLitre,
      this.litre, this.meterValue, this.note, this.images);

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
      [],
    );
  }

  ConsumptionItem copyWith({
    DateTime? date,
    required int? meterValue,
    num? pricePerLitre,
    num? litre,
    String? note,
    List<String>? images,
  }) {
    return ConsumptionItem(
      id,
      consumptionId,
      date ?? this.date,
      pricePerLitre ?? this.pricePerLitre,
      litre ?? this.litre,
      meterValue,
      note ?? this.note,
      images ?? this.images,
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
      'images': images.toList(),
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
      List<String>.from(map['images'] as List),
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
}
