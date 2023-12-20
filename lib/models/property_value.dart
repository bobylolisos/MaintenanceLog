import 'dart:convert';

class PropertyValue {
  final String id;
  final String label;
  final String text;
  final int sortOrder;

  PropertyValue(this.id, this.label, this.text, this.sortOrder);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'label': label,
      'text': text,
      'sortOrder': sortOrder,
    };
  }

  factory PropertyValue.fromMap(Map<String, dynamic> map) {
    return PropertyValue(
      map['id'] as String,
      map['label'] as String,
      map['text'] as String,
      map['sortOrder'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PropertyValue.fromJson(String source) =>
      PropertyValue.fromMap(json.decode(source) as Map<String, dynamic>);
}
