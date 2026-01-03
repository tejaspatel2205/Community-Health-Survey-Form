import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/survey_provider.dart';
import '../models/survey_model.dart';
import 'form_sections/basic_info_section.dart';
import 'form_sections/housing_section.dart';
import 'form_sections/family_composition_section.dart';
import 'form_sections/income_section.dart';
import 'form_sections/dietary_pattern_section.dart';
import 'form_sections/health_section.dart';
import 'form_sections/pregnant_vital_section.dart';
import 'form_sections/comprehensive_section.dart';

class SurveyFormScreen extends StatefulWidget {
  final SurveyModel? survey;
  final int? surveyId;
  
  const SurveyFormScreen({super.key, this.survey, this.surveyId});

  @override
  State<SurveyFormScreen> createState() => _SurveyFormScreenState();
}

class _SurveyFormScreenState extends State<SurveyFormScreen> {
  final PageController _pageController = PageController();
  late final SurveyModel _survey;
  late final bool _isEditing;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.survey != null;
    _survey = widget.survey ?? SurveyModel();
  }

  final List<String> _sectionTitles = [
    'Basic Information',
    'Housing Condition',
    'Family Composition',
    'Income & Communication',
    'Dietary Pattern',
    'Health Conditions',
    'Pregnant Women & Vital Statistics',
    'Comprehensive Health & Family Assessment',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _sectionTitles.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _saveSurvey() async {
    if (!_isEditing) {
      _survey.surveyDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      
      // Get and save student ID
      final prefs = await SharedPreferences.getInstance();
      final studentId = prefs.getString('student_id');
      if (studentId != null) {
        _survey.studentId = studentId;
      }
    }
    
    final provider = Provider.of<SurveyProvider>(context, listen: false);
    
    bool success;
    if (_isEditing && widget.surveyId != null) {
      success = await provider.updateSurvey(widget.surveyId!, _survey);
    } else {
      final id = await provider.saveSurvey(_survey);
      success = id > 0;
    }

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Survey updated successfully!' : 'Survey saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Error updating survey. Please try again.' : 'Error saving survey. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_sectionTitles[_currentPage]),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Discard Survey?'),
                content: const Text(
                  'Are you sure you want to go back? All unsaved data will be lost.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Go back
                    },
                    child: const Text('Discard'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (_currentPage + 1) / _sectionTitles.length,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Section ${_currentPage + 1} of ${_sectionTitles.length}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Form content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              physics: const NeverScrollableScrollPhysics(),
              children: [
                BasicInfoSection(survey: _survey),
                HousingSection(survey: _survey),
                FamilyCompositionSection(survey: _survey),
                IncomeSection(survey: _survey),
                DietaryPatternSection(survey: _survey),
                HealthSection(survey: _survey),
                PregnantVitalSection(survey: _survey),
                ComprehensiveSection(survey: _survey),
              ],
            ),
          ),
          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0)
                  OutlinedButton.icon(
                    onPressed: _previousPage,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  )
                else
                  const SizedBox(),
                if (_currentPage < _sectionTitles.length - 1)
                  ElevatedButton.icon(
                    onPressed: _nextPage,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: _saveSurvey,
                    icon: const Icon(Icons.save),
                    label: Text(_isEditing ? 'Update Survey' : 'Save Survey'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

