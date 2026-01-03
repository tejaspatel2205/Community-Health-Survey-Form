import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/survey_model.dart';

class EnvironmentalSection extends StatefulWidget {
  final SurveyModel survey;

  const EnvironmentalSection({super.key, required this.survey});

  @override
  State<EnvironmentalSection> createState() => _EnvironmentalSectionState();
}

class _EnvironmentalSectionState extends State<EnvironmentalSection> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Environmental Health',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildYesNoQuestion(
          'Is sewage water being disposed of hygienically?',
          widget.survey.sewageDisposalHygienic,
          (value) => widget.survey.sewageDisposalHygienic = value,
          widget.survey.sewageDisposalReason,
          (value) => widget.survey.sewageDisposalReason = value,
        ),
        const SizedBox(height: 16),
        _buildYesNoQuestion(
          'Is waste being disposed of hygienically?',
          widget.survey.wasteDisposalHygienic,
          (value) => widget.survey.wasteDisposalHygienic = value,
          widget.survey.wasteDisposalReason,
          (value) => widget.survey.wasteDisposalReason = value,
        ),
        if (widget.survey.wasteDisposalHygienic == true) ...[
          const SizedBox(height: 8),
          const Text('Waste Disposal Methods:'),
          ...['Composting', 'Burning', 'Burying', 'Dumping'].map((method) =>
              CheckboxListTile(
                title: Text(method),
                value: widget.survey.wasteDisposalMethods.contains(method),
                onChanged: (checked) {
                  setState(() {
                    if (checked == true) {
                      if (!widget.survey.wasteDisposalMethods.contains(method)) {
                        widget.survey.wasteDisposalMethods.add(method);
                      }
                    } else {
                      widget.survey.wasteDisposalMethods.remove(method);
                    }
                  });
                },
              )),
        ],
        const SizedBox(height: 16),
        _buildYesNoQuestion(
          'Is excreta being disposed of hygienically?',
          widget.survey.excretaDisposalHygienic,
          (value) => widget.survey.excretaDisposalHygienic = value,
          widget.survey.excretaDisposalReason,
          (value) => widget.survey.excretaDisposalReason = value,
        ),
        const SizedBox(height: 16),
        _buildYesNoQuestion(
          'Are cattle and poultry housed hygienically?',
          widget.survey.cattlePoultryHygienic,
          (value) => widget.survey.cattlePoultryHygienic = value,
          widget.survey.cattleHousingReason,
          (value) => widget.survey.cattleHousingReason = value,
        ),
        if (widget.survey.cattlePoultryHygienic == true) ...[
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: widget.survey.cattleHousing,
            decoration: const InputDecoration(
              labelText: 'How are they housed?',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'separate', child: Text('Separate')),
              DropdownMenuItem(value: 'within house', child: Text('Within House')),
            ],
            onChanged: (value) {
              setState(() {
                widget.survey.cattleHousing = value;
              });
            },
          ),
        ],
        const SizedBox(height: 16),
        _buildYesNoQuestion(
          'Is there a well or hand pump?',
          widget.survey.wellOrHandPump,
          (value) => widget.survey.wellOrHandPump = value,
          null,
          null,
        ),
        if (widget.survey.wellOrHandPump == true) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Is it maintained in good condition? '),
              DropdownButton<bool>(
                value: widget.survey.wellMaintained,
                items: const [
                  DropdownMenuItem(value: true, child: Text('Yes')),
                  DropdownMenuItem(value: false, child: Text('No')),
                ],
                onChanged: (value) {
                  setState(() {
                    widget.survey.wellMaintained = value;
                  });
                },
              ),
            ],
          ),
          if (widget.survey.wellMaintained == false) ...[
            const SizedBox(height: 8),
            TextFormField(
              initialValue: widget.survey.wellMaintenanceReason,
              decoration: const InputDecoration(
                labelText: 'Reason',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                widget.survey.wellMaintenanceReason = value;
              },
            ),
          ],
          const SizedBox(height: 8),
          ListTile(
            title: Text(
              widget.survey.lastChlorinationDate != null
                  ? 'Last Chlorination: ${DateFormat('yyyy-MM-dd').format(widget.survey.lastChlorinationDate!)}'
                  : 'Last Chlorination Date',
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: widget.survey.lastChlorinationDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                setState(() {
                  widget.survey.lastChlorinationDate = date;
                });
              }
            },
          ),
          if (widget.survey.lastChlorinationDate == null) ...[
            TextFormField(
              initialValue: widget.survey.chlorinationReason,
              decoration: const InputDecoration(
                labelText: 'If not chlorinated, state reason',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                widget.survey.chlorinationReason = value;
              },
            ),
          ],
        ],
        const SizedBox(height: 16),
        _buildYesNoQuestion(
          'Is house kept clean?',
          widget.survey.houseKeptClean,
          (value) => widget.survey.houseKeptClean = value,
          widget.survey.houseCleanReason,
          (value) => widget.survey.houseCleanReason = value,
        ),
        const SizedBox(height: 16),
        ListTile(
          title: Text(
            widget.survey.lastSprayDate != null
                ? 'Last Spray Date: ${DateFormat('yyyy-MM-dd').format(widget.survey.lastSprayDate!)}'
                : 'Last Spray Date',
          ),
          subtitle: widget.survey.lastSprayDate == null
              ? TextFormField(
                  initialValue: widget.survey.sprayReason,
                  decoration: const InputDecoration(
                    labelText: 'If no, state reason',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.survey.sprayReason = value;
                  },
                )
              : null,
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: widget.survey.lastSprayDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              setState(() {
                widget.survey.lastSprayDate = date;
                widget.survey.sprayReason = null;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('Is there any breeding place of insects and rodents? '),
            DropdownButton<bool>(
              value: widget.survey.breedingPlaceInsects,
              items: const [
                DropdownMenuItem(value: true, child: Text('Yes')),
                DropdownMenuItem(value: false, child: Text('No')),
              ],
              onChanged: (value) {
                setState(() {
                  widget.survey.breedingPlaceInsects = value;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('Are there any stray dogs in the vicinity? '),
            DropdownButton<bool>(
              value: widget.survey.strayDogs,
              items: const [
                DropdownMenuItem(value: true, child: Text('Yes')),
                DropdownMenuItem(value: false, child: Text('No')),
              ],
              onChanged: (value) {
                setState(() {
                  widget.survey.strayDogs = value;
                });
              },
            ),
          ],
        ),
        if (widget.survey.strayDogs == true) ...[
          const SizedBox(height: 8),
          TextFormField(
            initialValue: widget.survey.numberOfStrayDogs?.toString(),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Approximate number of dogs',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              widget.survey.numberOfStrayDogs = int.tryParse(value);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildYesNoQuestion(
    String question,
    bool? value,
    Function(bool?) onChanged,
    String? reason,
    Function(String?)? onReasonChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(question)),
            DropdownButton<bool>(
              value: value,
              items: const [
                DropdownMenuItem(value: true, child: Text('Yes')),
                DropdownMenuItem(value: false, child: Text('No')),
              ],
              onChanged: onChanged,
            ),
          ],
        ),
        if (value == false && onReasonChanged != null) ...[
          const SizedBox(height: 8),
          TextFormField(
            initialValue: reason,
            decoration: const InputDecoration(
              labelText: 'If no, state reasons',
              border: OutlineInputBorder(),
            ),
            onChanged: onReasonChanged,
          ),
        ],
      ],
    );
  }
}

