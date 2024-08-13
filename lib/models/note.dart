// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:uuid/uuid.dart';

class Note {
  final String id;
  final String header;
  final String subHeader;
  final String text;
  int sortOrder;

  Note({
    required this.id,
    required this.header,
    required this.subHeader,
    required this.text,
    required this.sortOrder,
  });

  factory Note.createNew(
    String header,
    String subHeader,
    String text,
  ) {
    return Note(
      id: Uuid().v4().toString(),
      header: header,
      subHeader: subHeader,
      text: text,
      sortOrder: 0,
    );
  }

  Note copyWith({
    String? header,
    String? subHeader,
    String? text,
    int? sortOrder,
  }) {
    return Note(
      id: id,
      header: header ?? this.header,
      subHeader: subHeader ?? this.subHeader,
      text: text ?? this.text,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'header': header,
      'subHeader': subHeader,
      'text': text,
      'sortOrder': sortOrder,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as String,
      header: map['header'] as String,
      subHeader: map['subHeader'] as String,
      text: map['text'] as String,
      sortOrder: map['sortOrder'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) =>
      Note.fromMap(json.decode(source) as Map<String, dynamic>);
}
