import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import '../models/survey_model.dart';
import '../models/survey_with_id.dart';
import 'storage_helper.dart';

class DatabaseHelper implements StorageHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  @override
  Future<void> initDB() async {
    if (_database == null) {
      _database = await _initDB('surveys.db');
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    await initDB();
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE surveys (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        survey_data TEXT NOT NULL,
        created_at TEXT NOT NULL,
        synced INTEGER DEFAULT 0,
        surveyor_name TEXT,
        area_name TEXT
      )
    ''');
  }

  Future<int> insertSurvey(SurveyModel survey) async {
    final db = await database;
    final surveyJson = jsonEncode(survey.toJson());
    final now = DateTime.now().toIso8601String();

    return await db.insert(
      'surveys',
      {
        'survey_data': surveyJson,
        'created_at': now,
        'synced': 0,
        'surveyor_name': survey.surveyorName,
        'area_name': survey.areaName,
      },
    );
  }

  Future<List<SurveyModel>> getAllSurveys() async {
    final db = await database;
    final maps = await db.query('surveys', orderBy: 'created_at DESC');

    return maps.map((map) {
      final surveyData = jsonDecode(map['survey_data'] as String);
      return SurveyModel.fromJson(surveyData);
    }).toList();
  }

  @override
  Future<List<SurveyWithId>> getAllSurveysWithIds() async {
    final db = await database;
    final maps = await db.query('surveys', orderBy: 'created_at DESC');

    return maps.map((map) {
      final id = map['id'] as int;
      final surveyData = jsonDecode(map['survey_data'] as String);
      final survey = SurveyModel.fromJson(surveyData);
      // Add sync status to survey for tracking
      survey.isSynced = (map['synced'] as int) == 1;
      return SurveyWithId(id: id, survey: survey);
    }).toList();
  }

  Future<SurveyModel?> getSurveyById(int id) async {
    final db = await database;
    final maps = await db.query(
      'surveys',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    final surveyData = jsonDecode(maps.first['survey_data'] as String);
    return SurveyModel.fromJson(surveyData);
  }

  Future<int> updateSurvey(int id, SurveyModel survey) async {
    final db = await database;
    final surveyJson = jsonEncode(survey.toJson());

    return await db.update(
      'surveys',
      {
        'survey_data': surveyJson,
        'surveyor_name': survey.surveyorName,
        'area_name': survey.areaName,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteSurvey(int id) async {
    final db = await database;
    return await db.delete(
      'surveys',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<SurveyModel>> getUnsyncedSurveys() async {
    final db = await database;
    final maps = await db.query(
      'surveys',
      where: 'synced = ?',
      whereArgs: [0],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) {
      final surveyData = jsonDecode(map['survey_data'] as String);
      return SurveyModel.fromJson(surveyData);
    }).toList();
  }

  Future<int> markAsSynced(int id) async {
    final db = await database;
    return await db.update(
      'surveys',
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

