import 'dart:convert';

class Consumption {
  final String id;
  final DateTime date;
  final double pricePerLitre;
  final double litre;
  final int trip;

  Consumption(this.id, this.date, this.pricePerLitre, this.litre, this.trip);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'pricePerLitre': pricePerLitre,
      'litre': litre,
      'trip': trip,
    };
  }

  factory Consumption.fromMap(Map<String, dynamic> map) {
    return Consumption(
      map['id'] as String,
      DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      map['pricePerLitre'] as double,
      map['litre'] as double,
      map['trip'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Consumption.fromJson(String source) =>
      Consumption.fromMap(json.decode(source) as Map<String, dynamic>);
}
