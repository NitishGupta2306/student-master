# Student Master Application

A cross-platform Flutter application for managing student records with offline-first architecture, dark mode support, and media capabilities.

## Features

- **CRUD Operations**: Create, read, update, and delete student records
- **Media Support**: Upload and manage student photos (compressed) and videos
- **Dark/Light Mode**: Toggle between themes with persistent storage
- **Search & Sort**: Real-time search and sortable columns
- **CSV Export**: Export student data to CSV format
- **Pagination**: Efficient loading with infinite scroll (50 items per page)
- **Custom IDs**: Auto-generated student IDs in format `STU-YYYY-NNNN`
- **Offline-First**: All data stored locally in SQLite

## Tech Stack

- **Framework**: Flutter 3.9.2+
- **Database**: SQLite with indexed queries
- **State Management**: Provider
- **Video Player**: Chewie + video_player
- **Image Compression**: flutter_image_compress
- **Platforms**: iOS, Android, Desktop (macOS, Windows, Linux)

## Quick Start

### Prerequisites
- Flutter SDK 3.9.2 or higher
- See `requirements.txt` for system requirements

### Installation

```bash
cd src
flutter pub get
flutter run -d macos  # or ios/android/windows/linux
```

## Validation Rules

- **Email**: Valid format, must be unique
- **Phone**: Format `+91 XXXXXXXXXX`, must be unique
- **Name**: Minimum 2 characters
- **Photo**: Max 5 MB (auto-compressed to ~500KB), JPG/PNG
- **Video**: Max 1 minute, MP4/MOV/AVI

## Documentation

- **[PRD.md](docs/PRD.md)** - Product Requirements Document
- **[QUICKSTART.md](docs/QUICKSTART.md)** - Detailed setup guide
- **[PROJECT_SUMMARY.md](docs/PROJECT_SUMMARY.md)** - Technical overview
- **[CHANGELOG.md](docs/CHANGELOG.md)** - Version history

## Project Structure

```
src/lib/
├── constants/          # App-wide constants
├── models/            # Data models
├── services/          # Business logic (DB, storage, providers)
├── screens/           # UI screens
├── widgets/           # Reusable components
└── utils/             # Validators, generators
```

## Development

```bash
# Run tests
flutter test

# Static analysis
flutter analyze

# Build for production
flutter build macos  # or ios/apk/windows/linux
```

## App Icon Setup

See `src/assets/ICON_INSTRUCTIONS.md` for icon generation instructions.

## Troubleshooting

- **Duplicate email/phone**: Each must be unique in the system
- **Video won't play**: Check format (MP4/MOV/AVI) and duration (max 1 min)
- **Photo issues**: Ensure JPG/PNG format and under 5 MB

## Version

**1.0.0** - Last Updated: 2025-10-06

## License

Created for university use. All rights reserved.
