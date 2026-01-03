import 'package:flutter/material.dart';
import '../../models/survey_model.dart';

class HousingSection extends StatefulWidget {
  final SurveyModel survey;

  const HousingSection({super.key, required this.survey});

  @override
  State<HousingSection> createState() => _HousingSectionState();
}

class _HousingSectionState extends State<HousingSection> {
  final _roomsController = TextEditingController();
  final _rentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _roomsController.text = widget.survey.numberOfRooms?.toString() ?? '';
    _rentController.text = widget.survey.monthlyRent?.toString() ?? '';
  }

  @override
  void dispose() {
    _roomsController.dispose();
    _rentController.dispose();
    super.dispose();
  }

  void _saveData() {
    widget.survey.numberOfRooms = int.tryParse(_roomsController.text);
    widget.survey.monthlyRent = double.tryParse(_rentController.text);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Housing Condition',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: widget.survey.houseType,
          decoration: const InputDecoration(
            labelText: 'Type of House',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Pucca', child: Text('Pucca')),
            DropdownMenuItem(value: 'Semi pucca', child: Text('Semi pucca')),
            DropdownMenuItem(value: 'Kutcha', child: Text('Kutcha')),
          ],
          onChanged: (value) {
            setState(() {
              widget.survey.houseType = value;
            });
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _roomsController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Number of Rooms',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: widget.survey.roomAdequacy,
          decoration: const InputDecoration(
            labelText: 'Room Adequacy',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Adequate', child: Text('Adequate')),
            DropdownMenuItem(value: 'Inadequate', child: Text('Inadequate')),
          ],
          onChanged: (value) {
            setState(() {
              widget.survey.roomAdequacy = value;
            });
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: widget.survey.occupancy,
          decoration: const InputDecoration(
            labelText: 'Occupancy',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Tenant', child: Text('Tenant')),
            DropdownMenuItem(value: 'Owner', child: Text('Owner')),
          ],
          onChanged: (value) {
            setState(() {
              widget.survey.occupancy = value;
              if (value == 'Owner') {
                _rentController.clear();
                widget.survey.monthlyRent = null;
              }
            });
          },
        ),
        if (widget.survey.occupancy == 'Tenant') ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: _rentController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Monthly Rent (₹)',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _saveData(),
          ),
        ],
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: widget.survey.ventilation,
          decoration: const InputDecoration(
            labelText: 'Ventilation',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Adequate', child: Text('Adequate')),
            DropdownMenuItem(value: 'Inadequate', child: Text('Inadequate')),
            DropdownMenuItem(value: 'No Ventilation', child: Text('No Ventilation')),
          ],
          onChanged: (value) {
            setState(() {
              widget.survey.ventilation = value;
            });
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: widget.survey.lighting,
          decoration: const InputDecoration(
            labelText: 'Lighting',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Electricity', child: Text('Electricity')),
            DropdownMenuItem(value: 'Gas lamp', child: Text('Gas lamp')),
            DropdownMenuItem(value: 'Oil lamp', child: Text('Oil lamp')),
          ],
          onChanged: (value) {
            setState(() {
              widget.survey.lighting = value;
            });
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: widget.survey.waterSupply,
          decoration: const InputDecoration(
            labelText: 'Water Supply',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Tap / Hand pump', child: Text('Tap / Hand pump')),
            DropdownMenuItem(value: 'Well', child: Text('Well')),
            DropdownMenuItem(value: 'Open Tank', child: Text('Open Tank')),
            DropdownMenuItem(value: 'Others', child: Text('Others')),
          ],
          onChanged: (value) {
            setState(() {
              widget.survey.waterSupply = value;
            });
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: widget.survey.kitchen,
          decoration: const InputDecoration(
            labelText: 'Kitchen',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Separate', child: Text('Separate')),
            DropdownMenuItem(value: 'Corner of the room', child: Text('Corner of the room')),
            DropdownMenuItem(value: 'Veranda', child: Text('Veranda')),
          ],
          onChanged: (value) {
            setState(() {
              widget.survey.kitchen = value;
            });
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: widget.survey.drainage,
          decoration: const InputDecoration(
            labelText: 'Drainage',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Adequate', child: Text('Adequate')),
            DropdownMenuItem(value: 'Inadequate', child: Text('Inadequate')),
            DropdownMenuItem(value: 'No Drainage', child: Text('No Drainage')),
          ],
          onChanged: (value) {
            setState(() {
              widget.survey.drainage = value;
            });
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: widget.survey.lavatory,
          decoration: const InputDecoration(
            labelText: 'Lavatory',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Own Latrine', child: Text('Own Latrine')),
            DropdownMenuItem(value: 'Public Latrine', child: Text('Public Latrine')),
            DropdownMenuItem(value: 'Open air defecation', child: Text('Open air defecation')),
          ],
          onChanged: (value) {
            setState(() {
              widget.survey.lavatory = value;
            });
          },
        ),
      ],
    );
  }
}

