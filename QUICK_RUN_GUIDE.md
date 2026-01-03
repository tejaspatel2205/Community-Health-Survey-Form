# 🚀 Quick Run Guide - Lab Booking App

## ✅ **SOLUTION: The app is ready but Chrome has compatibility issues**

### **Option 1: Run on Android Emulator (RECOMMENDED)**
```cmd
# 1. Start Android Emulator from Android Studio
# 2. Check devices
flutter devices

# 3. Run on Android
flutter run
```

### **Option 2: Enable Developer Mode for Web**
```cmd
# 1. Enable Developer Mode
start ms-settings:developers

# 2. Turn ON "Developer Mode"
# 3. Run on Chrome
flutter run -d chrome
```

### **Option 3: Run on Windows Desktop**
```cmd
flutter run -d windows
```

## 📱 **App Features Working:**
✅ Login System (Student/Faculty/Admin)  
✅ Calendar View with Bookings  
✅ New Booking Creation  
✅ Conflict Detection  
✅ My Bookings List  
✅ Next Booking Countdown  
✅ Admin Dashboard  
✅ Booking Approval/Rejection  
✅ CSV Export  

## 🧪 **Test Login Credentials:**
**Student:**
- User ID: `student1`
- Name: `John Doe`
- Role: `Student`

**Admin:**
- User ID: `admin1`
- Name: `Admin User`
- Role: `Admin`

## 📊 **Sample Data Included:**
- **Computer Lab 1:** Desktop, Projector, Printer
- **Physics Lab:** Microscope, Oscilloscope  
- **Chemistry Lab:** Bunsen Burner, Centrifuge

## 🔧 **If Issues Persist:**
```cmd
flutter clean
flutter pub get
flutter run
```

**The Lab Booking & Equipment Reservation App is fully functional!** 🎉