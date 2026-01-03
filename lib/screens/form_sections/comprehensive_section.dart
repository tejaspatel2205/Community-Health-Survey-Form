import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/survey_model.dart';

class ComprehensiveSection extends StatefulWidget {
  final SurveyModel survey;

  const ComprehensiveSection({super.key, required this.survey});

  @override
  State<ComprehensiveSection> createState() => _ComprehensiveSectionState();
}

class _ComprehensiveSectionState extends State<ComprehensiveSection> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Comprehensive Health & Family Assessment',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        // Section 18: Immunization
        _buildImmunizationSection(),
        const SizedBox(height: 24),
        // Section 19: Eligible Couples
        _buildEligibleCouplesSection(),
        const SizedBox(height: 24),
        // Section 20: Malnutrition
        _buildMalnutritionSection(),
        const SizedBox(height: 24),
        // Sections 21-29: Environmental Health
        _buildEnvironmentalSection(),
        const SizedBox(height: 24),
        // Sections 30-32: Health Services
        _buildHealthServicesSection(),
        const SizedBox(height: 24),
        // Sections 35-37: Family Assessment
        _buildFamilyAssessmentSection(),
        const SizedBox(height: 24),
        // Section 38: Medicine
        _buildMedicineSection(),
      ],
    );
  }

  Widget _buildImmunizationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Children Below 5 Years - Immunization',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => _showImmunizationDialog(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            if (widget.survey.immunizationRecords.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No immunization records', style: TextStyle(color: Colors.grey)),
              )
            else
              ...widget.survey.immunizationRecords.asMap().entries.map((entry) {
                final index = entry.key;
                final record = entry.value;
                return ListTile(
                  dense: true,
                  title: Text('${record.childName} - ${DateFormat('yyyy-MM-dd').format(record.dateOfBirth)}'),
                  subtitle: Text('Vaccinations: ${record.vaccinations.entries.where((e) => e.value).map((e) => e.key).join(", ")}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        widget.survey.immunizationRecords.removeAt(index);
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

  Widget _buildEligibleCouplesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Eligible Couples',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => _showEligibleCoupleDialog(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            if (widget.survey.eligibleCouples.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No eligible couples recorded', style: TextStyle(color: Colors.grey)),
              )
            else
              ...widget.survey.eligibleCouples.asMap().entries.map((entry) {
                final index = entry.key;
                final couple = entry.value;
                return ListTile(
                  dense: true,
                  title: Text('${couple.name} (${couple.age}y, ${couple.gender}) - Priority: ${couple.priority}'),
                  subtitle: Text(
                    couple.usingContraceptive
                        ? 'Using: ${couple.contraceptiveMethod}'
                        : couple.notInterested
                            ? 'Not interested: ${couple.notInterestedReason}'
                            : 'Intending: ${couple.intendingVasectomy ? "Vasectomy" : ""} ${couple.intendingTubalLigation ? "Tubal Ligation" : ""}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        widget.survey.eligibleCouples.removeAt(index);
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

  Widget _buildMalnutritionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Children 0-5 Years - Malnutrition',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => _showMalnutritionDialog(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            if (widget.survey.malnutritionRecords.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No malnutrition cases recorded', style: TextStyle(color: Colors.grey)),
              )
            else
              ...widget.survey.malnutritionRecords.asMap().entries.map((entry) {
                final index = entry.key;
                final record = entry.value;
                final conditions = <String>[];
                if (record.kwashiorkor) conditions.add('Kwashiorkor');
                if (record.marasmus) conditions.add('Marasmus');
                if (record.vitaminADeficiency) conditions.add('Vitamin A Deficiency');
                if (record.anemia) conditions.add('Anemia');
                if (record.rickets) conditions.add('Rickets');
                return ListTile(
                  dense: true,
                  title: Text('${record.name} (${record.age}y)'),
                  subtitle: Text('${conditions.join(", ")} | ${record.remarks}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        widget.survey.malnutritionRecords.removeAt(index);
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

  Widget _buildEnvironmentalSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Environmental Health',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              (value) {
                setState(() {
                  widget.survey.wasteDisposalHygienic = value;
                  if (value == false) {
                    widget.survey.wasteDisposalMethods.clear();
                  }
                });
              },
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
                  const Expanded(child: Text('25.1 Is it maintained in good condition?')),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 100,
                    child: DropdownButtonFormField<bool>(
                      value: widget.survey.wellMaintained,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      hint: const Text('Select'),
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
                const Expanded(
                  child: Text('Is there any breeding place of insects and rodents?'),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: DropdownButtonFormField<bool>(
                    value: widget.survey.breedingPlaceInsects,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    hint: const Text('Select'),
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
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Text('Are there any stray dogs in the vicinity?'),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: DropdownButtonFormField<bool>(
                    value: widget.survey.strayDogs,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    hint: const Text('Select'),
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
        ),
      ),
    );
  }

  Widget _buildHealthServicesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Health Services',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: widget.survey.treatmentLocation,
              decoration: const InputDecoration(
                labelText: 'If any one falls ill, where do they go for treatment?',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Hospital / Community Health Centre', child: Text('Hospital / Community Health Centre')),
                DropdownMenuItem(value: 'Primary Health Centre/ Sub Health Centre', child: Text('Primary Health Centre/ Sub Health Centre')),
                DropdownMenuItem(value: 'Private Nursing Home', child: Text('Private Nursing Home')),
                DropdownMenuItem(value: 'Indigenous Doctor/ Local vaidya / Homeopathy / Ayurvedic', child: Text('Indigenous Doctor/ Local vaidya / Homeopathy / Ayurvedic')),
              ],
              onChanged: (value) {
                setState(() {
                  widget.survey.treatmentLocation = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Text('Is official health agencies service adequate?'),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: DropdownButtonFormField<bool>(
                    value: widget.survey.officialHealthAgenciesAdequate,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    hint: const Text('Select'),
                    items: const [
                      DropdownMenuItem(value: true, child: Text('Yes')),
                      DropdownMenuItem(value: false, child: Text('No')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        widget.survey.officialHealthAgenciesAdequate = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (widget.survey.officialHealthAgenciesAdequate == false) ...[
              const SizedBox(height: 8),
              TextFormField(
                initialValue: widget.survey.healthAgenciesReason,
                decoration: const InputDecoration(
                  labelText: 'If no, state reasons',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  widget.survey.healthAgenciesReason = value;
                },
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Health Insurance: '),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: DropdownButtonFormField<bool>(
                    value: widget.survey.healthInsurance,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    hint: const Text('Select'),
                    items: const [
                      DropdownMenuItem(value: true, child: Text('Yes')),
                      DropdownMenuItem(value: false, child: Text('No')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        widget.survey.healthInsurance = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (widget.survey.healthInsurance == true) ...[
              const SizedBox(height: 8),
              TextFormField(
                initialValue: widget.survey.healthInsuranceDetails,
                decoration: const InputDecoration(
                  labelText: 'Specify',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  widget.survey.healthInsuranceDetails = value;
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyAssessmentSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Family Assessment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Strengths
            const Text(
              'Strength of the family',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildAddableList(
              widget.survey.familyStrengths,
              'Add Strength',
              (item) => widget.survey.familyStrengths.add(item),
              (item) => widget.survey.familyStrengths.remove(item),
            ),
            const SizedBox(height: 16),
            // Weaknesses
            const Text(
              'Weakness of the family',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildAddableList(
              widget.survey.familyWeaknesses,
              'Add Weakness',
              (item) => widget.survey.familyWeaknesses.add(item),
              (item) => widget.survey.familyWeaknesses.remove(item),
            ),
            const SizedBox(height: 16),
            // National Health Programmes
            const Text(
              'National health programme applicable to the family',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildAddableList(
              widget.survey.nationalHealthProgrammes,
              'Add Programme',
              (item) => widget.survey.nationalHealthProgrammes.add(item),
              (item) => widget.survey.nationalHealthProgrammes.remove(item),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Medicine',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.survey.drugPurchaseLocation,
              decoration: const InputDecoration(
                labelText: 'Where do they go to purchase the prescribed drug?',
                border: OutlineInputBorder(),
                hintText: 'e.g., PHC',
              ),
              onChanged: (value) {
                widget.survey.drugPurchaseLocation = value;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: widget.survey.medicineCompliance,
              decoration: const InputDecoration(
                labelText: 'Compliance to medicine',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Complete', child: Text('Complete')),
                DropdownMenuItem(value: 'Partial/ Few dose', child: Text('Partial/ Few dose')),
                DropdownMenuItem(value: 'Unfinished', child: Text('Unfinished')),
              ],
              onChanged: (value) {
                setState(() {
                  widget.survey.medicineCompliance = value;
                });
              },
            ),
          ],
        ),
      ),
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
            const SizedBox(width: 8),
            SizedBox(
              width: 100,
              child: DropdownButtonFormField<bool>(
                value: value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                hint: const Text('Select'),
                items: const [
                  DropdownMenuItem(value: true, child: Text('Yes')),
                  DropdownMenuItem(value: false, child: Text('No')),
                ],
                onChanged: onChanged,
              ),
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

  void _showImmunizationDialog() {
    final nameController = TextEditingController();
    DateTime? dateOfBirth;
    final Map<String, bool> vaccinations = {
      'BCG': false,
      'OPV 0': false,
      'OPV 1': false,
      'OPV 2': false,
      'OPV 3': false,
      'OPV Booster': false,
      'Pentavalent 1': false,
      'Pentavalent 2': false,
      'Pentavalent 3': false,
      'Pentavalent Booster': false,
      'Measles & Rubella': false,
    };

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Immunization Record'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Child Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  title: Text(dateOfBirth != null
                      ? 'Date of Birth: ${DateFormat('yyyy-MM-dd').format(dateOfBirth!)}'
                      : 'Select Date of Birth'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setDialogState(() => dateOfBirth = date);
                    }
                  },
                ),
                const SizedBox(height: 8),
                const Text('Vaccinations:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...vaccinations.keys.map((vaccine) => CheckboxListTile(
                      title: Text(vaccine),
                      value: vaccinations[vaccine],
                      onChanged: (checked) {
                        setDialogState(() {
                          vaccinations[vaccine] = checked ?? false;
                        });
                      },
                    )),
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
                if (nameController.text.isNotEmpty && dateOfBirth != null) {
                  setState(() {
                    widget.survey.immunizationRecords.add(ImmunizationRecord(
                      childName: nameController.text,
                      dateOfBirth: dateOfBirth!,
                      vaccinations: vaccinations,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEligibleCoupleDialog() {
    final husbandNameController = TextEditingController();
    final husbandAgeController = TextEditingController();
    final wifeNameController = TextEditingController();
    final wifeAgeController = TextEditingController();
    String? priority;
    final contraceptiveController = TextEditingController();
    bool usingContraceptive = false;
    bool intendingVasectomy = false;
    bool intendingTubalLigation = false;
    bool notInterested = false;
    final notInterestedController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Eligible Couple'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Husband Details:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: husbandNameController,
                  decoration: const InputDecoration(
                    labelText: 'Husband Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: husbandAgeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Husband Age',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Wife Details:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: wifeNameController,
                  decoration: const InputDecoration(
                    labelText: 'Wife Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: wifeAgeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Wife Age',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: priority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'I Priority', child: Text('I Priority')),
                    DropdownMenuItem(value: 'II Priority', child: Text('II Priority')),
                  ],
                  onChanged: (value) => setDialogState(() => priority = value),
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  title: const Text('Using contraceptive method'),
                  value: usingContraceptive,
                  onChanged: (value) => setDialogState(() => usingContraceptive = value ?? false),
                ),
                if (usingContraceptive) ...[
                  TextField(
                    controller: contraceptiveController,
                    decoration: const InputDecoration(
                      labelText: 'Specify method',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                CheckboxListTile(
                  title: const Text('Intending to undergo Vasectomy'),
                  value: intendingVasectomy,
                  onChanged: (value) => setDialogState(() => intendingVasectomy = value ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Intending to undergo Tubal Ligation'),
                  value: intendingTubalLigation,
                  onChanged: (value) => setDialogState(() => intendingTubalLigation = value ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Not interested to adopt F.P. Method'),
                  value: notInterested,
                  onChanged: (value) => setDialogState(() => notInterested = value ?? false),
                ),
                if (notInterested) ...[
                  TextField(
                    controller: notInterestedController,
                    decoration: const InputDecoration(
                      labelText: 'State the reason',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
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
                if (husbandNameController.text.isNotEmpty &&
                    husbandAgeController.text.isNotEmpty &&
                    wifeNameController.text.isNotEmpty &&
                    wifeAgeController.text.isNotEmpty &&
                    priority != null) {
                  setState(() {
                    widget.survey.eligibleCouples.add(EligibleCouple(
                      name: '${husbandNameController.text} & ${wifeNameController.text}',
                      age: int.parse(husbandAgeController.text),
                      gender: 'Couple',
                      priority: priority!,
                      remarks: 'Wife Age: ${wifeAgeController.text}',
                      usingContraceptive: usingContraceptive,
                      contraceptiveMethod: contraceptiveController.text,
                      intendingVasectomy: intendingVasectomy,
                      intendingTubalLigation: intendingTubalLigation,
                      notInterested: notInterested,
                      notInterestedReason: notInterestedController.text,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMalnutritionDialog() {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final remarksController = TextEditingController();
    bool kwashiorkor = false;
    bool marasmus = false;
    bool vitaminADeficiency = false;
    bool anemia = false;
    bool rickets = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Malnutrition Record'),
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
                const Text('Conditions:', style: TextStyle(fontWeight: FontWeight.bold)),
                CheckboxListTile(
                  title: const Text('Kwashiorkor'),
                  value: kwashiorkor,
                  onChanged: (value) => setDialogState(() => kwashiorkor = value ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Marasmus'),
                  value: marasmus,
                  onChanged: (value) => setDialogState(() => marasmus = value ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Vitamin A Deficiency'),
                  value: vitaminADeficiency,
                  onChanged: (value) => setDialogState(() => vitaminADeficiency = value ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Anemia'),
                  value: anemia,
                  onChanged: (value) => setDialogState(() => anemia = value ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Rickets'),
                  value: rickets,
                  onChanged: (value) => setDialogState(() => rickets = value ?? false),
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
                if (nameController.text.isNotEmpty && ageController.text.isNotEmpty) {
                  final age = int.tryParse(ageController.text);
                  if (age == null || age < 0 || age > 5) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Age must be between 0-5 years for malnutrition records'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  setState(() {
                    widget.survey.malnutritionRecords.add(MalnutritionRecord(
                      name: nameController.text,
                      age: age,
                      kwashiorkor: kwashiorkor,
                      marasmus: marasmus,
                      vitaminADeficiency: vitaminADeficiency,
                      anemia: anemia,
                      rickets: rickets,
                      remarks: remarksController.text,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

