# Lab Booking & Equipment Reservation App - Setup Guide

## Prerequisites
1. **Flutter SDK** (3.8.1 or higher)
2. **Android Studio** or **VS Code** with Flutter extension
3. **Android Emulator** or **Physical Device**

## Step-by-Step Setup Instructions

### 1. Install Dependencies
Open terminal in the project directory and run:
```bash
flutter pub get
```

### 2. Check Flutter Installation
```bash
flutter doctor
```
Ensure all checkmarks are green or resolve any issues shown.

### 3. Start Android Emulator
- Open Android Studio
- Go to AVD Manager
- Start an Android Virtual Device
- OR connect a physical Android device with USB debugging enabled

### 4. Verify Device Connection
```bash
flutter devices
```
You should see your emulator or device listed.

### 5. Run the Application
```bash
flutter run
```

## App Features Overview

### 🔐 **Login System**
- User ID, Name, and Role (Student/Faculty/Admin)
- Persistent login using SharedPreferences

### 📅 **Calendar View**
- Interactive calendar with booking markers
- Color-coded status indicators:
  - 🟡 Pending (Yellow)
  - 🟢 Approved (Green)
  - 🔴 Rejected (Red)

### ➕ **New Booking**
- Lab and Equipment selection (dropdown)
- Date and Time pickers
- Purpose description
- Optional file attachment
- Automatic conflict detection

### 📋 **My Bookings**
- Upcoming and Past bookings tabs
- Status tracking
- Detailed booking information

### ⏰ **Next Booking Countdown**
- Real-time countdown to next approved booking
- Automatic updates every second

### 👨‍💼 **Admin Dashboard** (Admin role only)
- View all pending bookings
- Approve/Reject bookings
- Export bookings to CSV

### 🗄️ **Database Features**
- SQLite local storage
- Automatic conflict detection
- Sample data pre-loaded:
  - 3 Labs (Computer Lab 1, Physics Lab, Chemistry Lab)
  - 7 Equipment items across labs

## Sample Data Included

### Labs:
1. **Computer Lab 1** - Building A, Floor 2
   - Desktop Computer
   - Projector
   - Printer

2. **Physics Lab** - Building B, Floor 1
   - Microscope
   - Oscilloscope

3. **Chemistry Lab** - Building C, Floor 3
   - Bunsen Burner
   - Centrifuge

## How to Use the App

### For Students/Faculty:
1. **Login** with your details
2. **Create Booking** by selecting lab, equipment, date, and time
3. **View Calendar** to see all bookings
4. **Check My Bookings** for your booking status
5. **Monitor Countdown** for your next approved booking

### For Admins:
1. **Login** with Admin role
2. **Access Admin Dashboard** from home screen
3. **Review Pending Bookings**
4. **Approve/Reject** bookings with one click
5. **Export Data** to CSV for reporting

## Troubleshooting

### Common Issues:

1. **Build Errors**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Database Issues**
   - Uninstall and reinstall the app to reset database

3. **Emulator Not Starting**
   - Restart Android Studio
   - Create a new AVD if needed

4. **Dependencies Not Found**
   - Ensure internet connection
   - Run `flutter pub get` again

### File Structure:
```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user.dart
│   ├── lab.dart
│   ├── equipment.dart
│   └── booking.dart
├── providers/                # State management
│   ├── user_provider.dart
│   └── booking_provider.dart
├── helpers/                  # Database helper
│   └── database_helper.dart
└── screens/                  # UI screens
    ├── login_screen.dart
    ├── home_screen.dart
    ├── calendar_screen.dart
    ├── new_booking_screen.dart
    ├── my_bookings_screen.dart
    ├── admin_dashboard_screen.dart
    └── booking_details_screen.dart
```

## Key Features Implemented:
✅ SQLite Database with conflict detection  
✅ Calendar view with booking markers  
✅ Real-time countdown timer  
✅ File picker for document upload  
✅ CSV export functionality  
✅ Role-based access control  
✅ Responsive UI with Material Design  
✅ State management with Provider  
✅ Form validation and error handling  

## Testing the App:
1. Login as different roles to test features
2. Create bookings with overlapping times to test conflict detection
3. Try approving/rejecting bookings as admin
4. Test the countdown timer with near-future bookings
5. Export CSV to verify data export functionality

The app is now ready to use! 🚀