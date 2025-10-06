# Quick Start Guide

## Installation & First Run

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run the Application
```bash
# For macOS
flutter run -d macos

# For other platforms, replace with:
# -d ios (iOS Simulator)
# -d android (Android Emulator)
# -d windows (Windows Desktop)
# -d linux (Linux Desktop)
```

### 3. Generate Test Data
Once the app launches:
1. Click the **"Generate Test Data"** button (orange button)
2. Confirm the dialog
3. Wait a few seconds for 30 sample students to be created

## Quick Feature Tour

### ✅ Create a Student
1. Click **"Add New Student"**
2. Fill in:
   - Name: `John Doe`
   - Email: `john.doe@university.edu`
   - Phone: `+91 9876543210`
3. Click **"Create"**

### ✅ Search Students
Type in the search box:
- Try: `john` or `9876` or `@university`

### ✅ View Details
- Click on any student row
- View photo and video (if uploaded)
- Click **"Edit"** to modify
- Click **"Delete Student"** to remove

### ✅ Export Data
- Click **"Export CSV"**
- File saved to Downloads (desktop) or Documents (mobile)

## File Limits

| Type | Max Size/Duration | Formats |
|------|------------------|---------|
| Photo | 5 MB | JPG, PNG |
| Video | 10 minutes | MP4, MOV, AVI |

## Validation Rules

- **Email**: Must be unique and valid format
- **Phone**: Must be `+91 XXXXXXXXXX` (10 digits) and unique
- **Name**: Minimum 2 characters

## Tips

- Student IDs are auto-generated as `STU-2025-0001`, `STU-2025-0002`, etc.
- Click column headers to sort
- Use pagination controls at the bottom for large datasets
- All data is stored offline in SQLite

## Need Help?

Check the full **README.md** or **PRD.md** for detailed documentation.
