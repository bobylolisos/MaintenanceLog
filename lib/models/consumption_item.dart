import 'dart:convert';

class ConsumptionItem {
  final String id;
  final DateTime date;
  final num pricePerLitre;
  final num litre;
  final int trip;
  final String note;
  final List<String> images;

  ConsumptionItem(this.id, this.date, this.pricePerLitre, this.litre, this.trip,
      this.note, this.images);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'pricePerLitre': pricePerLitre,
      'litre': litre,
      'trip': trip,
      'note': note,
      'images': images.toList(),
    };
  }

  factory ConsumptionItem.fromMap(Map<String, dynamic> map) {
    return ConsumptionItem(
      map['id'] as String,
      DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      map['pricePerLitre'] as num,
      map['litre'] as num,
      map['trip'] as int,
      map['note'] as String,
      List<String>.from(map['images'] as List),
    );
  }

  String toJson() => json.encode(toMap());

  factory ConsumptionItem.fromJson(String source) =>
      ConsumptionItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
