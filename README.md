# Student Master ApplicationStudent Master Application

A cross-platformcross-platform Flutter application for managing university student application records with offline-first architectureapplication for managing university student application records with offline-first architecture.

## Overview📁Project Structure

```
flutter-student-master/
├── src/                    # Flutter application source code
│   ├── lib/               # Dart source files
│   ├── android/           # Android platform files
│   ├── ios/               # iOS platform files
│   ├── macos/             # macOS platform files
│   ├── windows/           # Windows platform files
│   ├── linux/             # Linux platform files
│   ├── web/               # Web platform files
│   ├── test/              # Unit and widget tests
│   ├── pubspec.yaml       # Flutter dependencies
│   └── .gitignore         # Flutter-specific ignores
├── docs/                  # Documentation
│   ├── PRD.md            # Product Requirements Document
│   ├── PROJECT_SUMMARY.md # Technical overview
│   ├── QUICKSTART.md     # Quick start guide
│   ├── CHANGELOG.md      # Version history
│   └── .gitignore        # Documentation ignores
├── requirements.txt       # System and dependency requirements
├── README.md             # This file
└── .gitignore            # Root-level ignores
```

#### Features🚀QuickStart

### Core Functionality
### ✅ **CRUD Operations**Prerequisites
- ✅ **Data Validation**and phone number format validation with uniqueness constraints
- ✅ **Media Support**SDK 392 or higher
- See `requirements.txt` for complete system requirements

### UI Features
- ✅ **Real-Time Search**: Search across name, email, and phone fields
- ✅ **Sortable Columns**: Click column headers to sort data
- ✅ **Pagination**: Navigate through large datasets efficiently
- ✅ **Professional UI**: Clean, responsive design for desktop and mobile
- ✅ **Video Playback**: In-app video player with standard controls
- ✅ **CSV Export**: Export student data to CSV format

### Data Management
- ✅ **Unique Constraints**: Email and phone numbers must be unique
- ✅ **Indian Phone Format**: Validates format `+91 XXXXXXXXXX`
- ✅ **File Storage**: Photos and videos stored in local file system
- ✅ **Automatic Cleanup**: Deletes associated files when student is removed

## Tech Stack

- **Framework**: Flutter 3.9.2+
- **Database**: SQLite (sqflite)
- **State Management**: Provider
- **Video Player**: Chewie + video_player
- **File Handling**: file_picker
- **Platforms**: iOS, Android, Desktop (macOS, Windows, Linux)

## Project Structure

```
lib/
├── models/
│   └── student.dart              # Student data model
├── services/
│   ├── database_helper.dart      # SQLite database setup
│   ├── student_repository.dart   # CRUD operations
│   ├── student_provider.dart     # State management
│   ├── file_storage_service.dart # File handling
│   └── csv_export_service.dart   # CSV export
├── screens/
│   └── home_screen.dart          # Main application screen
├── widgets/
│   ├── student_detail_dialog.dart # Student detail view
│   ├── student_form_dialog.dart   # Create/Edit form
│   └── video_player_widget.dart   # Video player component
├── utils/
│   ├── id_generator.dart         # Custom ID generation
│   ├── validators.dart           # Input validation
│   └── test_data_generator.dart  # Test data creation
└── main.dart                     # Application entry point
```

## Installation

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- iOS Simulator / Android Emulator / Desktop environment

### Setup Steps

1. **Clone the repository**
   ```bash
   cd flutter-student-master
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   # For desktop (macOS)
   flutter run -d macos

   # For iOS
   flutter run -d ios

   # For Android
   flutter run -d android

   # For web (limited functionality)
   flutter run -d chrome
   ```

## Usage Guide

### Getting Started

1. **Launch the Application**
   - The app opens directly to the student list (no login required)

2. **Generate Test Data** (Optional)
   - Click the "Generate Test Data" button
   - This creates 30 sample students with random names, emails, and phone numbers

### Managing Students

#### Create a New Student
1. Click "Add New Student" button
2. Fill in required fields:
   - **Name** (required)
   - **Email** (required, must be unique)
   - **Phone** (required, format: +91 XXXXXXXXXX, must be unique)
3. Optionally upload:
   - **Photo** (max 5 MB, JPG/PNG)
   - **Video** (max 10 minutes, MP4/MOV/AVI)
4. Click "Create"

#### View Student Details
1. Click on any student row in the table
2. View full information including photo and video
3. Play video directly in the dialog

#### Edit Student
1. Open student details (click on row)
2. Click "Edit" button
3. Modify fields as needed
4. Upload new photo/video if desired
5. Click "Update"

#### Delete Student
1. Open student details
2. Click "Delete Student" button
3. Confirm deletion
4. Associated files are automatically removed

### Search and Filter

- **Search**: Type in the search box to filter by name, email, or phone
- **Sort**: Click column headers to sort ascending/descending
- **Paginate**: Use navigation controls at the bottom

### Export Data

1. Click "Export CSV" button
2. File is saved to:
   - **Desktop**: Downloads folder
   - **Mobile**: App documents folder
3. CSV includes: ID, Name, Email, Phone, Created At, Updated At

## Data Schema

### Student Table
| Field | Type | Constraints |
|-------|------|-------------|
| id | TEXT | PRIMARY KEY, Immutable |
| name | TEXT | NOT NULL |
| email | TEXT | UNIQUE, NOT NULL |
| phone | TEXT | UNIQUE, NOT NULL |
| photo_path | TEXT | NULLABLE |
| video_path | TEXT | NULLABLE |
| created_at | TEXT | NOT NULL (ISO 8601) |
| updated_at | TEXT | NOT NULL (ISO 8601) |

### Validation Rules

- **Email**: Standard RFC 5322 format
- **Phone**: `+91` followed by 10 digits
- **Photo**: Max 5 MB, JPG/PNG formats
- **Video**: Max 10 minutes, MP4/MOV/AVI formats
- **Name**: Minimum 2 characters

## File Storage

- **Location**: App's documents directory under `student_files/`
- **Naming**: `{STUDENT_ID}_photo.{ext}` and `{STUDENT_ID}_video.{ext}`
- **Cleanup**: Automatic deletion when student is removed

## Custom ID Format

Student IDs are automatically generated in the format: `STU-YYYY-NNNN`

- **STU**: Prefix
- **YYYY**: Current year (4 digits)
- **NNNN**: Sequential number (zero-padded, resets yearly)

Examples:
- `STU-2025-0001`
- `STU-2025-0042`
- `STU-2026-0001` (new year resets sequence)

## Development

### Running Tests
```bash
flutter test
```

### Static Analysis
```bash
flutter analyze
```

### Build for Production

#### iOS
```bash
flutter build ios
```

#### Android
```bash
flutter build apk
```

#### Desktop (macOS)
```bash
flutter build macos
```

## Dependencies

### Core Dependencies
- `flutter`: SDK
- `sqflite`: ^2.3.0 - SQLite database
- `path_provider`: ^2.1.1 - File system paths
- `provider`: ^6.1.1 - State management
- `file_picker`: ^6.1.1 - File selection
- `video_player`: ^2.8.1 - Video playback
- `chewie`: ^1.7.4 - Video player UI
- `csv`: ^6.0.0 - CSV export
- `intl`: ^0.19.0 - Date formatting
- `fluttertoast`: ^8.2.4 - Toast notifications

See `pubspec.yaml` for complete list.

## Troubleshooting

### Common Issues

**Issue**: "Email already exists" error
- **Solution**: Each email must be unique. Use a different email address.

**Issue**: "Phone number already exists" error
- **Solution**: Each phone number must be unique. Use a different number.

**Issue**: Video won't play
- **Solution**: Ensure video is in MP4/MOV/AVI format and under 10 minutes.

**Issue**: Photo won't display
- **Solution**: Ensure image is in JPG/PNG format and under 5 MB.

**Issue**: File picker warnings during build
- **Solution**: These are package warnings and can be safely ignored. They don't affect functionality.

## Architecture

### Design Patterns
- **Repository Pattern**: Separates data access logic
- **Provider Pattern**: State management
- **Service Layer**: Business logic separation
- **MVVM-like**: UI separated from business logic

### Data Flow
1. User interacts with UI (Screen/Widget)
2. UI calls Provider method
3. Provider calls Repository
4. Repository performs database/file operations
5. Results propagate back through Provider
6. UI updates automatically via notifyListeners()

## Future Enhancements

- [ ] Student-facing application submission portal
- [ ] Cloud sync and backup
- [ ] User authentication and role-based access
- [ ] Email/SMS notifications
- [ ] Application status workflow (pending/reviewed/accepted/rejected)
- [ ] Batch import from CSV
- [ ] Advanced filtering and reporting
- [ ] Audit logs

## License

This project is created for university use. All rights reserved.

## Support

For issues or questions:
1. Check the PRD.md file for detailed specifications
2. Review the troubleshooting section above
3. Examine the code comments for implementation details

---

**Version**: 1.0.0  
**Last Updated**: 2025-10-06  
**Flutter Version**: 3.9.2+
### Installation

1. **Navigate to the source directory**
   ```bash
   cd src
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   # For macOS
   flutter run -d macos

   # For iOS
   flutter run -d ios

   # For Android
   flutter run -d android

   # For Windows
   flutter run -d windows

   # For Linux
   flutter run -d linux
   ```

4. **Generate test data** (Optional)
   - Once the app launches, click "Generate Test Data" button
   - This creates 30 sample students for testing

## ✨ Features

- ✅ **CRUD Operations**: Create, Read, Update, Delete student records
- ✅ **Custom Student IDs**: Auto-generated format `STU-YYYY-NNNN`
- ✅ **Media Support**: Upload photos and videos for each student
- ✅ **Real-Time Search**: Search across name, email, and phone
- ✅ **Sortable Table**: Click column headers to sort data
- ✅ **Pagination**: Efficient navigation of large datasets
- ✅ **CSV Export**: Export student data to CSV format
- ✅ **Offline-First**: All data stored locally in SQLite
- ✅ **Cross-Platform**: Works on iOS, Android, Desktop (macOS, Windows, Linux)

## 📋 Data Validation

- **Email**: Must be unique and valid format (e.g., `student@university.edu`)
- **Phone**: Indian format `+91 XXXXXXXXXX` (must be unique)
- **Photo**: Max 5 MB, JPG/PNG formats
- **Video**: Max 10 minutes, MP4/MOV/AVI formats
- **Name**: Minimum 2 characters

## 📖 Documentation

Complete documentation is available in the `docs/` folder:

- **[PRD.md](docs/PRD.md)** - Complete Product Requirements Document with all specifications
- **[QUICKSTART.md](docs/QUICKSTART.md)** - Quick setup and usage guide
- **[PROJECT_SUMMARY.md](docs/PROJECT_SUMMARY.md)** - Technical overview and architecture
- **[CHANGELOG.md](docs/CHANGELOG.md)** - Version history and updates

## 🏗️ Architecture

### Tech Stack
- **Framework**: Flutter 3.9.2+
- **Database**: SQLite (sqflite)
- **State Management**: Provider
- **Video Player**: Chewie + video_player
- **File Handling**: file_picker

### Project Organization
```
src/lib/
├── models/               # Data models (Student)
├── services/            # Business logic layer
│   ├── database_helper.dart
│   ├── student_repository.dart
│   ├── student_provider.dart
│   ├── file_storage_service.dart
│   └── csv_export_service.dart
├── screens/             # UI screens
│   └── home_screen.dart
├── widgets/             # Reusable UI components
│   ├── student_detail_dialog.dart
│   ├── student_form_dialog.dart
│   └── video_player_widget.dart
├── utils/               # Utilities and helpers
│   ├── id_generator.dart
│   ├── validators.dart
│   └── test_data_generator.dart
└── main.dart            # Application entry point
```

## 🎯 Usage Guide

### Creating a Student
1. Click "Add New Student"
2. Fill in required fields (Name, Email, Phone)
3. Optionally upload photo and/or video
4. Click "Create"

### Viewing Details
1. Click on any student row in the table
2. View complete information including photo and video
3. Play video directly in the dialog

### Editing a Student
1. Open student details
2. Click "Edit" button
3. Modify fields as needed
4. Click "Update"

### Deleting a Student
1. Open student details
2. Click "Delete Student"
3. Confirm deletion
4. Associated files are automatically removed

### Searching
- Type in the search box to filter by name, email, or phone
- Results update in real-time

### Exporting Data
1. Click "Export CSV" button
2. File saved to Downloads (desktop) or Documents (mobile)
3. CSV includes: ID, Name, Email, Phone, Created/Updated timestamps

## 🧪 Development

### Running Tests
```bash
cd src
flutter test
```

### Code Analysis
```bash
cd src
flutter analyze
```

### Build for Production

```bash
cd src

# iOS
flutter build ios

# Android
flutter build apk

# macOS
flutter build macos

# Windows
flutter build windows

# Linux
flutter build linux
```

## 📦 Dependencies

Key packages used:
- `sqflite: ^2.3.0` - SQLite database
- `provider: ^6.1.1` - State management
- `file_picker: ^6.1.1` - File selection
- `video_player: ^2.8.1` - Video playback
- `chewie: ^1.7.4` - Video player UI
- `csv: ^6.0.0` - CSV export
- `fluttertoast: ^8.2.4` - Toast notifications

See `src/pubspec.yaml` for the complete list.

## 🐛 Troubleshooting

**Issue**: "Email already exists"
- **Solution**: Each email must be unique. Use a different email address.

**Issue**: "Phone number already exists"
- **Solution**: Each phone must be unique. Use a different number.

**Issue**: Video won't play
- **Solution**: Ensure video is MP4/MOV/AVI format and under 10 minutes.

**Issue**: Photo won't display
- **Solution**: Ensure image is JPG/PNG format and under 5 MB.

## 🔄 Version History

See [CHANGELOG.md](docs/CHANGELOG.md) for version history and updates.

**Current Version**: 1.0.0

## 📄 License

This project is created for university use. All rights reserved.

## 🤝 Contributing

This is a closed project for university use. For questions or issues, please refer to the documentation in the `docs/` folder.

## 📞 Support

For detailed information:
1. Check `docs/PRD.md` for complete specifications
2. See `docs/QUICKSTART.md` for quick setup
3. Review `docs/PROJECT_SUMMARY.md` for technical details

---

**Built with Flutter** 💙 | **Version** 1.0.0 | **Last Updated** 2025-10-06
