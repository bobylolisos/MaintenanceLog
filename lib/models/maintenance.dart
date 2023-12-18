import 'dart:convert';
import 'post.dart';

class Maintenance {
  final String id;
  final String name;
  final List<Post> posts;
  final String description;
  final int sortOrder; // ?????
  final bool isActive;
//  final List<Reminder> reminders;

  Maintenance(this.id, this.name, this.posts, this.description, this.sortOrder,
      this.isActive);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'posts': posts.map((x) => x.toMap()).toList(),
      'description': description,
      'sortOrder': sortOrder,
      'isActive': isActive,
    };
  }

  factory Maintenance.fromMap(Map<String, dynamic> map) {
    return Maintenance(
      map['id'] as String,
      map['name'] as String,
      List<Post>.from(
        (map['posts'] as List<int>).map<Post>(
          (x) => Post.fromMap(x as Map<String, dynamic>),
        ),
      ),
      map['description'] as String,
      map['sortOrder'] as int,
      map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Maintenance.fromJson(String source) =>
      Maintenance.fromMap(json.decode(source) as Map<String, dynamic>);
}
