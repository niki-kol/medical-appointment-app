import '../helpers/appointment_utils.dart';
import '../helpers/imports.dart';

class AppointmentProvider extends ChangeNotifier {
  final _col = FirebaseFirestore.instance.collection('appointments');
  List<Appointment> _appointments = [];

  AppointmentProvider() {
    _col.orderBy('dateTime').snapshots().listen((snapshot) {
      _appointments = snapshot.docs.map((doc) {
        final data = doc.data();
        final raw = (data['dateTime'] as Timestamp).toDate();
        return Appointment(
          id: doc.id,
          patientName: data['patientName'] ?? '',
          phoneNumber: data['phoneNumber'],
          notes: data['notes'],
          dateTime: normalizeDateTime(raw),
        );
      }).toList();
      notifyListeners();
    });
    _runArchiveIfNeeded();
  }

  List<Appointment> get allAppointments => _appointments;

  List<Appointment> getAppointmentsForDay(DateTime day) =>
      appointmentsForDay(_appointments, day);

  /// Pass [ignoreId] when rescheduling so an appointment doesn't conflict with itself.
  bool hasConflict(DateTime dateTime, {String? ignoreId}) =>
      hasTimeConflict(_appointments, dateTime, ignoreId: ignoreId);

  Future<bool> addAppointment(Appointment appointment) async {
    if (hasConflict(appointment.dateTime)) return false;
    final normalized = normalizeDateTime(appointment.dateTime);
    await _col.add({
      'patientName': appointment.patientName,
      'phoneNumber': appointment.phoneNumber,
      'notes': appointment.notes,
      'dateTime': Timestamp.fromDate(normalized),
    });
    return true;
  }

  Future<void> updateAppointment(
    Appointment appointment,
    String patientName,
    String? phone,
    String? notes,
  ) async {
    await _col.doc(appointment.id).update({
      'patientName': patientName,
      'phoneNumber': phone,
      'notes': notes,
    });
  }

  Future<void> deleteAppointment(Appointment appointment) async {
    await _col.doc(appointment.id).delete();
  }

  /// Returns false (and writes nothing) if [newDateTime] is taken by another appointment.
  Future<bool> rescheduleAppointment(
    Appointment appointment,
    DateTime newDateTime,
  ) async {
    if (hasConflict(newDateTime, ignoreId: appointment.id)) return false;
    await _col.doc(appointment.id).update({
      'dateTime': Timestamp.fromDate(normalizeDateTime(newDateTime)),
    });
    return true;
  }

  Future<void> _runArchiveIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final lastArchived = prefs.getString('lastArchived');
    final now = DateTime.now();

    // Check if we need to run (never run before, or 7+ days ago)
    if (lastArchived != null) {
      final lastDate = DateTime.parse(lastArchived);
      if (now.difference(lastDate).inDays < 7) return; // too soon, skip
    }

    // Find appointments older than 3 months
    final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
    final archiveCol = FirebaseFirestore.instance.collection('archive');

    final oldDocs = await _col
        .where('dateTime', isLessThan: Timestamp.fromDate(threeMonthsAgo))
        .get();

    if (oldDocs.docs.isEmpty) {
      // Nothing to archive but still save the date
      await prefs.setString('lastArchived', now.toIso8601String());
      return;
    }

    // Use a batch for efficiency - moves everything in one operation
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in oldDocs.docs) {
      final archiveRef = archiveCol.doc(doc.id);
      batch.set(archiveRef, doc.data()); // copy to archive
      batch.delete(doc.reference); // delete from appointments
    }
    await batch.commit();

    // Save today as last archived date
    await prefs.setString('lastArchived', now.toIso8601String());
  }
}
