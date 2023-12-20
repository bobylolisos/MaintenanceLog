import 'package:cloud_firestore/cloud_firestore.dart';

extension DocumentSnapshotExtensions on DocumentSnapshot<Object?> {
  Map<String, dynamic> get map => data() as Map<String, dynamic>;
}
