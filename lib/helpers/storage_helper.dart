import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/survey_model.dart';
import '../models/survey_with_id.dart';
import 'web_storage_helper.dart';
// Conditional import for database helper
import 'database_helper_loader.dart' if (dart.library.html) 'database_helper_loader_stub.dart' as db_loader;

abstract class StorageHelper {
  Future<int> insertSurvey(SurveyModel survey);
  Future<List<SurveyModel>> getAllSurveys();
  Future<List<SurveyWithId>> getAllSurveysWithIds();
  Future<SurveyModel?> getSurveyById(int id);
  Future<int> updateSurvey(int id, SurveyModel survey);
  Future<int> deleteSurvey(int id);
  Future<List<SurveyModel>> getUnsyncedSurveys();
  Future<int> markAsSynced(int id);
  Future<void> initDB();
}

class StorageFactory {
  static StorageHelper getStorage() {
    if (kIsWeb) {
      return WebStorageHelper();
    } else {
      // Use the loader which handles conditional import
      return db_loader.loadDatabaseHelper();
    }
  }
}
