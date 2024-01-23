import 'package:path_provider/path_provider.dart' as path_provider;

import 'path_provider.dart';

class DevicePathProvider implements PathProvider {
  @override
  Future<String> getHivePath() async {
    final directory = await path_provider.getApplicationDocumentsDirectory();

    return directory.path;
  }
}
