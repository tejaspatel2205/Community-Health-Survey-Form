# 🚀 FINAL Lab Booking App - Run Guide

## ✅ **SOLUTION: Platform-Specific Storage**
- **Mobile/Desktop:** Uses SQLite (sqflite dependency)
- **Web/Chrome:** Uses Browser Storage (SharedPreferences)
- **Auto-detects platform** and chooses appropriate storage

## 📱 **Step-by-Step Instructions:**

### **Option 1: Run on Chrome (Web)**
```cmd
flutter run -d chrome
```

### **Option 2: Run on Android Emulator**
```cmd
# Start Android Studio > AVD Manager > Start Emulator
flutter run
```

### **Option 3: Run on Windows Desktop**
```cmd
# Enable Developer Mode first: start ms-settings:developers
flutter run -d windows
```

## 🧪 **Test Login Credentials:**

**Student User:**
- User ID: `student1`
- Name: `John Doe`
- Role: `Student`

**Admin User:**
- User ID: `admin1`
- Name: `Admin User`
- Role: `Admin`

## 📊 **App Features Working:**
✅ **SQLite Database** (Mobile/Desktop)  
✅ **Web Storage** (Chrome/Web)  
✅ **Login System** with role-based access  
✅ **Calendar View** with color-coded bookings  
✅ **New Booking Creation** with conflict detection  
✅ **My Bookings** with upcoming/past tabs  
✅ **Next Booking Countdown** (real-time timer)  
✅ **Admin Dashboard** for approvals  
✅ **CSV Export** functionality  

## 🏢 **Sample Data Included:**
- **Computer Lab 1:** Desktop Computer, Projector, Printer
- **Physics Lab:** Microscope, Oscilloscope
- **Chemistry Lab:** Bunsen Burner, Centrifuge

## 🔧 **If Issues Occur:**
```cmd
flutter clean
flutter pub get
flutter run -d chrome
```

## 🎯 **Key Technical Features:**
- **Platform Detection:** Automatically uses SQLite on mobile, web storage on Chrome
- **Conflict Detection:** Prevents double bookings
- **Real-time Countdown:** Updates every second
- **Role-based UI:** Different features for Student/Faculty/Admin
- **Persistent Storage:** Data survives app restarts

**The Lab Booking & Equipment Reservation App is now fully functional on all platforms!** 🎉

**Just run: `flutter run -d chrome` and start testing!**