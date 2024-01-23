import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:maintenance_log/providers/device_path_provider.dart';
import 'package:maintenance_log/providers/path_provider.dart';
import 'package:maintenance_log/repositories/firestore_maintenance_repository.dart';

GetIt ioc = GetIt.instance;

void setupIoc() {
  ioc.registerSingleton<PathProvider>(DevicePathProvider());
  ioc.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  // setup repositories
  ioc.registerLazySingleton<FirestoreMaintenanceRepository>(
    () => FirestoreMaintenanceRepository(
      firestore: ioc.get(),
    ),
  );
}
