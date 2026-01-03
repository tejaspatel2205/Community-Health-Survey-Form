import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/survey_model.dart';
import '../models/survey_with_id.dart';
import 'storage_helper.dart';

class WebStorageHelper implements StorageHelper {
  static const String _surveysKey = 'surveys_list';
  static const String _lastIdKey = 'last_survey_id';

  @override
  Future<void> initDB() async {
    // No initialization needed for web
  }

  Future<List<Map<String, dynamic>>> _getAllSurveyMaps() async {
    final prefs = await SharedPreferences.getInstance();
    final surveysJson = prefs.getStringList(_surveysKey) ?? [];
    return surveysJson.map((json) => jsonDecode(json) as Map<String, dynamic>).toList();
  }

  Future<void> _saveAllSurveyMaps(List<Map<String, dynamic>> surveys) async {
    final prefs = await SharedPreferences.getInstance();
    final surveysJson = surveys.map((map) => jsonEncode(map)).toList();
    await prefs.setStringList(_surveysKey, surveysJson);
  }

  Future<int> _getNextId() async {
    final prefs = await SharedPreferences.getInstance();
    final lastId = prefs.getInt(_lastIdKey) ?? 0;
    final nextId = lastId + 1;
    await prefs.setInt(_lastIdKey, nextId);
    return nextId;
  }

  @override
  Future<int> insertSurvey(SurveyModel survey) async {
    final surveys = await _getAllSurveyMaps();
    final id = await _getNextId();
    final now = DateTime.now().toIso8601String();

    final surveyMap = {
      'id': id,
      'survey_data': survey.toJson(),
      'created_at': now,
      'synced': 0,
      'surveyor_name': survey.surveyorName,
      'area_name': survey.areaName,
    };

    surveys.add(surveyMap);
    await _saveAllSurveyMaps(surveys);
    return id;
  }

  @override
  Future<List<SurveyModel>> getAllSurveys() async {
    final surveys = await _getAllSurveyMaps();
    surveys.sort((a, b) => (b['created_at'] as String).compareTo(a['created_at'] as String));
    
    return surveys.map((map) {
      final surveyData = map['survey_data'] as Map<String, dynamic>;
      return SurveyModel.fromJson(surveyData);
    }).toList();
  }

  @override
  Future<List<SurveyWithId>> getAllSurveysWithIds() async {
    final surveys = await _getAllSurveyMaps();
    surveys.sort((a, b) => (b['created_at'] as String).compareTo(a['created_at'] as String));
    
    return surveys.map((map) {
      final id = map['id'] as int;
      final surveyData = map['survey_data'] as Map<String, dynamic>;
      final survey = SurveyModel.fromJson(surveyData);
      // Add sync status to survey for tracking
      survey.isSynced = (map['synced'] as int) == 1;
      return SurveyWithId(id: id, survey: survey);
    }).toList();
  }

  @override
  Future<SurveyModel?> getSurveyById(int id) async {
    final surveys = await _getAllSurveyMaps();
    final surveyMap = surveys.firstWhere(
      (map) => map['id'] == id,
      orElse: () => <String, dynamic>{},
    );

    if (surveyMap.isEmpty) return null;

    final surveyData = surveyMap['survey_data'] as Map<String, dynamic>;
    return SurveyModel.fromJson(surveyData);
  }

  @override
  Future<int> updateSurvey(int id, SurveyModel survey) async {
    final surveys = await _getAllSurveyMaps();
    final index = surveys.indexWhere((map) => map['id'] == id);

    if (index == -1) return 0;

    surveys[index] = {
      'id': id,
      'survey_data': survey.toJson(),
      'created_at': surveys[index]['created_at'],
      'synced': surveys[index]['synced'],
      'surveyor_name': survey.surveyorName,
      'area_name': survey.areaName,
    };

    await _saveAllSurveyMaps(surveys);
    return 1;
  }

  @override
  Future<int> deleteSurvey(int id) async {
    final surveys = await _getAllSurveyMaps();
    final initialLength = surveys.length;
    surveys.removeWhere((map) => map['id'] == id);
    await _saveAllSurveyMaps(surveys);
    return initialLength - surveys.length;
  }

  @override
  Future<List<SurveyModel>> getUnsyncedSurveys() async {
    final surveys = await _getAllSurveyMaps();
    final unsynced = surveys.where((map) => map['synced'] == 0).toList();
    unsynced.sort((a, b) => (b['created_at'] as String).compareTo(a['created_at'] as String));

    return unsynced.map((map) {
      final surveyData = map['survey_data'] as Map<String, dynamic>;
      return SurveyModel.fromJson(surveyData);
    }).toList();
  }

  @override
  Future<int> markAsSynced(int id) async {
    final surveys = await _getAllSurveyMaps();
    final index = surveys.indexWhere((map) => map['id'] == id);

    if (index == -1) return 0;

    surveys[index]['synced'] = 1;
    await _saveAllSurveyMaps(surveys);
    return 1;
  }
}

