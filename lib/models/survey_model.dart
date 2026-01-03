class SurveyModel {
  // Section 1-5: Basic Information
  String? areaName;
  String? areaType; // Rural/Urban
  String? healthCentre;
  String? headOfFamily;
  String? familyType; // Nuclear/Joint/Single
  String? religion;
  String? subCaste;

  // Default constructor
  SurveyModel();

  // Section 6: Housing Condition
  String? houseType; // Pucca/Semi pucca/Kutcha
  int? numberOfRooms;
  String? roomAdequacy; // Adequate/Inadequate
  String? occupancy; // Tenant/Owner
  double? monthlyRent;
  String? ventilation; // Adequate/Inadequate/No Ventilation
  String? lighting; // Electricity/Gas lamp/Oil lamp
  String? waterSupply; // Tap/Hand pump/Well/Open Tank/Others
  String? kitchen; // Separate/Corner of the room/Veranda
  String? drainage; // Adequate/Inadequate/No Drainage
  String? lavatory; // Own Latrine/Public Latrine/Open air defecation

  // Section 7: Family Composition
  List<FamilyMember> familyMembers = [];

  // Section 7A-7B: Income
  double? totalIncome;
  String? totalIncomeRange;
  String? socioEconomicClass;

  // Section 8: Transport & Communication
  List<String> transport = []; // Tractor/Tempo/Own Vehicle/GTS/GSRTC/Private Bus/Train
  List<String> communicationMedia = []; // Telephone/Mobile/Television/Radio/Newspaper/Email
  String? motherTongue;
  List<String> languagesKnown = [];

  // Section 9: Dietary Pattern
  Map<String, DietaryInfo> dietaryPattern = {};

  // Section 10: Expenditure
  List<ExpenditureItem> expenditureItems = [];

  // Section 11-14: Health Conditions
  List<HealthCondition> feverCases = [];
  List<HealthCondition> skinDiseases = [];
  List<HealthCondition> coughCases = [];
  List<HealthCondition> otherIllnesses = [];

  // Section 15: Family Health Attitude
  String? healthKnowledge; // poor/good/excellent
  String? nutritionKnowledge; // poor/good/excellent
  List<String> healthServiceUtilization = [];
  String? communityLeaders;

  // Section 16: Pregnant Women
  List<PregnantWoman> pregnantWomen = [];

  // Section 17: Vital Statistics
  List<BirthRecord> births = [];
  List<DeathRecord> deaths = [];
  List<MarriageRecord> marriages = [];

  // Section 18: Immunization
  List<ImmunizationRecord> immunizationRecords = [];

  // Section 19: Eligible Couples
  List<EligibleCouple> eligibleCouples = [];

  // Section 20: Malnutrition
  List<MalnutritionRecord> malnutritionRecords = [];

  // Section 21-29: Environmental Health
  bool? sewageDisposalHygienic;
  String? sewageDisposalReason;
  bool? wasteDisposalHygienic;
  List<String> wasteDisposalMethods = []; // Composting/Burning/Burying/Dumping
  String? wasteDisposalReason;
  bool? excretaDisposalHygienic;
  String? excretaDisposalReason;
  bool? cattlePoultryHygienic;
  String? cattleHousing; // separate/within house
  String? cattleHousingReason;
  bool? wellOrHandPump;
  bool? wellMaintained;
  String? wellMaintenanceReason;
  DateTime? lastChlorinationDate;
  String? chlorinationReason;
  bool? houseKeptClean;
  String? houseCleanReason;
  DateTime? lastSprayDate;
  String? sprayReason;
  bool? breedingPlaceInsects;
  bool? strayDogs;
  int? numberOfStrayDogs;

  // Section 30-32: Health Services
  String? treatmentLocation; // Hospital/CHC/PHC/Private/Indigenous
  bool? officialHealthAgenciesAdequate;
  String? healthAgenciesReason;
  bool? healthInsurance;
  String? healthInsuranceDetails;
  String? techNo;

  // Section 35-37: Family Assessment
  List<String> familyStrengths = [];
  List<String> familyWeaknesses = [];
  List<String> nationalHealthProgrammes = [];

  // Section 38: Medicine
  String? drugPurchaseLocation;
  String? medicineCompliance; // Complete/Partial/Unfinished

  // Section 39: Contact
  String? contactNumber;

  // Additional Notes
  String? additionalNotes;
  String? surveyDate;
  String? surveyorName;
  String? studentId; // Student ID who created the survey
  List<String> problemsIdentified = [];
  
  // Sync status (not stored in JSON, managed by database)
  bool isSynced = false;

  Map<String, dynamic> toJson() {
    return {
      'areaName': areaName,
      'areaType': areaType,
      'healthCentre': healthCentre,
      'headOfFamily': headOfFamily,
      'familyType': familyType,
      'religion': religion,
      'subCaste': subCaste,
      'houseType': houseType,
      'numberOfRooms': numberOfRooms,
      'roomAdequacy': roomAdequacy,
      'occupancy': occupancy,
      'monthlyRent': monthlyRent,
      'ventilation': ventilation,
      'lighting': lighting,
      'waterSupply': waterSupply,
      'kitchen': kitchen,
      'drainage': drainage,
      'lavatory': lavatory,
      'familyMembers': familyMembers.map((m) => m.toJson()).toList(),
      'totalIncome': totalIncome,
      'totalIncomeRange': totalIncomeRange,
      'socioEconomicClass': socioEconomicClass,
      'transport': transport,
      'communicationMedia': communicationMedia,
      'motherTongue': motherTongue,
      'languagesKnown': languagesKnown,
      'dietaryPattern': dietaryPattern.map((k, v) => MapEntry(k, v.toJson())),
      'expenditureItems': expenditureItems.map((e) => e.toJson()).toList(),
      'feverCases': feverCases.map((f) => f.toJson()).toList(),
      'skinDiseases': skinDiseases.map((s) => s.toJson()).toList(),
      'coughCases': coughCases.map((c) => c.toJson()).toList(),
      'otherIllnesses': otherIllnesses.map((o) => o.toJson()).toList(),
      'healthKnowledge': healthKnowledge,
      'nutritionKnowledge': nutritionKnowledge,
      'healthServiceUtilization': healthServiceUtilization,
      'communityLeaders': communityLeaders,
      'pregnantWomen': pregnantWomen.map((p) => p.toJson()).toList(),
      'births': births.map((b) => b.toJson()).toList(),
      'deaths': deaths.map((d) => d.toJson()).toList(),
      'marriages': marriages.map((m) => m.toJson()).toList(),
      'immunizationRecords': immunizationRecords.map((i) => i.toJson()).toList(),
      'eligibleCouples': eligibleCouples.map((e) => e.toJson()).toList(),
      'malnutritionRecords': malnutritionRecords.map((m) => m.toJson()).toList(),
      'sewageDisposalHygienic': sewageDisposalHygienic,
      'sewageDisposalReason': sewageDisposalReason,
      'wasteDisposalHygienic': wasteDisposalHygienic,
      'wasteDisposalMethods': wasteDisposalMethods,
      'wasteDisposalReason': wasteDisposalReason,
      'excretaDisposalHygienic': excretaDisposalHygienic,
      'excretaDisposalReason': excretaDisposalReason,
      'cattlePoultryHygienic': cattlePoultryHygienic,
      'cattleHousing': cattleHousing,
      'cattleHousingReason': cattleHousingReason,
      'wellOrHandPump': wellOrHandPump,
      'wellMaintained': wellMaintained,
      'wellMaintenanceReason': wellMaintenanceReason,
      'lastChlorinationDate': lastChlorinationDate?.toIso8601String(),
      'chlorinationReason': chlorinationReason,
      'houseKeptClean': houseKeptClean,
      'houseCleanReason': houseCleanReason,
      'lastSprayDate': lastSprayDate?.toIso8601String(),
      'sprayReason': sprayReason,
      'breedingPlaceInsects': breedingPlaceInsects,
      'strayDogs': strayDogs,
      'numberOfStrayDogs': numberOfStrayDogs,
      'treatmentLocation': treatmentLocation,
      'officialHealthAgenciesAdequate': officialHealthAgenciesAdequate,
      'healthAgenciesReason': healthAgenciesReason,
      'healthInsurance': healthInsurance,
      'healthInsuranceDetails': healthInsuranceDetails,
      'techNo': techNo,
      'familyStrengths': familyStrengths,
      'familyWeaknesses': familyWeaknesses,
      'nationalHealthProgrammes': nationalHealthProgrammes,
      'drugPurchaseLocation': drugPurchaseLocation,
      'medicineCompliance': medicineCompliance,
      'contactNumber': contactNumber,
      'additionalNotes': additionalNotes,
      'surveyDate': surveyDate,
      'surveyorName': surveyorName,
      'studentId': studentId,
      'problemsIdentified': problemsIdentified,
    };
  }

  SurveyModel.fromJson(Map<String, dynamic> json) {
    areaName = json['areaName'];
    areaType = json['areaType'];
    healthCentre = json['healthCentre'];
    headOfFamily = json['headOfFamily'];
    familyType = json['familyType'];
    religion = json['religion'];
    subCaste = json['subCaste'];
    houseType = json['houseType'];
    numberOfRooms = json['numberOfRooms'];
    roomAdequacy = json['roomAdequacy'];
    occupancy = json['occupancy'];
    monthlyRent = json['monthlyRent']?.toDouble();
    ventilation = json['ventilation'];
    lighting = json['lighting'];
    waterSupply = json['waterSupply'];
    kitchen = json['kitchen'];
    drainage = json['drainage'];
    lavatory = json['lavatory'];
    if (json['familyMembers'] != null) {
      familyMembers = (json['familyMembers'] as List)
          .map((m) => FamilyMember.fromJson(m))
          .toList();
    }
    totalIncome = json['totalIncome']?.toDouble();
    totalIncomeRange = json['totalIncomeRange'];
    socioEconomicClass = json['socioEconomicClass'];
    transport = List<String>.from(json['transport'] ?? []);
    communicationMedia = List<String>.from(json['communicationMedia'] ?? []);
    motherTongue = json['motherTongue'];
    languagesKnown = List<String>.from(json['languagesKnown'] ?? []);
    if (json['dietaryPattern'] != null) {
      dietaryPattern = Map<String, DietaryInfo>.from(
        (json['dietaryPattern'] as Map).map(
          (k, v) => MapEntry(k, DietaryInfo.fromJson(v)),
        ),
      );
    }
    if (json['expenditureItems'] != null) {
      expenditureItems = (json['expenditureItems'] as List)
          .map((e) => ExpenditureItem.fromJson(e))
          .toList();
    }
    if (json['feverCases'] != null) {
      feverCases = (json['feverCases'] as List)
          .map((f) => HealthCondition.fromJson(f))
          .toList();
    }
    if (json['skinDiseases'] != null) {
      skinDiseases = (json['skinDiseases'] as List)
          .map((s) => HealthCondition.fromJson(s))
          .toList()
          .cast<HealthCondition>();
    }
    if (json['coughCases'] != null) {
      coughCases = (json['coughCases'] as List)
          .map((c) => HealthCondition.fromJson(c))
          .toList();
    }
    if (json['otherIllnesses'] != null) {
      otherIllnesses = (json['otherIllnesses'] as List)
          .map((o) => HealthCondition.fromJson(o))
          .toList();
    }
    healthKnowledge = json['healthKnowledge'];
    nutritionKnowledge = json['nutritionKnowledge'];
    healthServiceUtilization = List<String>.from(json['healthServiceUtilization'] ?? []);
    communityLeaders = json['communityLeaders'];
    if (json['pregnantWomen'] != null) {
      pregnantWomen = (json['pregnantWomen'] as List)
          .map((p) => PregnantWoman.fromJson(p))
          .toList();
    }
    if (json['births'] != null) {
      births = (json['births'] as List)
          .map((b) => BirthRecord.fromJson(b))
          .toList();
    }
    if (json['deaths'] != null) {
      deaths = (json['deaths'] as List)
          .map((d) => DeathRecord.fromJson(d))
          .toList();
    }
    if (json['marriages'] != null) {
      marriages = (json['marriages'] as List)
          .map((m) => MarriageRecord.fromJson(m))
          .toList();
    }
    if (json['immunizationRecords'] != null) {
      immunizationRecords = (json['immunizationRecords'] as List)
          .map((i) => ImmunizationRecord.fromJson(i))
          .toList();
    }
    if (json['eligibleCouples'] != null) {
      eligibleCouples = (json['eligibleCouples'] as List)
          .map((e) => EligibleCouple.fromJson(e))
          .toList();
    }
    if (json['malnutritionRecords'] != null) {
      malnutritionRecords = (json['malnutritionRecords'] as List)
          .map((m) => MalnutritionRecord.fromJson(m))
          .toList();
    }
    sewageDisposalHygienic = json['sewageDisposalHygienic'];
    sewageDisposalReason = json['sewageDisposalReason'];
    wasteDisposalHygienic = json['wasteDisposalHygienic'];
    wasteDisposalMethods = List<String>.from(json['wasteDisposalMethods'] ?? []);
    wasteDisposalReason = json['wasteDisposalReason'];
    excretaDisposalHygienic = json['excretaDisposalHygienic'];
    excretaDisposalReason = json['excretaDisposalReason'];
    cattlePoultryHygienic = json['cattlePoultryHygienic'];
    cattleHousing = json['cattleHousing'];
    cattleHousingReason = json['cattleHousingReason'];
    wellOrHandPump = json['wellOrHandPump'];
    wellMaintained = json['wellMaintained'];
    wellMaintenanceReason = json['wellMaintenanceReason'];
    if (json['lastChlorinationDate'] != null) {
      lastChlorinationDate = DateTime.parse(json['lastChlorinationDate']);
    }
    chlorinationReason = json['chlorinationReason'];
    houseKeptClean = json['houseKeptClean'];
    houseCleanReason = json['houseCleanReason'];
    if (json['lastSprayDate'] != null) {
      lastSprayDate = DateTime.parse(json['lastSprayDate']);
    }
    sprayReason = json['sprayReason'];
    breedingPlaceInsects = json['breedingPlaceInsects'];
    strayDogs = json['strayDogs'];
    numberOfStrayDogs = json['numberOfStrayDogs'];
    treatmentLocation = json['treatmentLocation'];
    officialHealthAgenciesAdequate = json['officialHealthAgenciesAdequate'];
    healthAgenciesReason = json['healthAgenciesReason'];
    healthInsurance = json['healthInsurance'];
    healthInsuranceDetails = json['healthInsuranceDetails'];
    techNo = json['techNo'];
    familyStrengths = List<String>.from(json['familyStrengths'] ?? []);
    familyWeaknesses = List<String>.from(json['familyWeaknesses'] ?? []);
    nationalHealthProgrammes = List<String>.from(json['nationalHealthProgrammes'] ?? []);
    drugPurchaseLocation = json['drugPurchaseLocation'];
    medicineCompliance = json['medicineCompliance'];
    contactNumber = json['contactNumber'];
    additionalNotes = json['additionalNotes'];
    surveyDate = json['surveyDate'];
    surveyorName = json['surveyorName'];
    studentId = json['studentId'];
    problemsIdentified = List<String>.from(json['problemsIdentified'] ?? []);
  }
}

class FamilyMember {
  String name;
  String relationship;
  int age;
  String gender;
  String education;
  String occupation;
  double? income;
  String healthStatus;

  FamilyMember({
    required this.name,
    required this.relationship,
    required this.age,
    required this.gender,
    required this.education,
    required this.occupation,
    this.income,
    required this.healthStatus,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'relationship': relationship,
        'age': age,
        'gender': gender,
        'education': education,
        'occupation': occupation,
        'income': income,
        'healthStatus': healthStatus,
      };

  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
        name: json['name'] ?? '',
        relationship: json['relationship'] ?? '',
        age: json['age'] ?? 0,
        gender: json['gender'] ?? '',
        education: json['education'] ?? '',
        occupation: json['occupation'] ?? '',
        income: json['income']?.toDouble(),
        healthStatus: json['healthStatus'] ?? '',
      );
}

class DietaryInfo {
  bool available;
  bool used;
  String preparation; // Traditional/Ideal/Unhygienic

  DietaryInfo({
    required this.available,
    required this.used,
    required this.preparation,
  });

  Map<String, dynamic> toJson() => {
        'available': available,
        'used': used,
        'preparation': preparation,
      };

  factory DietaryInfo.fromJson(Map<String, dynamic> json) => DietaryInfo(
        available: json['available'] ?? false,
        used: json['used'] ?? false,
        preparation: json['preparation'] ?? '',
      );
}

class ExpenditureItem {
  String item;
  double amount;
  double percentage;

  ExpenditureItem({
    required this.item,
    required this.amount,
    required this.percentage,
  });

  Map<String, dynamic> toJson() => {
        'item': item,
        'amount': amount,
        'percentage': percentage,
      };

  factory ExpenditureItem.fromJson(Map<String, dynamic> json) => ExpenditureItem(
        item: json['item'] ?? '',
        amount: json['amount']?.toDouble() ?? 0.0,
        percentage: json['percentage']?.toDouble() ?? 0.0,
      );
}

class HealthCondition {
  String name;
  int age;
  String disease;
  String treatment;
  String remarks;

  HealthCondition({
    required this.name,
    required this.age,
    required this.disease,
    required this.treatment,
    required this.remarks,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'disease': disease,
        'treatment': treatment,
        'remarks': remarks,
      };

  factory HealthCondition.fromJson(Map<String, dynamic> json) => HealthCondition(
        name: json['name'] ?? '',
        age: json['age'] ?? 0,
        disease: json['disease'] ?? '',
        treatment: json['treatment'] ?? '',
        remarks: json['remarks'] ?? '',
      );
}

class PregnantWoman {
  String name;
  String gravida;
  bool registered;
  bool ironFolicAcid;
  bool tetanusToxoid;

  PregnantWoman({
    required this.name,
    required this.gravida,
    required this.registered,
    required this.ironFolicAcid,
    required this.tetanusToxoid,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'gravida': gravida,
        'registered': registered,
        'ironFolicAcid': ironFolicAcid,
        'tetanusToxoid': tetanusToxoid,
      };

  factory PregnantWoman.fromJson(Map<String, dynamic> json) => PregnantWoman(
        name: json['name'] ?? '',
        gravida: json['gravida'] ?? '',
        registered: json['registered'] ?? false,
        ironFolicAcid: json['ironFolicAcid'] ?? false,
        tetanusToxoid: json['tetanusToxoid'] ?? false,
      );
}

class BirthRecord {
  DateTime dateOfBirth;
  String gender;
  String parents;
  String remarks;

  BirthRecord({
    required this.dateOfBirth,
    required this.gender,
    required this.parents,
    required this.remarks,
  });

  Map<String, dynamic> toJson() => {
        'dateOfBirth': dateOfBirth.toIso8601String(),
        'gender': gender,
        'parents': parents,
        'remarks': remarks,
      };

  factory BirthRecord.fromJson(Map<String, dynamic> json) => BirthRecord(
        dateOfBirth: DateTime.parse(json['dateOfBirth']),
        gender: json['gender'] ?? '',
        parents: json['parents'] ?? '',
        remarks: json['remarks'] ?? '',
      );
}

class DeathRecord {
  DateTime dateOfDeath;
  String gender;
  String parents;
  String remarks;

  DeathRecord({
    required this.dateOfDeath,
    required this.gender,
    required this.parents,
    required this.remarks,
  });

  Map<String, dynamic> toJson() => {
        'dateOfDeath': dateOfDeath.toIso8601String(),
        'gender': gender,
        'parents': parents,
        'remarks': remarks,
      };

  factory DeathRecord.fromJson(Map<String, dynamic> json) => DeathRecord(
        dateOfDeath: DateTime.parse(json['dateOfDeath']),
        gender: json['gender'] ?? '',
        parents: json['parents'] ?? '',
        remarks: json['remarks'] ?? '',
      );
}

class MarriageRecord {
  String name;
  int age;
  DateTime dateOfMarriage;
  String remarks;

  MarriageRecord({
    required this.name,
    required this.age,
    required this.dateOfMarriage,
    required this.remarks,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'dateOfMarriage': dateOfMarriage.toIso8601String(),
        'remarks': remarks,
      };

  factory MarriageRecord.fromJson(Map<String, dynamic> json) => MarriageRecord(
        name: json['name'] ?? '',
        age: json['age'] ?? 0,
        dateOfMarriage: DateTime.parse(json['dateOfMarriage']),
        remarks: json['remarks'] ?? '',
      );
}

class ImmunizationRecord {
  String childName;
  DateTime dateOfBirth;
  Map<String, bool> vaccinations; // BCG, OPV, Pentavalent, Measles & Rubella, etc.

  ImmunizationRecord({
    required this.childName,
    required this.dateOfBirth,
    required this.vaccinations,
  });

  Map<String, dynamic> toJson() => {
        'childName': childName,
        'dateOfBirth': dateOfBirth.toIso8601String(),
        'vaccinations': vaccinations,
      };

  factory ImmunizationRecord.fromJson(Map<String, dynamic> json) =>
      ImmunizationRecord(
        childName: json['childName'] ?? '',
        dateOfBirth: DateTime.parse(json['dateOfBirth']),
        vaccinations: Map<String, bool>.from(json['vaccinations'] ?? {}),
      );
}

class EligibleCouple {
  String name;
  int age;
  String gender;
  String priority; // I Priority/II Priority
  String remarks;
  bool usingContraceptive;
  String contraceptiveMethod;
  bool intendingVasectomy;
  bool intendingTubalLigation;
  bool notInterested;
  String notInterestedReason;

  EligibleCouple({
    required this.name,
    required this.age,
    required this.gender,
    required this.priority,
    required this.remarks,
    required this.usingContraceptive,
    required this.contraceptiveMethod,
    required this.intendingVasectomy,
    required this.intendingTubalLigation,
    required this.notInterested,
    required this.notInterestedReason,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'gender': gender,
        'priority': priority,
        'remarks': remarks,
        'usingContraceptive': usingContraceptive,
        'contraceptiveMethod': contraceptiveMethod,
        'intendingVasectomy': intendingVasectomy,
        'intendingTubalLigation': intendingTubalLigation,
        'notInterested': notInterested,
        'notInterestedReason': notInterestedReason,
      };

  factory EligibleCouple.fromJson(Map<String, dynamic> json) => EligibleCouple(
        name: json['name'] ?? '',
        age: json['age'] ?? 0,
        gender: json['gender'] ?? '',
        priority: json['priority'] ?? '',
        remarks: json['remarks'] ?? '',
        usingContraceptive: json['usingContraceptive'] ?? false,
        contraceptiveMethod: json['contraceptiveMethod'] ?? '',
        intendingVasectomy: json['intendingVasectomy'] ?? false,
        intendingTubalLigation: json['intendingTubalLigation'] ?? false,
        notInterested: json['notInterested'] ?? false,
        notInterestedReason: json['notInterestedReason'] ?? '',
      );
}

class MalnutritionRecord {
  String name;
  int age;
  bool kwashiorkor;
  bool marasmus;
  bool vitaminADeficiency;
  bool anemia;
  bool rickets;
  String remarks;

  MalnutritionRecord({
    required this.name,
    required this.age,
    required this.kwashiorkor,
    required this.marasmus,
    required this.vitaminADeficiency,
    required this.anemia,
    required this.rickets,
    required this.remarks,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'kwashiorkor': kwashiorkor,
        'marasmus': marasmus,
        'vitaminADeficiency': vitaminADeficiency,
        'anemia': anemia,
        'rickets': rickets,
        'remarks': remarks,
      };

  factory MalnutritionRecord.fromJson(Map<String, dynamic> json) =>
      MalnutritionRecord(
        name: json['name'] ?? '',
        age: json['age'] ?? 0,
        kwashiorkor: json['kwashiorkor'] ?? false,
        marasmus: json['marasmus'] ?? false,
        vitaminADeficiency: json['vitaminADeficiency'] ?? false,
        anemia: json['anemia'] ?? false,
        rickets: json['rickets'] ?? false,
        remarks: json['remarks'] ?? '',
      );
}

