# Product Requirements Document (PRD)
## Student Master Application

### Project Overview
A cross-platform Flutter application for university staff to manage student application records. This is a CRUD (Create, Read, Update, Delete) application with offline-first architecture using SQLite for local data persistence.

---

## 1. Purpose & Scope

### 1.1 Objective
Build an admin portal for university employees to manage student application records, enabling quick review of applicant information including multimedia content (photos and videos).

### 1.2 User Personas
- **University Reviewers**: Staff who review student applications, watch submission videos, and retrieve contact information
- **Portal Administrators**: Staff who create, update, and manage student records

### 1.3 Out of Scope (Future Phases)
- Student-facing application submission portal
- Cloud sync/backup
- User authentication/login system
- Multi-user access control

---

## 2. Technical Specifications

### 2.1 Technology Stack
- **Framework**: Flutter (cross-platform)
- **Database**: SQLite (local storage)
- **Target Platforms**: iOS, Android, Desktop (equal priority)
- **Architecture**: Offline-first, no network connectivity required

### 2.2 Data Model

#### Student Record Schema
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `id` | String | PRIMARY KEY, Immutable | Format: "STU-YYYY-NNNN" (e.g., STU-2025-0001) |
| `name` | String | REQUIRED, NOT NULL | Full name |
| `email` | String | REQUIRED, UNIQUE, NOT NULL | Valid email format |
| `phone` | String | REQUIRED, UNIQUE, NOT NULL | Indian format: +91 XXXXXXXXXX |
| `photo_path` | String | OPTIONAL, NULLABLE | File path to local storage |
| `video_path` | String | OPTIONAL, NULLABLE | File path to local storage |
| `created_at` | DateTime | AUTO-GENERATED | Timestamp of record creation |
| `updated_at` | DateTime | AUTO-UPDATED | Timestamp of last modification |

### 2.3 File Storage Strategy
- **Storage Location**: App's local documents directory
- **Method**: File paths stored in SQLite (not binary data)
- **File Cleanup**: Automatic deletion of associated files when student record is deleted

#### Media Constraints
| Media Type | Max Duration/Size | Accepted Formats | Notes |
|------------|------------------|------------------|-------|
| Photo | 5 MB | JPG, PNG | Must be displayable in-app |
| Video | 10 minutes | MP4, MOV, AVI | Must be playable with in-app player |

### 2.4 Custom ID Generation
- **Format**: `STU-{YEAR}-{SEQUENCE}`
- **Example**: STU-2025-0001, STU-2025-0002
- **Year Component**: Current year (4 digits)
- **Sequence Component**: Zero-padded 4-digit incremental number (resets yearly)
- **Immutability**: Cannot be edited after creation

---

## 3. Functional Requirements

### 3.1 Core Features (CRUD Operations)

#### 3.1.1 CREATE - Add New Student
- **Trigger**: "Add New Student" button on main screen
- **Action**: Opens form/modal with fields:
  - Name (required)
  - Email (required, validated, unique)
  - Phone (required, validated, unique)
  - Photo (optional, file picker)
  - Video (optional, file picker)
- **Validation**:
  - Email format: standard email regex
  - Phone format: `+91 XXXXXXXXXX` (10 digits after country code)
  - Uniqueness check for email and phone
  - File size validation for photo/video
  - Video duration validation (max 10 minutes)
- **Feedback**:
  - Inline validation errors
  - Toast notification on successful creation
  - Error dialog if file upload fails

#### 3.1.2 READ - View Student List
- **Main Table View** displays:
  - Student ID
  - Name
  - Email
  - Phone Number
- **Features**:
  - Real-time search across name, email, phone
  - Pagination (industry standard page size)
  - Sortable columns (click header to sort)
  - Default sort: Alphabetical by name (A-Z)
- **Interaction**: Click row to open student detail view

#### 3.1.3 READ - Student Detail View
- **Display Format**: Modal/popup overlay
- **Content**:
  - Student ID (read-only)
  - Name
  - Email
  - Phone
  - Photo (full-size display)
  - Video (embedded player with standard controls: play/pause/seek/volume)
- **Actions**:
  - Edit button (toggles edit mode)
  - Delete button (with confirmation dialog)
  - Close/Back button

#### 3.1.4 UPDATE - Edit Student
- **Trigger**: Edit button from any view (table row or detail view)
- **Behavior**: Fields become editable (except Student ID)
- **Validation**: Same as CREATE
- **Feedback**: Toast notification on successful update

#### 3.1.5 DELETE - Remove Student
- **Trigger**: Delete button/icon
- **Confirmation**: "Are you sure?" dialog
- **Action**: 
  - Remove record from database
  - Delete associated photo/video files
- **Feedback**: Toast notification on successful deletion

### 3.2 Search & Filter
- **Search Bar**: Prominent placement on main screen
- **Behavior**: Real-time filtering (updates as user types)
- **Scope**: Searches across name, email, and phone fields
- **Case Sensitivity**: Case-insensitive search

### 3.3 Data Export
- **Feature**: Export to CSV
- **Trigger**: "Export" button on main screen
- **Content**: All student records with fields:
  - Student ID
  - Name
  - Email
  - Phone
  - Created At
  - Updated At
- **Filename Format**: `students_export_YYYY-MM-DD_HH-mm-ss.csv`
- **Exclusions**: Photo and video paths not included

### 3.4 Video Playback
- **Player**: Industry-standard Flutter video player package
- **Controls**: Play, pause, seek bar, volume, fullscreen
- **Formats**: MP4, MOV, AVI
- **Loading**: Show loading indicator while video buffers

---

## 4. Non-Functional Requirements

### 4.1 Performance
- Search results update in <200ms
- Table pagination loads in <500ms
- Video playback starts in <2 seconds
- App launch time <3 seconds

### 4.2 Usability
- **Design**: Professional, clean UI
- **Responsiveness**: Adapts to iOS, Android, Desktop screen sizes
- **Accessibility**: Readable fonts, sufficient contrast
- **Error Messages**: Clear, actionable guidance

### 4.3 Data Integrity
- ACID compliance via SQLite transactions
- Automatic file cleanup on deletion
- Data validation before save
- Unique constraint enforcement

### 4.4 Storage Efficiency
- File path storage (not binary blobs in DB)
- Optional media files to minimize storage
- No redundant data storage

---

## 5. User Interface Specifications

### 5.1 Main Screen Layout
```
┌─────────────────────────────────────────────────┐
│ Student Master Application                       │
├─────────────────────────────────────────────────┤
│ [Add New Student]  [Export CSV]   [Search: ___] │
├─────────────────────────────────────────────────┤
│ ID ↕  | Name ↕ | Email ↕        | Phone ↕       │
├─────────────────────────────────────────────────┤
│ STU-… | John   | john@uni.edu   | +91 98765…    │
│ STU-… | Alice  | alice@uni.edu  | +91 87654…    │
│ ...                                              │
├─────────────────────────────────────────────────┤
│           [< Prev]  Page 1 of 5  [Next >]       │
└─────────────────────────────────────────────────┘
```

### 5.2 Student Detail Popup
```
┌─────────────────────────────────────┐
│  Student Details            [Edit] [×]│
├─────────────────────────────────────┤
│  ID: STU-2025-0001                  │
│  Name: John Doe                     │
│  Email: john@university.edu         │
│  Phone: +91 98765 43210             │
│  ┌─────────────────┐                │
│  │   [Photo]       │                │
│  └─────────────────┘                │
│  ┌─────────────────────────────┐   │
│  │  [Video Player]             │   │
│  │  [▶️ Play] ━━━━○━━━ [🔊]    │   │
│  └─────────────────────────────┘   │
│                                     │
│         [Delete Student]            │
└─────────────────────────────────────┘
```

### 5.3 Add/Edit Form
```
┌─────────────────────────────────────┐
│  Add New Student            [×]     │
├─────────────────────────────────────┤
│  Name: [__________________]         │
│  Email: [__________________]        │
│  Phone: [__________________]        │
│  Photo: [Choose File] optional      │
│  Video: [Choose File] optional      │
│                                     │
│     [Cancel]     [Save]             │
└─────────────────────────────────────┘
```

---

## 6. Validation Rules

### 6.1 Email Validation
- Format: RFC 5322 compliant
- Uniqueness: Must not exist in database
- Example: `student@university.edu`

### 6.2 Phone Validation
- Format: `+91 XXXXXXXXXX` (space optional)
- Country Code: +91 (India)
- Digits: Exactly 10 digits after country code
- Uniqueness: Must not exist in database
- Example: `+91 92116 39739`

### 6.3 File Validation
- **Photo**:
  - Max size: 5 MB
  - Formats: .jpg, .jpeg, .png
  - Validation: File must be readable as image
- **Video**:
  - Max duration: 10 minutes
  - Max size: ~100 MB (estimated for 10min video)
  - Formats: .mp4, .mov, .avi
  - Validation: File must be playable

---

## 7. Error Handling

### 7.1 User-Facing Errors
| Error Type | Display Method | Example Message |
|------------|----------------|-----------------|
| Validation failure | Inline (red text) | "Email must be unique" |
| File too large | Dialog | "Video exceeds 10-minute limit" |
| Duplicate entry | Inline | "Phone number already exists" |
| Delete confirmation | Dialog | "Are you sure you want to delete this student?" |
| Success actions | Toast | "Student created successfully" |

### 7.2 System Errors
- Database connection failures: Display user-friendly error dialog
- File I/O errors: Log error, show retry option
- Corrupted files: Skip loading, show placeholder

---

## 8. Test Data Requirements

### 8.1 Sample Data
- **Quantity**: 20-50 sample student records
- **Variety**: 
  - Mix of students with/without photos
  - Mix of students with/without videos
  - Various name lengths and formats
  - Different phone number formats
- **Purpose**: Testing pagination, search, sort, and performance

### 8.2 Sample Files
- 5-10 sample photos (various sizes)
- 3-5 sample videos (various durations: 30sec, 2min, 8min)

---

## 9. Future Considerations (Post-MVP)

- Student-facing application portal
- Cloud backup and sync
- Authentication and role-based access
- Audit logs (who modified what, when)
- Advanced filtering (by date range, status)
- Batch import from CSV
- Email/SMS integration for contacting students
- Application status workflow (pending/reviewed/accepted/rejected)

---

## 10. Success Metrics

### 10.1 Functional Completeness
- ✅ All CRUD operations working
- ✅ Search returns accurate results
- ✅ Pagination handles 1000+ records smoothly
- ✅ Video playback works on all platforms
- ✅ CSV export contains correct data

### 10.2 User Experience
- ✅ No crashes during normal operations
- ✅ Validation errors are clear and helpful
- ✅ UI is consistent across platforms
- ✅ Actions complete within performance targets

---

## 11. Development Phases

### Phase 1: Core Infrastructure (Week 1)
- SQLite database setup
- Data models and repositories
- Custom ID generation logic
- File storage service

### Phase 2: CRUD Operations (Week 2)
- Create student functionality
- Read/list students with table
- Update student functionality
- Delete with confirmation

### Phase 3: Search & Media (Week 3)
- Real-time search implementation
- Photo upload and display
- Video upload and playback
- File validation

### Phase 4: Polish & Export (Week 4)
- Pagination implementation
- Sorting functionality
- CSV export
- Toast notifications
- Error handling refinement

### Phase 5: Testing & Sample Data (Week 5)
- Generate test data
- Cross-platform testing
- Bug fixes
- Performance optimization

---

## 12. Technical Dependencies

### Required Flutter Packages
- `sqflite` - SQLite database
- `path_provider` - File system access
- `video_player` or `chewie` - Video playback
- `image_picker` or `file_picker` - File selection
- `csv` - CSV export
- `intl` - Date formatting
- `provider` or `riverpod` - State management

---

## Appendix: Glossary

- **CRUD**: Create, Read, Update, Delete
- **SQLite**: Lightweight embedded relational database
- **Toast**: Brief notification popup
- **Inline validation**: Error messages displayed directly next to form fields
- **Pagination**: Breaking large datasets into pages
- **Immutable**: Cannot be changed after creation

---

**Document Version**: 1.0  
**Last Updated**: 2025-10-06  
**Status**: Ready for Development
