import 'package:flutter/foundation.dart';
import '../models/survey_model.dart';
import '../models/survey_with_id.dart';
import '../helpers/storage_helper.dart';
import '../services/api_service.dart';

class SurveyProvider with ChangeNotifier {
  final StorageHelper _storage = StorageFactory.getStorage();
  List<SurveyWithId> _surveys = [];
  bool _isLoading = false;

  String? currentStudentId;

  void setCurrentStudentId(String studentId) {
    currentStudentId = studentId;
    notifyListeners();
  }

  List<SurveyModel> get surveys => _surveys
      .where((s) => currentStudentId == null || currentStudentId!.isEmpty || s.survey.studentId == currentStudentId)
      .map((s) => s.survey)
      .toList();
  List<SurveyWithId> get surveysWithId => _surveys
      .where((s) => currentStudentId == null || currentStudentId!.isEmpty || s.survey.studentId == currentStudentId)
      .toList();
  bool get isLoading => _isLoading;
  
  int get unsyncedCount {
    // Count unsynced surveys from the loaded surveys
    return _surveys.where((s) => 
      (currentStudentId == null || currentStudentId!.isEmpty || s.survey.studentId == currentStudentId) &&
      !s.survey.isSynced
    ).length;
  }
  
  int get totalUnsyncedCount {
    // Count all unsynced surveys regardless of student filter
    return _surveys.where((s) => !s.survey.isSynced).length;
  }

  bool _isSynced(SurveyModel survey) {
    // Check if survey is synced by looking at the database
    // This is a simplified check - in practice, we'd need the survey ID
    return false; // Will be properly checked when loading from database
  }

  Future<void> loadSurveys() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _storage.initDB();
      final surveysWithIds = await _storage.getAllSurveysWithIds();
      _surveys = surveysWithIds;
    } catch (e) {
      debugPrint('Error loading surveys: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int> saveSurvey(SurveyModel survey) async {
    try {
      await _storage.initDB();
      final id = await _storage.insertSurvey(survey);
      await loadSurveys();
      return id;
    } catch (e) {
      debugPrint('Error saving survey: $e');
      return -1;
    }
  }

  Future<bool> updateSurvey(int id, SurveyModel survey) async {
    try {
      await _storage.initDB();
      await _storage.updateSurvey(id, survey);
      await loadSurveys();
      return true;
    } catch (e) {
      debugPrint('Error updating survey: $e');
      return false;
    }
  }

  Future<bool> deleteSurvey(int id) async {
    try {
      await _storage.initDB();
      await _storage.deleteSurvey(id);
      await loadSurveys();
      return true;
    } catch (e) {
      debugPrint('Error deleting survey: $e');
      return false;
    }
  }

  Future<bool> syncSurvey(SurveyModel survey) async {
    try {
      final success = await ApiService.submitSurvey(survey);
      if (success) {
        // Find survey ID and mark as synced
        final surveys = await _storage.getAllSurveysWithIds();
        final surveyWithId = surveys.firstWhere(
          (s) => s.survey.areaName == survey.areaName && 
                 s.survey.headOfFamily == survey.headOfFamily &&
                 s.survey.surveyDate == survey.surveyDate,
          orElse: () => SurveyWithId(id: -1, survey: survey),
        );
        if (surveyWithId.id != -1) {
          await _storage.markAsSynced(surveyWithId.id);
        }
      }
      return success;
    } catch (e) {
      debugPrint('Error syncing survey: $e');
      return false;
    }
  }

  Future<void> syncAllSurveys() async {
    _isLoading = true;
    notifyListeners();

    int successCount = 0;
    int totalCount = 0;

    try {
      await _storage.initDB();
      final unsyncedSurveysWithIds = await _storage.getAllSurveysWithIds();
      final unsyncedSurveys = await _storage.getUnsyncedSurveys();
      totalCount = unsyncedSurveys.length;
      
      for (var survey in unsyncedSurveys) {
        final success = await ApiService.submitSurvey(survey);
        if (success) {
          successCount++;
          // Find the survey ID and mark as synced
          final surveyWithId = unsyncedSurveysWithIds.firstWhere(
            (s) => s.survey.areaName == survey.areaName && 
                   s.survey.headOfFamily == survey.headOfFamily &&
                   s.survey.surveyDate == survey.surveyDate,
            orElse: () => SurveyWithId(id: -1, survey: survey),
          );
          if (surveyWithId.id != -1) {
            await _storage.markAsSynced(surveyWithId.id);
          }
        }
      }
      await loadSurveys();
    } catch (e) {
      debugPrint('Error syncing all surveys: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    
    // Return sync results for UI feedback
    if (totalCount == 0) {
      throw Exception('No surveys to sync');
    } else if (successCount == 0) {
      throw Exception('Failed to sync any surveys. Check server connection.');
    } else if (successCount < totalCount) {
      throw Exception('Synced $successCount of $totalCount surveys. Some failed.');
    }
    // If we reach here, all surveys synced successfully
  }
}

