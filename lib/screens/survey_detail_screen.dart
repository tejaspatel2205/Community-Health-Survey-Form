import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/survey_model.dart';

class SurveyDetailScreen extends StatelessWidget {
  final SurveyModel survey;

  const SurveyDetailScreen({super.key, required this.survey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(survey.areaName ?? 'Survey Details'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBasicInfo(),
            const SizedBox(height: 16),
            _buildHousingInfo(),
            const SizedBox(height: 16),
            _buildFamilyComposition(),
            const SizedBox(height: 16),
            _buildIncomeInfo(),
            const SizedBox(height: 16),
            _buildHealthInfo(),
            const SizedBox(height: 16),
            _buildEnvironmentalInfo(),
            const SizedBox(height: 16),
            _buildFinalAssessment(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Basic Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (survey.studentId != null)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.badge, color: Colors.purple.shade700, size: 20),
                    const SizedBox(width: 8),
                    Text('Student ID: ${survey.studentId}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple.shade700)),
                  ],
                ),
              ),
            _buildDetailRow('Area Name', survey.areaName),
            _buildDetailRow('Area Type', survey.areaType),
            _buildDetailRow('Health Centre', survey.healthCentre),
            _buildDetailRow('Head of Family', survey.headOfFamily),
            _buildDetailRow('Family Type', survey.familyType),
            _buildDetailRow('Religion', survey.religion),
            _buildDetailRow('Sub Caste', survey.subCaste),
            _buildDetailRow('Surveyor Name', survey.surveyorName),
            _buildDetailRow('Survey Date', survey.surveyDate),
          ],
        ),
      ),
    );
  }

  Widget _buildHousingInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Housing Condition', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildDetailRow('House Type', survey.houseType),
            _buildDetailRow('Number of Rooms', survey.numberOfRooms?.toString()),
            _buildDetailRow('Room Adequacy', survey.roomAdequacy),
            _buildDetailRow('Occupancy', survey.occupancy),
            _buildDetailRow('Monthly Rent', survey.monthlyRent?.toString()),
            _buildDetailRow('Ventilation', survey.ventilation),
            _buildDetailRow('Lighting', survey.lighting),
            _buildDetailRow('Water Supply', survey.waterSupply),
            _buildDetailRow('Kitchen', survey.kitchen),
            _buildDetailRow('Drainage', survey.drainage),
            _buildDetailRow('Lavatory', survey.lavatory),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyComposition() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Family Composition (${survey.familyMembers.length} members)', 
                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (survey.familyMembers.isEmpty)
              const Text('No family members recorded', style: TextStyle(color: Colors.grey))
            else
              ...survey.familyMembers.map((member) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                color: Colors.grey.shade50,
                child: ListTile(
                  dense: true,
                  title: Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${member.relationship} • ${member.age}y • ${member.gender}'),
                      Text('Education: ${member.education}'),
                      Text('Occupation: ${member.occupation}'),
                      if (member.income != null) Text('Income: ₹${member.income}'),
                      Text('Health: ${member.healthStatus}'),
                    ],
                  ),
                ),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Income & Communication', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildDetailRow('Total Income Range', survey.totalIncomeRange),
            _buildDetailRow('Socio Economic Class', survey.socioEconomicClass),
            _buildDetailRow('Contact Number', survey.contactNumber),
            _buildDetailRow('Mother Tongue', survey.motherTongue),
            if (survey.transport.isNotEmpty)
              _buildDetailRow('Transport', survey.transport.join(', ')),
            if (survey.communicationMedia.isNotEmpty)
              _buildDetailRow('Communication Media', survey.communicationMedia.join(', ')),
            if (survey.languagesKnown.isNotEmpty)
              _buildDetailRow('Languages Known', survey.languagesKnown.join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Health Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildDetailRow('Health Knowledge', survey.healthKnowledge),
            _buildDetailRow('Nutrition Knowledge', survey.nutritionKnowledge),
            _buildDetailRow('Community Leaders', survey.communityLeaders),
            _buildDetailRow('Treatment Location', survey.treatmentLocation),
            _buildDetailRow('Health Insurance', survey.healthInsurance?.toString()),
            if (survey.healthInsuranceDetails != null)
              _buildDetailRow('Insurance Details', survey.healthInsuranceDetails),
            _buildDetailRow('Medicine Compliance', survey.medicineCompliance),
            _buildDetailRow('Drug Purchase Location', survey.drugPurchaseLocation),
            
            if (survey.feverCases.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Fever Cases:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...survey.feverCases.map((feverCase) => Text('• ${feverCase.name} (${feverCase.age}y): ${feverCase.disease}')),
            ],
            
            if (survey.skinDiseases.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Skin Diseases:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...survey.skinDiseases.map((skinCase) => Text('• ${skinCase.name} (${skinCase.age}y): ${skinCase.disease}')),
            ],
            
            if (survey.coughCases.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Cough Cases:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...survey.coughCases.map((coughCase) => Text('• ${coughCase.name} (${coughCase.age}y): ${coughCase.disease}')),
            ],
            
            if (survey.otherIllnesses.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Other Illnesses:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...survey.otherIllnesses.map((illness) => Text('• ${illness.name} (${illness.age}y): ${illness.disease}')),
            ],
            
            if (survey.pregnantWomen.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Pregnant Women:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...survey.pregnantWomen.map((woman) => Text('• ${woman.name} - ${woman.gravida}')),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEnvironmentalInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Environmental Health', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildDetailRow('Sewage Disposal Hygienic', survey.sewageDisposalHygienic?.toString()),
            if (survey.sewageDisposalReason != null)
              _buildDetailRow('Sewage Disposal Reason', survey.sewageDisposalReason),
            _buildDetailRow('Waste Disposal Hygienic', survey.wasteDisposalHygienic?.toString()),
            if (survey.wasteDisposalMethods.isNotEmpty)
              _buildDetailRow('Waste Disposal Methods', survey.wasteDisposalMethods.join(', ')),
            _buildDetailRow('Excreta Disposal Hygienic', survey.excretaDisposalHygienic?.toString()),
            _buildDetailRow('Cattle/Poultry Hygienic', survey.cattlePoultryHygienic?.toString()),
            _buildDetailRow('House Kept Clean', survey.houseKeptClean?.toString()),
            _buildDetailRow('Breeding Place Insects', survey.breedingPlaceInsects?.toString()),
            _buildDetailRow('Stray Dogs', survey.strayDogs?.toString()),
            if (survey.numberOfStrayDogs != null)
              _buildDetailRow('Number of Stray Dogs', survey.numberOfStrayDogs.toString()),
            if (survey.lastSprayDate != null)
              _buildDetailRow('Last Spray Date', DateFormat('yyyy-MM-dd').format(survey.lastSprayDate!)),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalAssessment() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Family Assessment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            if (survey.familyStrengths.isNotEmpty) ...[
              const Text('Family Strengths:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...survey.familyStrengths.map((strength) => Text('• $strength')),
              const SizedBox(height: 8),
            ],
            
            if (survey.familyWeaknesses.isNotEmpty) ...[
              const Text('Family Weaknesses:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...survey.familyWeaknesses.map((weakness) => Text('• $weakness')),
              const SizedBox(height: 8),
            ],
            
            if (survey.nationalHealthProgrammes.isNotEmpty) ...[
              const Text('National Health Programmes:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...survey.nationalHealthProgrammes.map((programme) => Text('• $programme')),
              const SizedBox(height: 8),
            ],
            
            if (survey.problemsIdentified.isNotEmpty) ...[
              const Text('Problems Identified:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...survey.problemsIdentified.map((problem) => Text('• $problem')),
              const SizedBox(height: 8),
            ],
            
            if (survey.additionalNotes != null)
              _buildDetailRow('Additional Notes', survey.additionalNotes),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}