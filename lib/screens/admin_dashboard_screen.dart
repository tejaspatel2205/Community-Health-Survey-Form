import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/survey_provider.dart';
import '../models/survey_model.dart';
import '../models/survey_with_id.dart';
import 'surveys_list_screen.dart';
import 'login_screen.dart';
import 'survey_detail_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SurveyProvider>(context, listen: false);
      provider.setCurrentStudentId(''); // Clear student filter for admin
      provider.loadSurveys();
    });
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
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
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_type');
      await prefs.remove('admin_username');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final provider = Provider.of<SurveyProvider>(context, listen: false);
              provider.setCurrentStudentId(''); // Clear student filter for admin
              provider.loadSurveys();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: Consumer<SurveyProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final surveys = provider.surveysWithId;
          final totalSurveys = surveys.length;

          // Group surveys by student ID
          final Map<String, List<SurveyWithId>> surveysByStudent = {};
          for (var survey in surveys) {
            final studentId = survey.survey.studentId ?? 'Unknown';
            surveysByStudent.putIfAbsent(studentId, () => []).add(survey);
          }

          // Calculate statistics
          final uniqueStudents = surveysByStudent.keys.length;
          final studentCounts = surveysByStudent.map(
            (key, value) => MapEntry(key, value.length),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Surveys',
                        totalSurveys.toString(),
                        Icons.assignment,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Students',
                        uniqueStudents.toString(),
                        Icons.people,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Sync All Button
                if (provider.totalUnsyncedCount > 0)
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Server Sync',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: provider.isLoading ? null : () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Sync All Surveys'),
                                    content: Text('Upload ${provider.totalUnsyncedCount} unsynced surveys to server?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.purple.shade700,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('Sync All'),
                                      ),
                                    ],
                                  ),
                                );
                                
                                if (confirm == true) {
                                  try {
                                    await provider.syncAllSurveys();
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('All surveys successfully synced to server!'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(e.toString().replaceFirst('Exception: ', '')),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                              icon: provider.isLoading 
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Icon(Icons.cloud_upload),
                              label: Text(
                                provider.isLoading ? 'Syncing...' : 'Sync All Surveys to Server',
                                style: const TextStyle(fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple.shade700,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                // Surveys by Student Chart
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Surveys by Student ID',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SurveysListScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.list),
                              label: const Text('View All'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (studentCounts.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text(
                                'No surveys available',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        else
                          ...studentCounts.entries.map((entry) {
                            final studentId = entry.key;
                            final count = entry.value;
                            final percentage = totalSurveys > 0
                                ? (count / totalSurveys * 100).toStringAsFixed(1)
                                : '0.0';
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.badge,
                                        size: 20,
                                        color: Colors.purple.shade700,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Student ID: $studentId',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$count survey${count > 1 ? 's' : ''} ($percentage%)',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: totalSurveys > 0
                                          ? count / totalSurveys
                                          : 0,
                                      minHeight: 8,
                                      backgroundColor: Colors.grey.shade200,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.purple.shade400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Recent Surveys List
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recent Surveys',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (surveys.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text(
                                'No surveys found',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        else
                          ...surveys.take(10).map((surveyWithId) {
                            final survey = surveyWithId.survey;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              color: Colors.grey.shade50,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.purple.shade700,
                                  child: Text(
                                    '${surveyWithId.id}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  survey.areaName ?? 'Unnamed Survey',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (survey.studentId != null)
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.badge,
                                            size: 14,
                                            color: Colors.purple.shade700,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'ID: ${survey.studentId}',
                                            style: TextStyle(
                                              color: Colors.purple.shade700,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (survey.headOfFamily != null)
                                      Text('Head: ${survey.headOfFamily}'),
                                    if (survey.surveyDate != null)
                                      Text('Date: ${survey.surveyDate}'),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.visibility),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SurveyDetailScreen(survey: survey),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }),
                        if (surveys.length > 10)
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SurveysListScreen(),
                                  ),
                                );
                              },
                              child: const Text('View All Surveys'),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 32),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
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
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.purple.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.badge, color: Colors.purple.shade700, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Student ID: ${survey.studentId}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade700,
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

