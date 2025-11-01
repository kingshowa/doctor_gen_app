class HealthData {
  final int? id;
  final int userId;
  final double? heightCm;
  final double? weightKg;
  final String? bloodType;
  final String? allergies;
  final String? medicalConditions;
  final String? medications;
  final String? lastCheckupDate;
  final String? createdAt;
  final String? updatedAt;

  HealthData({
    this.id,
    required this.userId,
    this.heightCm,
    this.weightKg,
    this.bloodType,
    this.allergies,
    this.medicalConditions,
    this.medications,
    this.lastCheckupDate,
    this.createdAt,
    this.updatedAt,
  });

  factory HealthData.fromMap(Map<String, dynamic> map) => HealthData(
    id: map['id'],
    userId: map['user_id'],
    heightCm: map['height_cm']?.toDouble(),
    weightKg: map['weight_kg']?.toDouble(),
    bloodType: map['blood_type'],
    allergies: map['allergies'],
    medicalConditions: map['medical_conditions'],
    medications: map['medications'],
    lastCheckupDate: map['last_checkup_date'],
    createdAt: map['created_at'],
    updatedAt: map['updated_at'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'height_cm': heightCm,
    'weight_kg': weightKg,
    'blood_type': bloodType,
    'allergies': allergies,
    'medical_conditions': medicalConditions,
    'medications': medications,
    'last_checkup_date': lastCheckupDate,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
