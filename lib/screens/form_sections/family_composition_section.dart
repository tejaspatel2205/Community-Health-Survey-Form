import 'package:flutter/material.dart';
import '../../models/survey_model.dart';

class FamilyCompositionSection extends StatefulWidget {
  final SurveyModel survey;

  const FamilyCompositionSection({super.key, required this.survey});

  @override
  State<FamilyCompositionSection> createState() => _FamilyCompositionSectionState();
}

class _FamilyCompositionSectionState extends State<FamilyCompositionSection> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Family Composition',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: () => _addFamilyMember(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Member'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (widget.survey.familyMembers.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('No family members added yet. Click "Add Member" to start.'),
              ),
            ),
          )
        else
          ...widget.survey.familyMembers.asMap().entries.map((entry) {
            final index = entry.key;
            final member = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(member.name),
                subtitle: Text('${member.relationship} • ${member.age}y • ${member.gender}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      widget.survey.familyMembers.removeAt(index);
                    });
                  },
                ),
                onTap: () => _editFamilyMember(context, index),
              ),
            );
          }),
      ],
    );
  }

  void _addFamilyMember(BuildContext context) {
    _showFamilyMemberDialog(context, null);
  }

  void _editFamilyMember(BuildContext context, int index) {
    _showFamilyMemberDialog(context, index);
  }

  void _showFamilyMemberDialog(BuildContext context, int? index) {
    final nameController = TextEditingController();
    final relationshipController = TextEditingController();
    final ageController = TextEditingController();
    final occupationController = TextEditingController();
    final incomeController = TextEditingController();
    final healthStatusController = TextEditingController();

    String? gender;
    String? education;

    if (index != null) {
      final member = widget.survey.familyMembers[index];
      nameController.text = member.name;
      relationshipController.text = member.relationship;
      ageController.text = member.age.toString();
      occupationController.text = member.occupation;
      incomeController.text = member.income?.toString() ?? '';
      healthStatusController.text = member.healthStatus;
      gender = member.gender;
      education = member.education;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(index == null ? 'Add Family Member' : 'Edit Family Member'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: relationshipController,
                  decoration: const InputDecoration(
                    labelText: 'Relationship with Head',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Head of family, wife, son',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age (years)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: gender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      gender = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: education,
                  decoration: const InputDecoration(
                    labelText: 'Education',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Illiterate', child: Text('Illiterate')),
                    DropdownMenuItem(value: 'Primary', child: Text('Primary')),
                    DropdownMenuItem(value: 'Secondary', child: Text('Secondary')),
                    DropdownMenuItem(value: 'Higher Secondary', child: Text('Higher Secondary')),
                    DropdownMenuItem(value: 'Graduate', child: Text('Graduate')),
                    DropdownMenuItem(value: 'Post Graduate', child: Text('Post Graduate')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      education = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: occupationController,
                  decoration: const InputDecoration(
                    labelText: 'Occupation',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: incomeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Income (₹)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: healthStatusController,
                  decoration: const InputDecoration(
                    labelText: 'General Health Status',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Healthy, Anemia',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    relationshipController.text.isNotEmpty &&
                    ageController.text.isNotEmpty &&
                    gender != null &&
                    education != null &&
                    occupationController.text.isNotEmpty &&
                    healthStatusController.text.isNotEmpty) {
                  final member = FamilyMember(
                    name: nameController.text,
                    relationship: relationshipController.text,
                    age: int.parse(ageController.text),
                    gender: gender!,
                    education: education!,
                    occupation: occupationController.text,
                    income: double.tryParse(incomeController.text),
                    healthStatus: healthStatusController.text,
                  );

                  setState(() {
                    if (index == null) {
                      widget.survey.familyMembers.add(member);
                    } else {
                      widget.survey.familyMembers[index] = member;
                    }
                  });

                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

