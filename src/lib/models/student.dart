/// Represents a student entity in the system.
///
/// Each student has a unique ID in the format STU-YYYY-NNNN, where YYYY is the
/// current year and NNNN is a sequential number. Students can have optional
/// photo and video attachments stored as file paths.
class Student {
  /// Unique student ID in format STU-YYYY-NNNN (immutable)
  final String id;

  /// Student's full name
  final String name;

  /// Student's email address (unique)
  final String email;

  /// Student's phone number in format +91 XXXXXXXXXX (unique)
  final String phone;

  /// Optional path to student's photo file
  final String? photoPath;

  /// Optional path to student's video file
  final String? videoPath;

  /// Timestamp when the student was created
  final DateTime createdAt;

  /// Timestamp when the student was last updated
  final DateTime updatedAt;

  /// Creates a new [Student] instance.
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

  /// Converts this student to a Map for database storage.
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

  /// Creates a [Student] from a database Map.
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

  /// Creates a copy of this student with the given fields replaced.
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
