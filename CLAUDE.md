# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Flutter app for managing appointments of a small medical office, synced in real time between devices via Cloud Firestore. Private tool for two users, so there is intentionally **no authentication**. UI is Greek-only (`el_GR` locale; user-facing strings are written in Greek inline, no l10n files).

## Commands

```
flutter pub get
flutter run                     # needs lib/firebase_options.dart (see below)
flutter analyze                 # lints: flutter_lints, platform folders excluded
flutter test                    # all tests
flutter test test/appointment_utils_test.dart          # single file
flutter test --plain-name "detects same minute"         # single test by name
flutter build web && firebase deploy --only hosting     # firebase.json serves build/web
```

`lib/firebase_options.dart` is git-ignored and must be generated with `flutterfire configure`. `firebase.json` points at the **test** Firebase project (`doctor-appointments-test`); real data/credentials never go in the repo.

## Architecture

- **Barrel import:** almost every file does `import '../helpers/imports.dart';`, which re-exports Flutter, third-party packages, `firebase_options.dart`, all pages and providers. New pages/providers should be added to this barrel. Exception: `appointment_utils.dart` and the model import nothing Firebase-related so they can be unit tested without Firebase.
- **State:** `Provider` with two `ChangeNotifier`s registered in `main.dart`:
  - `AppointmentProvider` subscribes to the Firestore `appointments` collection (ordered by `dateTime`) in its constructor and rebuilds the in-memory list on every snapshot; all writes go straight to Firestore and the UI updates via the stream, not by mutating the local list. Firestore offline persistence is enabled with unlimited cache in `main.dart`.
  - `ThemeProvider` persists light/dark/system in `SharedPreferences` (`themeMode` key).
- **Time slots:** all `dateTime` values are normalized to minute precision (seconds/ms stripped) before storing and comparing. Conflict detection = two appointments in the same minute. `addAppointment` and `rescheduleAppointment` both check for conflicts themselves and return `false` without writing if the slot is taken (reschedule ignores the appointment's own slot via `ignoreId`).
- **Archiving:** on startup, `AppointmentProvider._runArchiveIfNeeded` (at most every 7 days, tracked by `lastArchived` in SharedPreferences) moves docs older than 3 months from `appointments` to `archive` in a batch, keeping the same doc IDs.
- **Firestore doc shape** (`appointments`/`archive`): `patientName`, `phoneNumber`, `notes`, `dateTime` (Timestamp). `Appointment.id` is the Firestore doc ID.
- **Pure logic for tests:** `lib/helpers/appointment_utils.dart` (`normalizeDateTime`, `hasTimeConflict`, `appointmentsForDay`) holds the date/conflict logic with no Firebase dependency; `AppointmentProvider` delegates to it. Put new non-Firebase logic there so it can be unit tested.
- **Pages:** `HomePage` (calendar via `table_calendar` + today's list) navigates to `DayAppointment` (daily slot schedule, add/edit/reschedule/delete dialogs), `SearchPage`, and `DashboardPage`. Views show only upcoming appointments.

## Rules

- After any code change, run `flutter analyze` and `flutter test` and report the results.
- Do not modify or stage `analysis_options.yaml`.
- Never run `git commit`, `git push` or `firebase deploy` without asking first.
- Only ever use the test Firebase project (`doctor-appointments-test`); never touch the production Firebase project or its data.
- No authentication is intentional; do not add it unless asked.
