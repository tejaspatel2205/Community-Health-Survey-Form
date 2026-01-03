import 'package:flutter/material.dart';
import '../../models/survey_model.dart';

class FinalSection extends StatefulWidget {
  final SurveyModel survey;

  const FinalSection({super.key, required this.survey});

  @override
  State<FinalSection> createState() => _FinalSectionState();
}

class _FinalSectionState extends State<FinalSection> {
  final _additionalNotesController = TextEditingController();
  final _problemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _additionalNotesController.text = widget.survey.additionalNotes ?? '';
  }

  @override
  void dispose() {
    _additionalNotesController.dispose();
    _problemController.dispose();
    super.dispose();
  }

  void _saveData() {
    widget.survey.additionalNotes = _additionalNotesController.text;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Final Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          'Family Strengths',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildAddableList(
          widget.survey.familyStrengths,
          'Add Strength',
          (item) => widget.survey.familyStrengths.add(item),
          (item) => widget.survey.familyStrengths.remove(item),
        ),
        const SizedBox(height: 24),
        const Text(
          'Family Weaknesses',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildAddableList(
          widget.survey.familyWeaknesses,
          'Add Weakness',
          (item) => widget.survey.familyWeaknesses.add(item),
          (item) => widget.survey.familyWeaknesses.remove(item),
        ),
        const SizedBox(height: 24),
        const Text(
          'National Health Programmes',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: widget.survey.nationalHealthProgrammes.join(', '),
          decoration: const InputDecoration(
            labelText: 'National Health Programmes Applicable',
            border: OutlineInputBorder(),
            hintText: 'e.g., National vector borne disease control programme',
          ),
          maxLines: 3,
          onChanged: (value) {
            widget.survey.nationalHealthProgrammes = value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Problems Identified',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _problemController,
                decoration: const InputDecoration(
                  labelText: 'Add Problem',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (_problemController.text.isNotEmpty) {
                  setState(() {
                    widget.survey.problemsIdentified.add(_problemController.text);
                    _problemController.clear();
                  });
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (widget.survey.problemsIdentified.isEmpty)
          const Text('No problems identified', style: TextStyle(color: Colors.grey))
        else
          ...widget.survey.problemsIdentified.map((problem) => Card(
                margin: const EdgeInsets.only(bottom: 4),
                child: ListTile(
                  title: Text(problem),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        widget.survey.problemsIdentified.remove(problem);
                      });
                    },
                  ),
                ),
              )),
        const SizedBox(height: 24),
        TextFormField(
          controller: _additionalNotesController,
          decoration: const InputDecoration(
            labelText: 'Additional Notes',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 24),
        const Card(
          color: Colors.blue,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Review Your Survey',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Please review all sections before saving. You can go back to previous sections using the "Previous" button.',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddableList(
    List<String> items,
    String addLabel,
    Function(String) onAdd,
    Function(String) onRemove,
  ) {
    final controller = TextEditingController();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: addLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    onAdd(controller.text);
                    controller.clear();
                  });
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          const Text('No items added', style: TextStyle(color: Colors.grey))
        else
          ...items.map((item) => Card(
                margin: const EdgeInsets.only(bottom: 4),
                child: ListTile(
                  title: Text(item),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        onRemove(item);
                      });
                    },
                  ),
                ),
              )),
      ],
    );
  }
}

