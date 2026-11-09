import 'package:calendar/models/appointment.dart';

/// Strips seconds/milliseconds so two times can be compared reliably.
DateTime normalizeDateTime(DateTime dt) =>
    DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute);

/// True if another appointment already occupies the same minute slot.
/// Pass [ignoreId] when rescheduling so an appointment doesn't conflict with itself.
bool hasTimeConflict(
  List<Appointment> appointments,
  DateTime dateTime, {
  String? ignoreId,
}) {
  final target = normalizeDateTime(dateTime);
  return appointments.any(
    (a) => a.id != ignoreId && normalizeDateTime(a.dateTime) == target,
  );
}

/// Appointments of a given calendar day, sorted by time.
List<Appointment> appointmentsForDay(List<Appointment> all, DateTime day) {
  return all
      .where((a) =>
          a.dateTime.year == day.year &&
          a.dateTime.month == day.month &&
          a.dateTime.day == day.day)
      .toList()
    ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
}