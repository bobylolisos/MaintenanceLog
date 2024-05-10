// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:uuid/uuid.dart';

class Note {
  final String id;
  final String header;
  final String note;
  final int sortOrder;

  Note({
    required this.id,
    required this.header,
    required this.note,
    required this.sortOrder,
  });

  factory Note.createNew(
    String header,
    String note,
  ) {
    return Note(
      id: Uuid().v4().toString(),
      header: header,
      note: note,
      sortOrder: 0,
    );
  }

  Note copyWith({
    String? header,
    String? note,
    int? sortOrder,
  }) {
    return Note(
      id: id,
      header: header ?? this.header,
      note: note ?? this.note,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'header': header,
      'note': note,
      'description': note,
      'sortOrder': sortOrder,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as String,
      header: map['header'] as String,
      note: map['note'] as String,
      sortOrder: map['sortOrder'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) =>
      Note.fromMap(json.decode(source) as Map<String, dynamic>);
}
