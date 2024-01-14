import 'dart:convert';

class MaintenanceItem {
  final String id;
  final DateTime date;
  final int meterValue;
  final int costs;
  final String note;
  final List<String> images;

  MaintenanceItem(
      this.id, this.date, this.meterValue, this.costs, this.note, this.images);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
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
      DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      map['meterValue'] as int,
      map['costs'] as int,
      map['note'] as String,
      List<String>.from(map['images'] as List),
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceItem.fromJson(String source) =>
      MaintenanceItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
