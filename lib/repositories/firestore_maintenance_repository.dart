import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_log/extensions/document_snapshot_extensions.dart';
import 'package:maintenance_log/models/maintenance_object.dart';

class FirestoreMaintenanceRepository {
  static String MaintenanceObjectsKey = 'MaintenanceObjects2';

  final FirebaseFirestore _firestore;

  FirestoreMaintenanceRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Stream<Iterable<MaintenanceObject>> subscribeForMaintenanceObjectChanges() {
    try {
      var collection = _firestore.collection(MaintenanceObjectsKey);
      final Stream<QuerySnapshot<Object?>> snapshots = collection.snapshots();

      return snapshots.map(
          (event) => event.docs.map((e) => MaintenanceObject.fromMap(e.map)));
    } catch (e) {
      log('Failed to subscribe for changes', error: e.toString());
      rethrow;
    }
  }

  Future<void> reorderMaintenanceObjects(
      List<MaintenanceObject> maintenanceObjects) async {
    var collection = _firestore.collection(MaintenanceObjectsKey);

    for (var i = 0; i < maintenanceObjects.length; i++) {
      final maintenanceObject = maintenanceObjects.elementAt(i);
      var docRef = collection.doc(maintenanceObject.id);

      if (maintenanceObject.sortOrder != i + 1000) {
        // Sortorder changed
        final reorderedMaintenanceObject =
            maintenanceObject.copyWith(sortOrder: i + 1000);
        await docRef.set(reorderedMaintenanceObject.toMap());
      } else {
        print('SortOrder not changed for ' + maintenanceObject.header);
      }
    }
  }

  Future<MaintenanceObject?> getMaintenanceObject(String id) async {
    var collection = _firestore.collection(MaintenanceObjectsKey);
    var docRef = collection.doc(id);
    var snapshot = await docRef.get();
    var data = snapshot.data();
    // await Future.delayed(Duration(milliseconds: 300));

    return data != null ? MaintenanceObject.fromMap(data) : null;
  }

  Future<MaintenanceObject?> setMaintenanceObject(
      MaintenanceObject maintenanceObject) async {
    var collection = _firestore.collection(MaintenanceObjectsKey);
    var docRef = collection.doc(maintenanceObject.id);
    await docRef.set(maintenanceObject.toMap());

    return maintenanceObject;
  }

  Future<void> deleteMaintenanceObject(String maintenanceObjectId) async {
    var collection = _firestore.collection(MaintenanceObjectsKey);
    var docRef = collection.doc(maintenanceObjectId);
    await docRef.delete();
  }
}
