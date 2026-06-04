class Appointment {
  final String? id;
  String patientName;
  DateTime dateTime;
  String? notes;
  String? phoneNumber;

  Appointment({
    this.id,
    required this.patientName,
    required this.dateTime,
    this.notes,
    this.phoneNumber,
  });
}
