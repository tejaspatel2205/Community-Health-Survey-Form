// This file is conditionally imported
// On mobile (dart.library.io exists): imports database_helper.dart
// On web (dart.library.io doesn't exist): imports database_helper_stub.dart

import 'storage_helper.dart';
import 'database_helper_stub.dart' if (dart.library.io) 'database_helper.dart' as helper;

StorageHelper loadDatabaseHelper() {
  return helper.DatabaseHelper.instance;
}

