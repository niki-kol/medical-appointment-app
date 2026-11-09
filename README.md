# Medical Appointment Manager

A Flutter app for managing appointments for a small medical office, with real-time synchronization between devices through Cloud Firestore. Built and maintained solo, from design to deployment. It is a personal project used privately.


## 🔹 Features
- Real-time synchronization across devices(Cloud Firestore streams)  
- Add, edit, delete and reschedule appointments
- Conflict detection: two appointments cannot share the same time slot
- Calendar view and daily schedule overview  
- Search and filtering
- Shows only upcoming appointments
- Automatic archiving of appointments older than 3 months 
- Light and dark theme, Greek localization


## 🔹Screenshots
<img width="800" height="362" alt="Appointment Calendar View" src="https://github.com/user-attachments/assets/1d3fcb0c-28d7-4689-9493-3500e9d9d57a" />
<img width="800" height="362" alt="Appointment Search" src="https://github.com/user-attachments/assets/0c48f965-bb63-46f7-9bdb-c4b8754cd330" />
<img width="800" height="362" alt="Control Panel" src="https://github.com/user-attachments/assets/ea281f6d-44b9-414c-8887-8ba624ab34de" />


## 🔹 Tech Stack
Flutter · Dart · Provider · Cloud Firestore · table_calendar · intl · shared_preferences


## 🔹 Architecture
State management uses `Provider`. `AppointmentProvider` listens to a Firestore snapshot stream and notifies the UI on every change, so all devices stay in sync. Logic that does not need Firebase lives in `appointment_utils.dart` so it can be unit tested.


## 🔹 Design notes
The app has no login on purpose: it is a private tool for two users. Development and testing use a separate Firebase test database, and no real data or credentials are in this repository.

## 🔹Getting Started
 1. Clone the repo and run `flutter pub get`
 2. Create your own Firebase project and enable Firestore
 3. Generate `lib/firebase_options.dart` with `flutterfire configure` (the file is git-ignored)
 4. Run `flutter run`


## 🔹 Tests
```
flutter test
```