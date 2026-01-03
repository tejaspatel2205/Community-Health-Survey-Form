import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/survey_model.dart';

class ApiService {
  // Change this to your server URL
  static const String baseUrl = 'https://your-server-url.com/api';
  // For local testing: 'http://localhost:3000/api' or 'http://10.0.2.2:3000/api' for Android emulator

  static Future<bool> submitSurvey(SurveyModel survey) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/surveys'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(survey.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error submitting survey: $e');
      return false;
    }
  }

  static Future<List<SurveyModel>> getSurveys() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/surveys'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => SurveyModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching surveys: $e');
      return [];
    }
  }

  static Future<SurveyModel?> getSurveyById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/surveys/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return SurveyModel.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Error fetching survey: $e');
      return null;
    }
  }

  static Future<bool> syncSurveys(List<SurveyModel> surveys) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/surveys/sync'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'surveys': surveys.map((s) => s.toJson()).toList(),
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error syncing surveys: $e');
      return false;
    }
  }
}

