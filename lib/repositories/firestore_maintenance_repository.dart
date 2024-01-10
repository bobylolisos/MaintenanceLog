import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_log/extensions/document_snapshot_extensions.dart';
import 'package:maintenance_log/models/maintenance_object.dart';

class FirestoreMaintenanceRepository {
  final FirebaseFirestore _firestore;

  FirestoreMaintenanceRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Stream<Iterable<MaintenanceObject>> subscribeForMaintenanceObjectChanges() {
    try {
      var collection = _firestore.collection('MaintenanceObjects');
      final Stream<QuerySnapshot<Object?>> snapshots = collection.snapshots();

      return snapshots.map(
          (event) => event.docs.map((e) => MaintenanceObject.fromMap(e.map)));
    } catch (e) {
      log('Failed to subscribe for cliques', error: e.toString());
      rethrow;
    }
  }

  // Future<void> setMaintenanceObjects(
  //     List<MaintenanceObject> maintenanceObjects) async {
  //   var collection = _firestore.collection('MaintenanceObjects');
  //   var docRef = collection.doc(maintenanceObject.id);
  //   await docRef.set(maintenanceObject.toMap());

  //   return maintenanceObject;
  // }

  Future<MaintenanceObject?> getMaintenanceObject(String id) async {
    var collection = _firestore.collection('MaintenanceObjects');
    var docRef = collection.doc(id);
    var snapshot = await docRef.get();
    var data = snapshot.data();
    // await Future.delayed(Duration(milliseconds: 300));

    return data != null ? MaintenanceObject.fromMap(data) : null;
  }

  Future<MaintenanceObject?> setMaintenanceObject(
      MaintenanceObject maintenanceObject) async {
    var collection = _firestore.collection('MaintenanceObjects');
    var docRef = collection.doc(maintenanceObject.id);
    await docRef.set(maintenanceObject.toMap());

    return maintenanceObject;
  }
}
