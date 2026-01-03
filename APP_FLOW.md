# App Flow and Navigation

## Screen Flow

1. **Login Screen** (`lib/screens/login_screen.dart`)
   - First screen when app starts
   - User enters Student ID
   - Validates ID (minimum 3 characters)
   - Saves ID to SharedPreferences
   - Navigates to → **Home Screen**

2. **Home Screen** (`lib/screens/home_screen.dart`)
   - Main dashboard
   - Shows Student ID in app bar
   - Has logout button
   - Buttons:
     - "New Survey" → **Survey Form Screen**
     - "View All Surveys" → **Surveys List Screen**
     - "Sync to Server" (if unsynced surveys exist)

3. **Survey Form Screen** (`lib/screens/survey_form_screen.dart`)
   - Multi-step form with 7 sections
   - Automatically saves Student ID with survey
   - On save → Returns to **Home Screen**

4. **Surveys List Screen** (`lib/screens/surveys_list_screen.dart`)
   - Shows all saved surveys
   - Displays Student ID for each survey
   - Options: View, Sync, Delete
   - Returns to → **Home Screen**

## Navigation Paths

```
App Start
  ↓
Login Screen
  ↓ (Enter Student ID)
Home Screen
  ├─→ New Survey → Survey Form Screen → (Save) → Home Screen
  ├─→ View All Surveys → Surveys List Screen → Home Screen
  └─→ Logout → Login Screen
```

## Data Flow

1. **Student ID Storage**
   - Saved in SharedPreferences with key: `student_id`
   - Persists across app restarts
   - Cleared on logout

2. **Survey Storage**
   - Local: SQLite (mobile) or SharedPreferences (web)
   - Each survey includes:
     - All form data
     - Student ID (automatically added)
     - Survey date
     - Surveyor name

3. **Survey Sync**
   - Surveys can be synced to server
   - Uses API service for server communication

## Key Features

✅ Student ID required before accessing app
✅ Student ID displayed in app bar
✅ Student ID automatically attached to all surveys
✅ Student ID visible in survey list
✅ Logout functionality
✅ Persistent login (until logout)
✅ Offline support (local storage)
✅ Server sync capability

