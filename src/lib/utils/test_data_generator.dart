import 'dart:math';
import '../services/student_repository.dart';

class TestDataGenerator {
  static final Random _random = Random();

  static final List<String> _firstNames = [
    'Aarav',
    'Vivaan',
    'Aditya',
    'Vihaan',
    'Arjun',
    'Sai',
    'Arnav',
    'Ayaan',
    'Krishna',
    'Ishaan',
    'Diya',
    'Ananya',
    'Aadhya',
    'Anika',
    'Navya',
    'Saanvi',
    'Sara',
    'Kiara',
    'Priya',
    'Riya',
    'Rohan',
    'Karan',
    'Rahul',
    'Amit',
    'Raj',
    'Neha',
    'Pooja',
    'Sneha',
    'Anjali',
    'Kavya',
  ];

  static final List<String> _lastNames = [
    'Sharma',
    'Verma',
    'Patel',
    'Kumar',
    'Singh',
    'Reddy',
    'Gupta',
    'Mehta',
    'Agarwal',
    'Joshi',
    'Desai',
    'Rao',
    'Iyer',
    'Nair',
    'Pillai',
    'Chopra',
    'Malhotra',
    'Kapoor',
    'Khan',
    'Sinha',
  ];

  static final List<String> _domains = [
    'gmail.com',
    'yahoo.com',
    'university.edu',
    'student.edu',
    'outlook.com',
  ];

  /// Generate a random Indian phone number (+91 XXXXXXXXXX)
  static String _generatePhoneNumber() {
    // First digit should be 6-9 for mobile numbers in India
    final firstDigit = _random.nextInt(4) + 6; // 6, 7, 8, or 9
    final remainingDigits = List.generate(9, (_) => _random.nextInt(10)).join();
    return '+91 $firstDigit$remainingDigits';
  }

  /// Generate a random email
  static String _generateEmail(String firstName, String lastName) {
    final username =
        '${firstName.toLowerCase()}.${lastName.toLowerCase()}${_random.nextInt(100)}';
    final domain = _domains[_random.nextInt(_domains.length)];
    return '$username@$domain';
  }

  /// Generate a random name
  static String _generateName() {
    final firstName = _firstNames[_random.nextInt(_firstNames.length)];
    final lastName = _lastNames[_random.nextInt(_lastNames.length)];
    return '$firstName $lastName';
  }

  /// Generate test students
  static Future<void> generateTestData({
    required StudentRepository repository,
    int count = 30,
  }) async {
    final Set<String> usedEmails = {};
    final Set<String> usedPhones = {};

    for (int i = 0; i < count; i++) {
      String name = _generateName();
      String email;
      String phone;

      // Ensure unique email
      do {
        final parts = name.split(' ');
        email = _generateEmail(parts[0], parts.length > 1 ? parts[1] : 'user');
      } while (usedEmails.contains(email));
      usedEmails.add(email);

      // Ensure unique phone
      do {
        phone = _generatePhoneNumber();
      } while (usedPhones.contains(phone));
      usedPhones.add(phone);

      try {
        await repository.createStudent(name: name, email: email, phone: phone);
      } catch (e) {
        // Silently ignore duplicate entries during test data generation
      }
    }
  }
}
