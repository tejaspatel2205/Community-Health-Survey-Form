import 'package:flutter/material.dart';
import '../../models/survey_model.dart';

class BasicInfoSection extends StatefulWidget {
  final SurveyModel survey;

  const BasicInfoSection({super.key, required this.survey});

  @override
  State<BasicInfoSection> createState() => _BasicInfoSectionState();
}

class _BasicInfoSectionState extends State<BasicInfoSection> {
  final _formKey = GlobalKey<FormState>();
  final _areaNameController = TextEditingController();
  final _healthCentreController = TextEditingController();
  final _headOfFamilyController = TextEditingController();
  final _subCasteController = TextEditingController();
  final _surveyorNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _areaNameController.text = widget.survey.areaName ?? '';
    _healthCentreController.text = widget.survey.healthCentre ?? '';
    _headOfFamilyController.text = widget.survey.headOfFamily ?? '';
    _subCasteController.text = widget.survey.subCaste ?? '';
    _surveyorNameController.text = widget.survey.surveyorName ?? '';
  }

  @override
  void dispose() {
    _areaNameController.dispose();
    _healthCentreController.dispose();
    _headOfFamilyController.dispose();
    _subCasteController.dispose();
    _surveyorNameController.dispose();
    super.dispose();
  }

  void _saveData() {
    widget.survey.areaName = _areaNameController.text;
    widget.survey.healthCentre = _healthCentreController.text;
    widget.survey.headOfFamily = _headOfFamilyController.text;
    widget.survey.subCaste = _subCasteController.text;
    widget.survey.surveyorName = _surveyorNameController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _areaNameController,
            decoration: const InputDecoration(
              labelText: 'Name of the area',
              border: OutlineInputBorder(),
              hintText: 'e.g., Bhumana Vista',
            ),
            onChanged: (_) => _saveData(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter area name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: widget.survey.areaType,
            decoration: const InputDecoration(
              labelText: 'Area Type',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Rural', child: Text('Rural')),
              DropdownMenuItem(value: 'Urban', child: Text('Urban')),
            ],
            onChanged: (value) {
              setState(() {
                widget.survey.areaType = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select area type';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _healthCentreController,
            decoration: const InputDecoration(
              labelText: 'Name of the Health Centre',
              border: OutlineInputBorder(),
              hintText: 'e.g., Sihal PHC',
            ),
            onChanged: (_) => _saveData(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter health centre name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _headOfFamilyController,
            decoration: const InputDecoration(
              labelText: 'Name of the Head of the Family',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _saveData(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter head of family name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: widget.survey.familyType,
            decoration: const InputDecoration(
              labelText: 'Type of Family',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Nuclear', child: Text('Nuclear')),
              DropdownMenuItem(value: 'Joint', child: Text('Joint')),
              DropdownMenuItem(value: 'Single', child: Text('Single')),
            ],
            onChanged: (value) {
              setState(() {
                widget.survey.familyType = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select family type';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: widget.survey.religion,
            decoration: const InputDecoration(
              labelText: 'Religion',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Hindu', child: Text('Hindu')),
              DropdownMenuItem(value: 'Muslim', child: Text('Muslim')),
              DropdownMenuItem(value: 'Christian', child: Text('Christian')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (value) {
              setState(() {
                widget.survey.religion = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select religion';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _subCasteController,
            decoration: const InputDecoration(
              labelText: 'Sub Caste (Specify)',
              border: OutlineInputBorder(),
              hintText: 'e.g., Vauhas',
            ),
            onChanged: (_) => _saveData(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _surveyorNameController,
            decoration: const InputDecoration(
              labelText: 'Surveyor Name',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _saveData(),
          ),
        ],
      ),
    );
  }
}

