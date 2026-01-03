import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/survey_model.dart';

class PregnantVitalSection extends StatefulWidget {
  final SurveyModel survey;

  const PregnantVitalSection({super.key, required this.survey});

  @override
  State<PregnantVitalSection> createState() => _PregnantVitalSectionState();
}

class _PregnantVitalSectionState extends State<PregnantVitalSection> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Pregnant Women & Vital Statistics',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        // Section 16: Pregnant Women
        const Text(
          'Pregnant Women',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildPregnantWomenCard(),
        const SizedBox(height: 24),
        // Section 17: Vital Statistics
        const Text(
          'Vital Statistics (Within One Year)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildVitalStatisticsCard(),
      ],
    );
  }

  Widget _buildPregnantWomenCard() {
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
                  'Pregnant Women',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => _showPregnantWomanDialog(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            if (widget.survey.pregnantWomen.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No pregnant women recorded', style: TextStyle(color: Colors.grey)),
              )
            else
              ...widget.survey.pregnantWomen.asMap().entries.map((entry) {
                final index = entry.key;
                final woman = entry.value;
                return ListTile(
                  dense: true,
                  title: Text(woman.name),
                  subtitle: Text(
                    'Gravida: ${woman.gravida} | Registered: ${woman.registered ? "Yes" : "No"} | '
                    'Iron & Folic Acid: ${woman.ironFolicAcid ? "Yes" : "No"} | '
                    'Tetanus Toxoid: ${woman.tetanusToxoid ? "Yes" : "No"}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        widget.survey.pregnantWomen.removeAt(index);
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

  Widget _buildVitalStatisticsCard() {
    return Column(
      children: [
        // Births
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Births',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: () => _showBirthDialog(),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add'),
                    ),
                  ],
                ),
                if (widget.survey.births.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('No births recorded', style: TextStyle(color: Colors.grey)),
                  )
                else
                  ...widget.survey.births.asMap().entries.map((entry) {
                    final index = entry.key;
                    final birth = entry.value;
                    return ListTile(
                      dense: true,
                      title: Text('${DateFormat('yyyy-MM-dd').format(birth.dateOfBirth)} - ${birth.gender}'),
                      subtitle: Text('Parents: ${birth.parents} | ${birth.remarks}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            widget.survey.births.removeAt(index);
                          });
                        },
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Deaths
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Deaths',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: () => _showDeathDialog(),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add'),
                    ),
                  ],
                ),
                if (widget.survey.deaths.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('No deaths recorded', style: TextStyle(color: Colors.grey)),
                  )
                else
                  ...widget.survey.deaths.asMap().entries.map((entry) {
                    final index = entry.key;
                    final death = entry.value;
                    return ListTile(
                      dense: true,
                      title: Text('${DateFormat('yyyy-MM-dd').format(death.dateOfDeath)} - ${death.gender}'),
                      subtitle: Text('Parents: ${death.parents} | ${death.remarks}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            widget.survey.deaths.removeAt(index);
                          });
                        },
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Marriages
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Marriages',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: () => _showMarriageDialog(),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add'),
                    ),
                  ],
                ),
                if (widget.survey.marriages.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('No marriages recorded', style: TextStyle(color: Colors.grey)),
                  )
                else
                  ...widget.survey.marriages.asMap().entries.map((entry) {
                    final index = entry.key;
                    final marriage = entry.value;
                    return ListTile(
                      dense: true,
                      title: Text('${marriage.name} (${marriage.age}y)'),
                      subtitle: Text('${DateFormat('yyyy-MM-dd').format(marriage.dateOfMarriage)} | ${marriage.remarks}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            widget.survey.marriages.removeAt(index);
                          });
                        },
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showPregnantWomanDialog() {
    final nameController = TextEditingController();
    final gravidaController = TextEditingController();
    bool registered = false;
    bool ironFolicAcid = false;
    bool tetanusToxoid = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Pregnant Woman'),
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
                  controller: gravidaController,
                  decoration: const InputDecoration(
                    labelText: 'Gravida',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  title: const Text('Registered'),
                  value: registered,
                  onChanged: (value) => setDialogState(() => registered = value ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Iron and Folic Acid Tablets'),
                  value: ironFolicAcid,
                  onChanged: (value) => setDialogState(() => ironFolicAcid = value ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Tetanus Toxoid'),
                  value: tetanusToxoid,
                  onChanged: (value) => setDialogState(() => tetanusToxoid = value ?? false),
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
                if (nameController.text.isNotEmpty && gravidaController.text.isNotEmpty) {
                  setState(() {
                    widget.survey.pregnantWomen.add(PregnantWoman(
                      name: nameController.text,
                      gravida: gravidaController.text,
                      registered: registered,
                      ironFolicAcid: ironFolicAcid,
                      tetanusToxoid: tetanusToxoid,
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

  void _showBirthDialog() {
    final genderController = TextEditingController();
    final parentsController = TextEditingController();
    final remarksController = TextEditingController();
    DateTime? dateOfBirth;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Birth'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(dateOfBirth != null
                      ? 'Date: ${DateFormat('yyyy-MM-dd').format(dateOfBirth!)}'
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
                TextField(
                  controller: genderController,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: parentsController,
                  decoration: const InputDecoration(
                    labelText: 'Parents',
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
                if (dateOfBirth != null && genderController.text.isNotEmpty) {
                  setState(() {
                    widget.survey.births.add(BirthRecord(
                      dateOfBirth: dateOfBirth!,
                      gender: genderController.text,
                      parents: parentsController.text,
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

  void _showDeathDialog() {
    final genderController = TextEditingController();
    final parentsController = TextEditingController();
    final remarksController = TextEditingController();
    DateTime? dateOfDeath;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Death'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(dateOfDeath != null
                      ? 'Date: ${DateFormat('yyyy-MM-dd').format(dateOfDeath!)}'
                      : 'Select Date of Death'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setDialogState(() => dateOfDeath = date);
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: genderController,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: parentsController,
                  decoration: const InputDecoration(
                    labelText: 'Parents',
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
                if (dateOfDeath != null && genderController.text.isNotEmpty) {
                  setState(() {
                    widget.survey.deaths.add(DeathRecord(
                      dateOfDeath: dateOfDeath!,
                      gender: genderController.text,
                      parents: parentsController.text,
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

  void _showMarriageDialog() {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final remarksController = TextEditingController();
    DateTime? dateOfMarriage;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Marriage'),
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
                ListTile(
                  title: Text(dateOfMarriage != null
                      ? 'Date: ${DateFormat('yyyy-MM-dd').format(dateOfMarriage!)}'
                      : 'Select Date of Marriage'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setDialogState(() => dateOfMarriage = date);
                    }
                  },
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
                    dateOfMarriage != null) {
                  setState(() {
                    widget.survey.marriages.add(MarriageRecord(
                      name: nameController.text,
                      age: int.parse(ageController.text),
                      dateOfMarriage: dateOfMarriage!,
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

