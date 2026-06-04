import '../helpers/imports.dart';

class AppointmentProvider extends ChangeNotifier {
  final _col = FirebaseFirestore.instance.collection('appointments');
  List<Appointment> _appointments = [];

  AppointmentProvider() {
    _col.orderBy('dateTime').snapshots().listen((snapshot) {
      _appointments = snapshot.docs.map((doc) {
        final data = doc.data();
        return Appointment(
          id: doc.id,
          patientName: data['patientName'] ?? '',
          phoneNumber: data['phoneNumber'],
          notes: data['notes'],
          dateTime: (data['dateTime'] as Timestamp).toDate(),
        );
      }).toList();
      notifyListeners();
    });
  }

  List<Appointment> get allAppointments => _appointments;

  List<Appointment> getAppointmentsForDay(DateTime day) {
    return _appointments
        .where(
          (a) =>
              a.dateTime.year == day.year &&
              a.dateTime.month == day.month &&
              a.dateTime.day == day.day,
        )
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  bool hasConflict(DateTime dateTime) {
    return _appointments.any((a) => a.dateTime == dateTime);
  }

  Future<bool> addAppointment(Appointment appointment) async {
    if (hasConflict(appointment.dateTime)) return false;
    await _col.add({
      'patientName': appointment.patientName,
      'phoneNumber': appointment.phoneNumber,
      'notes': appointment.notes,
      'dateTime': Timestamp.fromDate(appointment.dateTime),
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
}
