class User {
  final int? id;
  final String name;
  final String email;
  final String passwordHash;
  final String? gender;
  final String? dateOfBirth;
  final String? imagePath;
  final String? createdAt;
  final String? updatedAt;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    this.gender,
    this.dateOfBirth,
    this.imagePath,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromMap(Map<String, dynamic> map) => User(
    id: map['id'],
    name: map['name'],
    email: map['email'],
    passwordHash: map['password_hash'],
    gender: map['gender'],
    dateOfBirth: map['date_of_birth'],
    imagePath: map['image_path'],
    createdAt: map['created_at'],
    updatedAt: map['updated_at'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'password_hash': passwordHash,
    'gender': gender,
    'date_of_birth': dateOfBirth,
    'image_path': imagePath,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
