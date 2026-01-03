// Stub loader for web platform
import 'storage_helper.dart';
import 'web_storage_helper.dart';

StorageHelper loadDatabaseHelper() {
  // This should never be called since we check kIsWeb first
  return WebStorageHelper();
}

