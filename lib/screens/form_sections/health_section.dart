import 'package:flutter/material.dart';
import '../../models/survey_model.dart';

class HealthSection extends StatefulWidget {
  final SurveyModel survey;

  const HealthSection({super.key, required this.survey});

  @override
  State<HealthSection> createState() => _HealthSectionState();
}

class _HealthSectionState extends State<HealthSection> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Health Conditions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildHealthConditionCard(
          'Fever Cases',
          widget.survey.feverCases,
          (list) => widget.survey.feverCases = list,
        ),
        const SizedBox(height: 16),
        _buildHealthConditionCard(
          'Skin Diseases',
          widget.survey.skinDiseases,
          (list) => widget.survey.skinDiseases = list,
        ),
        const SizedBox(height: 16),
        _buildHealthConditionCard(
          'Cough Cases (More than 2 weeks)',
          widget.survey.coughCases,
          (list) => widget.survey.coughCases = list,
        ),
        const SizedBox(height: 16),
        _buildHealthConditionCard(
          'Other Illnesses',
          widget.survey.otherIllnesses,
          (list) => widget.survey.otherIllnesses = list,
        ),
        const SizedBox(height: 24),
        const Text(
          'Family Health Attitude',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: widget.survey.healthKnowledge,
          decoration: const InputDecoration(
            labelText: 'Knowledge about Health and Illness',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Poor', child: Text('Poor')),
            DropdownMenuItem(value: 'Good', child: Text('Good')),
            DropdownMenuItem(value: 'Excellent', child: Text('Excellent')),
          ],
          onChanged: (value) {
            setState(() {
              widget.survey.healthKnowledge = value;
            });
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: widget.survey.nutritionKnowledge,
          decoration: const InputDecoration(
            labelText: 'Knowledge about Nutrition',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Poor', child: Text('Poor')),
            DropdownMenuItem(value: 'Good', child: Text('Good')),
            DropdownMenuItem(value: 'Excellent', child: Text('Excellent')),
          ],
          onChanged: (value) {
            setState(() {
              widget.survey.nutritionKnowledge = value;
            });
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'Health Service Utilization',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        ...['Private hospital', 'Govt hospital', 'CHC', 'PHC', 'local doctors']
            .map((item) => CheckboxListTile(
                  title: Text(item),
                  value: widget.survey.healthServiceUtilization.contains(item),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        if (!widget.survey.healthServiceUtilization.contains(item)) {
                          widget.survey.healthServiceUtilization.add(item);
                        }
                      } else {
                        widget.survey.healthServiceUtilization.remove(item);
                      }
                    });
                  },
                )),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: widget.survey.communityLeaders,
          decoration: const InputDecoration(
            labelText: 'Community Leaders',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            widget.survey.communityLeaders = value;
          },
        ),
      ],
    );
  }

  Widget _buildHealthConditionCard(
    String title,
    List<HealthCondition> conditions,
    Function(List<HealthCondition>) onUpdate,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => _showHealthConditionDialog(context, title, conditions, onUpdate),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            if (conditions.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No cases recorded', style: TextStyle(color: Colors.grey)),
              )
            else
              ...conditions.asMap().entries.map((entry) {
                final index = entry.key;
                final condition = entry.value;
                return ListTile(
                  dense: true,
                  title: Text('${condition.name} (${condition.age}y)'),
                  subtitle: Text(condition.disease),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        conditions.removeAt(index);
                        onUpdate(conditions);
                      });
                    },
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  void _showHealthConditionDialog(
    BuildContext context,
    String title,
    List<HealthCondition> conditions,
    Function(List<HealthCondition>) onUpdate,
  ) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final diseaseController = TextEditingController();
    final treatmentController = TextEditingController();
    final remarksController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add $title'),
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
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: diseaseController,
                decoration: const InputDecoration(
                  labelText: 'Disease',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: treatmentController,
                decoration: const InputDecoration(
                  labelText: 'Treatment',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: remarksController,
                decoration: const InputDecoration(
                  labelText: 'Remarks',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
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
                  ageController.text.isNotEmpty &&
                  diseaseController.text.isNotEmpty) {
                final condition = HealthCondition(
                  name: nameController.text,
                  age: int.parse(ageController.text),
                  disease: diseaseController.text,
                  treatment: treatmentController.text,
                  remarks: remarksController.text,
                );

                setState(() {
                  conditions.add(condition);
                  onUpdate(conditions);
                });

                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

