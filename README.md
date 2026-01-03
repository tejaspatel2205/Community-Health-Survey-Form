# Community Health Survey Application

A Flutter mobile application for conducting baseline health surveys in community health nursing. This app allows healthcare workers to collect, store, and sync survey data both locally and to a server.

## Features

✅ **Complete Survey Form** - All sections from the baseline survey form
- Basic Information (Area, Health Centre, Family Details)
- Housing Conditions
- Family Composition
- Income & Communication
- Health Conditions
- Environmental Health
- Final Details & Assessment

✅ **User-Friendly Interface**
- Simple checkboxes and dropdown menus
- Multi-step form with progress indicator
- Easy navigation between sections
- Input validation

✅ **Offline Support**
- Local SQLite database for offline data storage
- Sync to server when online
- View all saved surveys

✅ **Data Management**
- Save surveys locally
- View all surveys
- Sync to server
- Delete surveys

## Technology Stack

### Mobile App
- **Language**: Dart
- **Framework**: Flutter
- **Local Database**: SQLite (sqflite)
- **State Management**: Provider
- **HTTP Client**: http package

### Server (Choose one)
- **Option 1**: Node.js + Express + PostgreSQL (Recommended)
- **Option 2**: Python + FastAPI + PostgreSQL
- **Option 3**: Firebase (Easiest for beginners)

See `SERVER_SETUP_GUIDE.md` for detailed server setup instructions.

## Installation

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Node.js (if using Node.js server)
- PostgreSQL (if using PostgreSQL database)

### Steps

1. **Clone or navigate to the project**
   ```bash
   cd flutter_application_1
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Update API URL** (if using server)
   - Open `lib/services/api_service.dart`
   - Update `baseUrl` with your server URL:
     ```dart
     static const String baseUrl = 'https://your-server-url.com/api';
     ```
   - For local testing:
     - Android Emulator: `http://10.0.2.2:3000/api`
     - iOS Simulator: `http://localhost:3000/api`
     - Physical Device: `http://YOUR_COMPUTER_IP:3000/api`

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── survey_model.dart        # Data models for survey
├── providers/
│   └── survey_provider.dart     # State management
├── helpers/
│   └── database_helper.dart     # SQLite database operations
├── services/
│   └── api_service.dart         # Server API communication
└── screens/
    ├── home_screen.dart         # Main home screen
    ├── survey_form_screen.dart  # Multi-step form container
    ├── surveys_list_screen.dart # List of all surveys
    └── form_sections/
        ├── basic_info_section.dart
        ├── housing_section.dart
        ├── family_composition_section.dart
        ├── income_section.dart
        ├── health_section.dart
        ├── environmental_section.dart
        └── final_section.dart
```

## Usage Guide

### Creating a New Survey

1. Open the app
2. Tap **"New Survey"** button
3. Fill in all sections:
   - **Basic Information**: Area name, type, health centre, family details
   - **Housing Condition**: House type, rooms, ventilation, etc.
   - **Family Composition**: Add family members with details
   - **Income & Communication**: Income, transport, languages
   - **Health Conditions**: Add fever cases, skin diseases, etc.
   - **Environmental Health**: Sewage, waste disposal, etc.
   - **Final Details**: Family strengths, weaknesses, problems
4. Tap **"Save Survey"** when done

### Viewing Surveys

1. Tap **"View All Surveys"** from home screen
2. See list of all saved surveys
3. Tap on a survey to view details
4. Use menu (three dots) to:
   - View details
   - Sync to server
   - Delete survey

### Syncing to Server

1. From home screen, tap **"Sync to Server"** (if unsynced surveys exist)
2. Or sync individual surveys from the surveys list
3. Surveys are automatically marked as synced after successful upload

## Form Sections Explained

### 1. Basic Information
- Area name and type (Rural/Urban)
- Health centre name
- Head of family
- Family type (Nuclear/Joint/Single)
- Religion and sub-caste
- Surveyor name

### 2. Housing Condition
- House type (Pucca/Semi pucca/Kutcha)
- Number of rooms and adequacy
- Occupancy (Owner/Tenant)
- Ventilation, lighting, water supply
- Kitchen, drainage, lavatory

### 3. Family Composition
- Add family members with:
  - Name, relationship, age, gender
  - Education, occupation, income
  - Health status

### 4. Income & Communication
- Total family income
- Socio-economic class
- Transport method
- Communication media (checkboxes)
- Languages known
- Contact number

### 5. Health Conditions
- Fever cases
- Skin diseases
- Cough cases (more than 2 weeks)
- Other illnesses
- Family health attitude
- Treatment location
- Health insurance
- Medicine compliance

### 6. Environmental Health
- Sewage disposal
- Waste disposal methods
- Excreta disposal
- Cattle/poultry housing
- Well/hand pump maintenance
- House cleanliness
- Spray dates
- Breeding places
- Stray dogs

### 7. Final Details
- Family strengths
- Family weaknesses
- National health programmes
- Problems identified
- Additional notes

## Database Schema

### Local SQLite (surveys table)
- `id`: Primary key
- `survey_data`: JSON string of survey data
- `created_at`: Timestamp
- `synced`: Boolean (0 = not synced, 1 = synced)
- `surveyor_name`: Surveyor name
- `area_name`: Area name

### Server Database
See `SERVER_SETUP_GUIDE.md` for PostgreSQL schema.

## API Endpoints

The app expects these endpoints on the server:

- `GET /api/health` - Health check
- `GET /api/surveys` - Get all surveys
- `GET /api/surveys/:id` - Get survey by ID
- `POST /api/surveys` - Create new survey
- `POST /api/surveys/sync` - Sync multiple surveys
- `PUT /api/surveys/:id` - Update survey
- `DELETE /api/surveys/:id` - Delete survey

## Troubleshooting

### App won't start
- Run `flutter pub get` to install dependencies
- Check Flutter version: `flutter --version`
- Clean build: `flutter clean && flutter pub get`

### Can't connect to server
- Check if server is running
- Verify API URL in `api_service.dart`
- Check network permissions in AndroidManifest.xml / Info.plist
- For Android emulator, use `10.0.2.2` instead of `localhost`

### Data not saving
- Check device storage permissions
- Verify SQLite database is created
- Check app logs for errors

### Sync not working
- Verify server is accessible
- Check API endpoint URLs
- Verify server CORS settings
- Check network connectivity

## Development

### Adding New Fields

1. Update `lib/models/survey_model.dart` to add new fields
2. Update relevant form section in `lib/screens/form_sections/`
3. Database will automatically handle new fields (stored as JSON)

### Customizing UI

- Colors: Update `ThemeData` in `main.dart`
- Form fields: Modify form sections in `lib/screens/form_sections/`
- Navigation: Update `survey_form_screen.dart`

## Deployment

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Server Deployment

See `SERVER_SETUP_GUIDE.md` for detailed server deployment instructions.

## License

This project is for educational purposes.

## Support

For issues or questions:
1. Check `SERVER_SETUP_GUIDE.md` for server setup
2. Review Flutter documentation: https://flutter.dev
3. Check API service configuration in `lib/services/api_service.dart`

## Future Enhancements

- [ ] Export surveys to PDF/CSV
- [ ] Offline map integration
- [ ] Photo attachments
- [ ] Multi-language support
- [ ] Data analytics dashboard
- [ ] User authentication
- [ ] Role-based access control
