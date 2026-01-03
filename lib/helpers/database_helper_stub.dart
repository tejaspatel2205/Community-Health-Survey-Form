// Stub file for web platform
// This file is only used when dart.library.html is available (web)
// On web, database_helper.dart is not imported, so this stub prevents errors

import '../models/survey_model.dart';
import '../models/survey_with_id.dart';
import 'storage_helper.dart';

class DatabaseHelper implements StorageHelper {
  // This should never be called on web
  static DatabaseHelper get instance {
    throw UnsupportedError('DatabaseHelper is not available on web platform');
  }

  DatabaseHelper._init();

  @override
  Future<void> initDB() async {
    throw UnsupportedError('DatabaseHelper is not available on web platform');
  }

  @override
  Future<int> insertSurvey(SurveyModel survey) async {
    throw UnsupportedError('DatabaseHelper is not available on web platform');
  }

  @override
  Future<List<SurveyModel>> getAllSurveys() async {
    throw UnsupportedError('DatabaseHelper is not available on web platform');
  }

  @override
  Future<List<SurveyWithId>> getAllSurveysWithIds() async {
    throw UnsupportedError('DatabaseHelper is not available on web platform');
  }

  @override
  Future<SurveyModel?> getSurveyById(int id) async {
    throw UnsupportedError('DatabaseHelper is not available on web platform');
  }

  @override
  Future<int> updateSurvey(int id, SurveyModel survey) async {
    throw UnsupportedError('DatabaseHelper is not available on web platform');
  }

  @override
  Future<int> deleteSurvey(int id) async {
    throw UnsupportedError('DatabaseHelper is not available on web platform');
  }

  @override
  Future<List<SurveyModel>> getUnsyncedSurveys() async {
    throw UnsupportedError('DatabaseHelper is not available on web platform');
  }

  @override
  Future<int> markAsSynced(int id) async {
    throw UnsupportedError('DatabaseHelper is not available on web platform');
  }
}

