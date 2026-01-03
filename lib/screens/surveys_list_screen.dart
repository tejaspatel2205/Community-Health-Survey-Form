import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/survey_provider.dart';
import '../models/survey_model.dart';
import 'survey_form_screen.dart';
import 'survey_detail_screen.dart';

class SurveysListScreen extends StatefulWidget {
  const SurveysListScreen({super.key});

  @override
  State<SurveysListScreen> createState() => _SurveysListScreenState();
}

class _SurveysListScreenState extends State<SurveysListScreen> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkUserType();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SurveyProvider>(context, listen: false).loadSurveys();
    });
  }

  Future<void> _checkUserType() async {
    final prefs = await SharedPreferences.getInstance();
    final userType = prefs.getString('user_type');
    setState(() {
      _isAdmin = userType == 'admin';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Surveys'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Consumer<SurveyProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.surveys.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No surveys found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create a new survey to get started',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.surveysWithId.length,
            itemBuilder: (context, index) {
              final surveyWithId = provider.surveysWithId[index];
              final survey = surveyWithId.survey;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade700,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    survey.areaName ?? 'Unnamed Survey',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (survey.studentId != null)
                        Text(
                          'Student ID: ${survey.studentId}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      if (survey.headOfFamily != null)
                        Text('Head: ${survey.headOfFamily}'),
                      if (survey.surveyorName != null)
                        Text('Surveyor: ${survey.surveyorName}'),
                      if (survey.surveyDate != null)
                        Text('Date: ${survey.surveyDate}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Sync status indicator
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: survey.isSynced ? Colors.green.shade100 : Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: survey.isSynced ? Colors.green.shade300 : Colors.orange.shade300,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                survey.isSynced ? Icons.cloud_done : Icons.cloud_off,
                                size: 12,
                                color: survey.isSynced ? Colors.green.shade700 : Colors.orange.shade700,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                survey.isSynced ? 'Synced' : 'Local',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: survey.isSynced ? Colors.green.shade700 : Colors.orange.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'view',
                            child: Row(
                              children: [
                                Icon(Icons.visibility),
                                SizedBox(width: 8),
                                Text('View'),
                              ],
                            ),
                          ),
                          if (!_isAdmin)
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                          if (!survey.isSynced)
                            const PopupMenuItem(
                              value: 'sync',
                              child: Row(
                                children: [
                                  Icon(Icons.cloud_upload),
                                  SizedBox(width: 8),
                                  Text('Sync to Server'),
                                ],
                              ),
                            ),
                          if (!_isAdmin)
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                        ],
                        onSelected: (value) async {
                      if (value == 'view') {
                        // Show detailed survey view for admin, simple dialog for students
                        if (_isAdmin) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SurveyDetailScreen(survey: survey),
                            ),
                          );
                        } else {
                          _showSurveyDetails(context, survey);
                        }
                      } else if (value == 'edit' && !_isAdmin) {
                        // Navigate to edit survey
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurveyFormScreen(survey: survey, surveyId: surveyWithId.id),
                          ),
                        ).then((_) {
                          // Reload surveys after editing
                          Provider.of<SurveyProvider>(context, listen: false).loadSurveys();
                        });
                      } else if (value == 'sync') {
                        final success = await provider.syncSurvey(survey);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Survey synced successfully'
                                    : 'Failed to sync survey',
                              ),
                              backgroundColor:
                                  success ? Colors.green : Colors.red,
                            ),
                          );
                        }
                      } else if (value == 'delete') {
                        if (_isAdmin) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Admin cannot delete surveys. Only students can delete their own surveys.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        if (survey.isSynced) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cannot delete synced surveys. Contact admin if needed.'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Survey?'),
                            content: const Text(
                              'Are you sure you want to delete this survey? This action cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await provider.deleteSurvey(surveyWithId.id);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Survey deleted'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        }
                      }
                        }
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showSurveyDetails(BuildContext context, SurveyModel survey) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(survey.areaName ?? 'Survey Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (survey.studentId != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.badge, color: Colors.blue.shade700, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Student ID: ${survey.studentId}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              _buildDetailRow('Area Type', survey.areaType),
              _buildDetailRow('Health Centre', survey.healthCentre),
              _buildDetailRow('Head of Family', survey.headOfFamily),
              _buildDetailRow('Family Type', survey.familyType),
              _buildDetailRow('Religion', survey.religion),
              _buildDetailRow('Total Income', survey.totalIncome?.toString()),
              _buildDetailRow('Contact Number', survey.contactNumber),
              _buildDetailRow('Survey Date', survey.surveyDate),
              _buildDetailRow('Surveyor', survey.surveyorName),
              const SizedBox(height: 8),
              Text(
                'Family Members: ${survey.familyMembers.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

