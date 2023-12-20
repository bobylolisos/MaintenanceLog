import 'dart:convert';

class Note {
  final String id;
  final String name;
  final String text;
  final int sortOrder;
  final List<String> images;

  Note(this.id, this.name, this.text, this.sortOrder, this.images);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'text': text,
      'sortOrder': sortOrder,
      'images': images.toList(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      map['id'] as String,
      map['name'] as String,
      map['text'] as String,
      map['sortOrder'] as int,
      List<String>.from(map['images'] as List),
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) =>
      Note.fromMap(json.decode(source) as Map<String, dynamic>);
}
