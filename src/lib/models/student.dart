class Student {
  final String id; // Format: STU-YYYY-NNNN (immutable)
  final String name;
  final String email;
  final String phone;
  final String? photoPath;
  final String? videoPath;
  final DateTime createdAt;
  final DateTime updatedAt;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photoPath,
    this.videoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert Student to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photo_path': photoPath,
      'video_path': videoPath,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Create Student from Map (database row)
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      photoPath: map['photo_path'] as String?,
      videoPath: map['video_path'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  // Create a copy with updated fields
  Student copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoPath,
    String? videoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoPath: photoPath ?? this.photoPath,
      videoPath: videoPath ?? this.videoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Student{id: $id, name: $name, email: $email, phone: $phone}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Student && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
