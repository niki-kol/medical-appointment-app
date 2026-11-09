import 'package:calendar/helpers/appointment_utils.dart';
import 'package:calendar/models/appointment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Appointment appt(String id, DateTime dt) =>
      Appointment(id: id, patientName: 'Test $id', dateTime: dt);

  group('normalizeDateTime', () {
    test('strips seconds and milliseconds', () {
      final result = normalizeDateTime(DateTime(2026, 11, 9, 10, 30, 45, 123));
      expect(result, DateTime(2026, 11, 9, 10, 30));
    });
  });

  group('hasTimeConflict', () {
    final list = [appt('a', DateTime(2026, 11, 9, 10, 30))];

    test('detects same minute even with different seconds', () {
      expect(hasTimeConflict(list, DateTime(2026, 11, 9, 10, 30, 50)), isTrue);
    });

    test('no conflict for a different time', () {
      expect(hasTimeConflict(list, DateTime(2026, 11, 9, 11, 0)), isFalse);
    });

    test('ignores the appointment being rescheduled', () {
      expect(
        hasTimeConflict(list, DateTime(2026, 11, 9, 10, 30), ignoreId: 'a'),
        isFalse,
      );
    });
  });

  group('appointmentsForDay', () {
    test('filters by day and sorts by time', () {
      final all = [
        appt('late', DateTime(2026, 11, 9, 15, 0)),
        appt('other', DateTime(2026, 11, 10, 9, 0)),
        appt('early', DateTime(2026, 11, 9, 9, 0)),
      ];
      final result = appointmentsForDay(all, DateTime(2026, 11, 9));
      expect(result.map((a) => a.id), ['early', 'late']);
    });

    test('returns empty list when nothing that day', () {
      expect(appointmentsForDay([], DateTime(2026, 11, 9)), isEmpty);
    });
  });
}