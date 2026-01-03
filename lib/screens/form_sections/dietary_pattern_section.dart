import 'package:flutter/material.dart';
import '../../models/survey_model.dart';

class DietaryPatternSection extends StatefulWidget {
  final SurveyModel survey;

  const DietaryPatternSection({super.key, required this.survey});

  @override
  State<DietaryPatternSection> createState() => _DietaryPatternSectionState();
}

class _DietaryPatternSectionState extends State<DietaryPatternSection> {
  final List<String> _foodItems = [
    'Rice',
    'Bajra',
    'Jowar',
    'Wheat',
    'Vegetables',
    'Fish',
    'Meat',
    'Egg',
    'Milk & Milk Products',
    'Pulses',
    'Tubers',
  ];

  final List<String> _preparationOptions = ['Traditional', 'Ideal', 'Unhygienic'];

  @override
  void initState() {
    super.initState();
    // Initialize dietary pattern for all food items if not already present
    for (var food in _foodItems) {
      if (!widget.survey.dietaryPattern.containsKey(food)) {
        widget.survey.dietaryPattern[food] = DietaryInfo(
          available: false,
          used: false,
          preparation: '',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Dietary Pattern',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          'Food Available (Fixed)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ..._foodItems.map((food) => _buildFoodItemCard(food)),
      ],
    );
  }

  Widget _buildFoodItemCard(String food) {
    final dietaryInfo = widget.survey.dietaryPattern[food] ?? DietaryInfo(
      available: false,
      used: false,
      preparation: '',
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              food,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Food Used checkbox
            CheckboxListTile(
              title: const Text('Food Used'),
              value: dietaryInfo.used,
              onChanged: (checked) {
                setState(() {
                  widget.survey.dietaryPattern[food] = DietaryInfo(
                    available: true,
                    used: checked ?? false,
                    preparation: dietaryInfo.preparation,
                  );
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
            // Food Preparation and Storage
            if (dietaryInfo.used) ...[
              const SizedBox(height: 8),
              const Text(
                'Food Preparation and Storage:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              ..._preparationOptions.map((option) => RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: dietaryInfo.preparation.isNotEmpty ? dietaryInfo.preparation : null,
                    onChanged: (value) {
                      setState(() {
                        widget.survey.dietaryPattern[food] = DietaryInfo(
                          available: true,
                          used: true,
                          preparation: value ?? '',
                        );
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  )),
            ],
          ],
        ),
      ),
    );
  }
}

