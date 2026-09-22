# Medical Appointment Management App

A cross-platform mobile application built with Flutter for managing medical appointments, currently in live use.

## 🔹 Overview
This application allows multiple users to manage and synchronize appointments in real time, ensuring consistency and efficient scheduling. Built and maintained solo, from initial design through deployment.

## 🔹 Features
- Real-time appointment synchronization (Firebase Firestore)  
- Multi-user support with role-based access
- Add, edit, and delete appointments
- Change date and time of existing appointments  
- Calendar view and daily schedule overview  
- Search and filtering functionality  
- Dark mode support

## 🔹Screenshots

<img width="800" height="362" alt="Appointment Calendar View" src="https://github.com/user-attachments/assets/1d3fcb0c-28d7-4689-9493-3500e9d9d57a" />
<img width="800" height="362" alt="Appointment Search" src="https://github.com/user-attachments/assets/0c48f965-bb63-46f7-9bdb-c4b8754cd330" />
<img width="800" height="362" alt="Control Panel" src="https://github.com/user-attachments/assets/ea281f6d-44b9-414c-8887-8ba624ab34de" />

## 🔹 Tech Stack
- Flutter & Dart  
- Firebase Firestore  
- Firebase Authentication  
- Provider (State Management)

## 🔹Getting Started
This repo includes a test Firebase configuration for demo purposes only — it holds no real data. To run the app with your own backend:
 1. Clone the repo
 2. Create your own Firebase project and enable Firestore + Authentication
 3. Replace google-services.json (Android) and firebase_options.dart with your own project's config
 4. Run flutter pub get followed by flutter run

## 🔹 Notes
This is a personal project, currently deployed and in live use. This repository includes only a test Firebase configuration for demo purposes — it holds no real data.
