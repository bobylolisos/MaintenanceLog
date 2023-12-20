import 'dart:convert';

class Post {
  final String id;
  final DateTime date;
  final int odometer;
  final int costs;
  final String note;
  final List<String> images;

  Post(this.id, this.date, this.odometer, this.costs, this.note, this.images);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'odometer': odometer,
      'costs': costs,
      'note': note,
      'images': images.toList(),
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      map['id'] as String,
      DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      map['odometer'] as int,
      map['costs'] as int,
      map['note'] as String,
      List<String>.from(map['images'] as List),
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) =>
      Post.fromMap(json.decode(source) as Map<String, dynamic>);
}
