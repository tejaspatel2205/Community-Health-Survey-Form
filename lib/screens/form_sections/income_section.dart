import 'package:flutter/material.dart';
import '../../models/survey_model.dart';

class IncomeSection extends StatefulWidget {
  final SurveyModel survey;

  const IncomeSection({super.key, required this.survey});

  @override
  State<IncomeSection> createState() => _IncomeSectionState();
}

class _IncomeSectionState extends State<IncomeSection> {

  final _contactNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _contactNumberController.text = widget.survey.contactNumber ?? '';
  }

  @override
  void dispose() {

    _contactNumberController.dispose();
    super.dispose();
  }

  void _saveData() {

    widget.survey.contactNumber = _contactNumberController.text;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Income & Communication',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: widget.survey.totalIncomeRange,
          decoration: const InputDecoration(
            labelText: 'Total Income of Family/Month (₹)',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Below Rs.1000', child: Text('Below Rs.1000')),
            DropdownMenuItem(value: 'Rs.1000-1500', child: Text('Rs.1000-1500')),
            DropdownMenuItem(value: 'Rs.1501-2000', child: Text('Rs.1501-2000')),
            DropdownMenuItem(value: 'Rs.2001-2500', child: Text('Rs.2001-2500')),
            DropdownMenuItem(value: 'Rs.2501-3000', child: Text('Rs.2501-3000')),
            DropdownMenuItem(value: 'Rs.3001-4000', child: Text('Rs.3001-4000')),
            DropdownMenuItem(value: 'Rs.4001-5000', child: Text('Rs.4001-5000')),
            DropdownMenuItem(value: 'Above Rs.5000', child: Text('Above Rs.5000')),
          ],
          onChanged: (value) {
            setState(() {
              widget.survey.totalIncomeRange = value;
            });
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Expenditure of Family',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildExpenditureSection(),
        const SizedBox(height: 24),
        const Text(
          'Transport',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...['Tractor / Tempo', 'Own Vehicle', 'Uses GTS / GSRTC', 'Private Bus', 'Train']
            .map((item) => CheckboxListTile(
                  title: Text(item),
                  value: widget.survey.transport.contains(item),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        if (!widget.survey.transport.contains(item)) {
                          widget.survey.transport.add(item);
                        }
                      } else {
                        widget.survey.transport.remove(item);
                      }
                    });
                  },
                )),
        const SizedBox(height: 24),
        const Text(
          'Communication Media',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...['Telephone/Mobile', 'Television', 'Radio', 'Newspaper/Magazine', 'Post and Telegraph/Email']
            .map((item) => CheckboxListTile(
                  title: Text(item),
                  value: widget.survey.communicationMedia.contains(item),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        if (!widget.survey.communicationMedia.contains(item)) {
                          widget.survey.communicationMedia.add(item);
                        }
                      } else {
                        widget.survey.communicationMedia.remove(item);
                      }
                    });
                  },
                )),
        const SizedBox(height: 24),
        const Text(
          'Language',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: widget.survey.motherTongue,
          decoration: const InputDecoration(
            labelText: 'Mother Tongue',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Gujarati', child: Text('Gujarati')),
            DropdownMenuItem(value: 'Hindi', child: Text('Hindi')),
            DropdownMenuItem(value: 'English', child: Text('English')),
            DropdownMenuItem(value: 'Other', child: Text('Other')),
          ],
          onChanged: (value) {
            setState(() {
              widget.survey.motherTongue = value;
            });
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'Languages Known',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        ...['Gujarati Read/Write', 'Hindi Read/Write', 'English Read/Write']
            .map((item) => CheckboxListTile(
                  title: Text(item),
                  value: widget.survey.languagesKnown.contains(item),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        if (!widget.survey.languagesKnown.contains(item)) {
                          widget.survey.languagesKnown.add(item);
                        }
                      } else {
                        widget.survey.languagesKnown.remove(item);
                      }
                    });
                  },
                )),
        const SizedBox(height: 24),
        TextFormField(
          controller: _contactNumberController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Contact Number of Head of the Family',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
      ],
    );
  }

  Widget _buildExpenditureSection() {
    final expenditureItems = [
      'Food',
      'Clothing',
      'Fuel and Light',
      'House Rent',
      'Education',
      'Medical',
      'Recreation',
      'Transport',
      'Others'
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fixed Items',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...expenditureItems.map((item) {
              final existingItem = widget.survey.expenditureItems
                  .firstWhere((e) => e.item == item, orElse: () => ExpenditureItem(item: item, amount: 0, percentage: 0));
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(item),
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: existingItem.amount > 0 ? existingItem.amount.toString() : '',
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Amount (₹)',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        ),
                        onChanged: (value) {
                          final amount = double.tryParse(value) ?? 0;
                          _updateExpenditureItem(item, amount);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        initialValue: existingItem.percentage > 0 ? existingItem.percentage.toString() : '',
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: '%',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        ),
                        onChanged: (value) {
                          final percentage = double.tryParse(value) ?? 0;
                          _updateExpenditurePercentage(item, percentage);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _updateExpenditureItem(String item, double amount) {
    final index = widget.survey.expenditureItems.indexWhere((e) => e.item == item);
    if (index >= 0) {
      widget.survey.expenditureItems[index].amount = amount;
    } else {
      widget.survey.expenditureItems.add(ExpenditureItem(item: item, amount: amount, percentage: 0));
    }
  }

  void _updateExpenditurePercentage(String item, double percentage) {
    final index = widget.survey.expenditureItems.indexWhere((e) => e.item == item);
    if (index >= 0) {
      widget.survey.expenditureItems[index].percentage = percentage;
    } else {
      widget.survey.expenditureItems.add(ExpenditureItem(item: item, amount: 0, percentage: percentage));
    }
  }
}

