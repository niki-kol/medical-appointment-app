import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../helpers/imports.dart';

class DayAppointmentsPage extends StatelessWidget {
  final DateTime day;

  const DayAppointmentsPage({super.key, required this.day});

  static final List<TimeOfDay> _slots = List.generate(28, (i) {
    return TimeOfDay(hour: 7 + i ~/ 2, minute: (i % 2) * 30);
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppointmentProvider>(context);
    final appointments = provider.getAppointmentsForDay(day);
    final isDesktop = MediaQuery.of(context).size.width > 600;
    final dateLabel = DateFormat.yMMMMd('el_GR').format(day);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: isDesktop ? 64 : kToolbarHeight,
        titleSpacing: isDesktop ? 8 : NavigationToolbar.kMiddleSpacing,
        title: Text(dateLabel, style: TextStyle(fontSize: isDesktop ? 18 : 16)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 900 : double.infinity,
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 32 : 16,
                  vertical: isDesktop ? 16 : 10,
                ),
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.4),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: isDesktop ? 20 : 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: isDesktop ? 10 : 8),
                    Text(
                      '${appointments.length} ραντεβού',
                      style: TextStyle(
                        fontSize: isDesktop ? 14 : 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '07:00 – 20:30',
                      style: TextStyle(
                        fontSize: isDesktop ? 13 : 11,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(isDesktop ? 20 : 8),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isDesktop ? 6 : 3,
                      childAspectRatio: isDesktop ? 2.2 : 1.8,
                      crossAxisSpacing: isDesktop ? 10 : 6,
                      mainAxisSpacing: isDesktop ? 10 : 6,
                    ),
                    itemCount: _slots.length,
                    itemBuilder: (context, index) {
                      final slot = _slots[index];
                      final slotDateTime = DateTime(
                        day.year,
                        day.month,
                        day.day,
                        slot.hour,
                        slot.minute,
                      );
                      final existing = appointments.firstWhereOrNull(
                        (a) =>
                            a.dateTime.hour == slot.hour &&
                            a.dateTime.minute == slot.minute,
                      );
                      final isBooked = existing != null;

                      return _SlotTile(
                        slot: slot,
                        isBooked: isBooked,
                        patientName: existing?.patientName,
                        isDesktop: isDesktop,
                        onTap: () {
                          if (isBooked) {
                            _showEditDialog(context, existing, provider);
                          } else {
                            _showAddDialog(context, slotDateTime, provider);
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Add dialog ──────────────────────────────────────────────────────────────

  void _showAddDialog(
    BuildContext pageContext,
    DateTime slotDateTime,
    AppointmentProvider provider,
  ) {
    final patientCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    final patientFocus = FocusNode();
    final isDesktop = MediaQuery.of(pageContext).size.width > 600;
    final timeLabel = TimeOfDay.fromDateTime(slotDateTime).format(pageContext);

    showDialog(
      context: pageContext,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (sbContext, setState) {
            patientCtrl.addListener(() => setState(() {}));
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 160 : 20,
                vertical: isDesktop ? 40 : 24,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(sbContext).colorScheme.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Νέο Ραντεβού',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(sbContext).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        _TimePill(timeLabel: timeLabel),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _DialogField(
                      controller: patientCtrl,
                      focusNode: patientFocus,
                      label: 'Όνομα Ασθενούς',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 12),
                    _DialogField(
                      controller: phoneCtrl,
                      label: 'Τηλέφωνο',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    _DialogField(
                      controller: notesCtrl,
                      label: 'Σημειώσεις',
                      icon: Icons.notes_outlined,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('Ακύρωση'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: patientCtrl.text.isNotEmpty
                              ? () {
                                  if (provider.hasConflict(slotDateTime)) {
                                    Navigator.pop(dialogContext);
                                    _showSlotTakenDialog(pageContext);
                                  } else {
                                    Navigator.pop(dialogContext);
                                    provider.addAppointment(
                                      Appointment(
                                        patientName: patientCtrl.text.trim(),
                                        phoneNumber: phoneCtrl.text.trim(),
                                        notes: notesCtrl.text.trim(),
                                        dateTime: slotDateTime,
                                      ),
                                    );
                                  }
                                }
                              : null,
                          child: const Text('Αποθήκευση'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => patientFocus.requestFocus(),
    );
  }

  // ── Edit dialog ─────────────────────────────────────────────────────────────

  void _showEditDialog(
    BuildContext pageContext,
    Appointment apt,
    AppointmentProvider provider,
  ) {
    final patientCtrl = TextEditingController(text: apt.patientName);
    final phoneCtrl = TextEditingController(text: apt.phoneNumber);
    final notesCtrl = TextEditingController(text: apt.notes);
    final patientFocus = FocusNode();
    final isDesktop = MediaQuery.of(pageContext).size.width > 600;
    final timeLabel = TimeOfDay.fromDateTime(apt.dateTime).format(pageContext);

    showDialog(
      context: pageContext,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (sbContext, setState) {
            patientCtrl.addListener(() => setState(() {}));
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 160 : 20,
                vertical: isDesktop ? 40 : 24,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row
                    Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          color: Theme.of(sbContext).colorScheme.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Επεξεργασία Ραντεβού',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(sbContext).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        _TimePill(timeLabel: timeLabel),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _DialogField(
                      controller: patientCtrl,
                      focusNode: patientFocus,
                      label: 'Όνομα Ασθενούς',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 12),
                    _DialogField(
                      controller: phoneCtrl,
                      label: 'Τηλέφωνο',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    _DialogField(
                      controller: notesCtrl,
                      label: 'Σημειώσεις',
                      icon: Icons.notes_outlined,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),

                    // ── Reschedule button ──
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        _showRescheduleDialog(pageContext, apt, provider);
                      },
                      icon: const Icon(Icons.event_repeat_outlined, size: 18),
                      label: const Text('Αλλαγή Ημέρας/Ώρας'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Action buttons ──
                    if (isDesktop)
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              _showDeleteConfirmDialog(
                                pageContext,
                                apt,
                                provider,
                              );
                            },
                            icon: const Icon(Icons.delete_outline, size: 16),
                            label: const Text('Διαγραφή'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red.shade400,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Ακύρωση'),
                          ),
                          const SizedBox(width: 12),
                          FilledButton(
                            onPressed: patientCtrl.text.isNotEmpty
                                ? () {
                                    provider.updateAppointment(
                                      apt,
                                      patientCtrl.text.trim(),
                                      phoneCtrl.text.trim(),
                                      notesCtrl.text.trim(),
                                    );
                                    Navigator.pop(dialogContext);
                                  }
                                : null,
                            child: const Text('Αποθήκευση'),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text('Ακύρωση'),
                              ),
                              const SizedBox(width: 8),
                              FilledButton(
                                onPressed: patientCtrl.text.isNotEmpty
                                    ? () {
                                        provider.updateAppointment(
                                          apt,
                                          patientCtrl.text.trim(),
                                          phoneCtrl.text.trim(),
                                          notesCtrl.text.trim(),
                                        );
                                        Navigator.pop(dialogContext);
                                      }
                                    : null,
                                child: const Text('Αποθήκευση'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              _showDeleteConfirmDialog(
                                pageContext,
                                apt,
                                provider,
                              );
                            },
                            icon: const Icon(Icons.delete_outline, size: 16),
                            label: const Text('Διαγραφή'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red.shade400,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => patientFocus.requestFocus(),
    );
  }

  // ── Reschedule dialog ────────────────────────────────────────────────────────

  void _showRescheduleDialog(
    BuildContext pageContext,
    Appointment apt,
    AppointmentProvider provider,
  ) async {
    final isDesktop = MediaQuery.of(pageContext).size.width > 600;
    final navigator = Navigator.of(pageContext);

    // Step 1: Pick a new date
    final newDate = await showDatePicker(
      context: pageContext,
      initialDate: apt.dateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('el', 'GR'),
      helpText: 'Επιλέξτε νέα ημερομηνία',
      confirmText: 'ΕΠΙΛΟΓΗ',
      cancelText: 'ΑΚΥΡΩΣΗ',
    );

    if (newDate == null) return;
    if (!pageContext.mounted) return;

    // Step 2: Pick a new time slot
    navigator.push(
      DialogRoute(
        context: pageContext,
        builder: (dialogContext) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            insetPadding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 16,
              vertical: isDesktop ? 40 : 24,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        color: Theme.of(dialogContext).colorScheme.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Επιλέξτε νέα ώρα',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(
                              dialogContext,
                            ).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            dialogContext,
                          ).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          DateFormat.yMMMd('el_GR').format(newDate),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(dialogContext).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: isDesktop ? 300 : 260,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isDesktop ? 6 : 3,
                        childAspectRatio: isDesktop ? 2.2 : 1.8,
                        crossAxisSpacing: isDesktop ? 10 : 6,
                        mainAxisSpacing: isDesktop ? 10 : 6,
                      ),
                      itemCount: _slots.length,
                      itemBuilder: (context, index) {
                        final slot = _slots[index];
                        final slotDateTime = DateTime(
                          newDate.year,
                          newDate.month,
                          newDate.day,
                          slot.hour,
                          slot.minute,
                        );
                        final isTaken =
                            provider.hasConflict(slotDateTime) &&
                            !(slotDateTime.hour == apt.dateTime.hour &&
                                slotDateTime.minute == apt.dateTime.minute &&
                                slotDateTime.year == apt.dateTime.year &&
                                slotDateTime.month == apt.dateTime.month &&
                                slotDateTime.day == apt.dateTime.day);

                        final scheme = Theme.of(context).colorScheme;
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: isTaken
                                ? () {
                                    Navigator.pop(dialogContext);
                                    _showSlotTakenDialog(pageContext);
                                  }
                                : () {
                                    Navigator.pop(dialogContext);
                                    provider.rescheduleAppointment(
                                      apt,
                                      slotDateTime,
                                    );
                                  },
                            child: Ink(
                              decoration: BoxDecoration(
                                color: isTaken
                                    ? scheme.errorContainer.withValues(
                                        alpha: 0.4,
                                      )
                                    : scheme.surfaceContainerHighest.withValues(
                                        alpha: 0.35,
                                      ),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isTaken
                                      ? scheme.error.withValues(alpha: 0.3)
                                      : scheme.outline.withValues(alpha: 0.12),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    slot.format(context),
                                    style: TextStyle(
                                      fontSize: isDesktop ? 13 : 11,
                                      fontWeight: FontWeight.w500,
                                      color: isTaken
                                          ? scheme.error.withValues(alpha: 0.6)
                                          : scheme.onSurface.withValues(
                                              alpha: 0.7,
                                            ),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                  ),
                                  if (isTaken)
                                    Text(
                                      'Κλειστό',
                                      style: TextStyle(
                                        fontSize: isDesktop ? 10 : 8,
                                        color: scheme.error.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Ακύρωση'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Slot taken warning dialog ────────────────────────────────────────────────

  void _showSlotTakenDialog(BuildContext pageContext) {
    showDialog(
      context: pageContext,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.orange,
          size: 32,
        ),
        title: const Text('Η ώρα είναι κατειλημμένη'),
        content: const Text(
          'Υπάρχει ήδη ραντεβού σε αυτή την ώρα.\nΠαρακαλώ επιλέξτε άλλη ώρα.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ── Delete confirmation dialog ───────────────────────────────────────────────

  void _showDeleteConfirmDialog(
    BuildContext pageContext,
    Appointment apt,
    AppointmentProvider provider,
  ) {
    showDialog(
      context: pageContext,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          Icons.delete_forever_outlined,
          color: Colors.red.shade400,
          size: 32,
        ),
        title: const Text('Διαγραφή Ραντεβού'),
        content: Text(
          'Είστε σίγουροι ότι θέλετε να διαγράψετε το ραντεβού του ${apt.patientName};',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Ακύρωση'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade400),
            onPressed: () {
              provider.deleteAppointment(apt);
              Navigator.pop(dialogContext);
            },
            child: const Text('Διαγραφή'),
          ),
        ],
      ),
    );
  }
}

// ── Slot tile ─────────────────────────────────────────────────────────────────

class _SlotTile extends StatelessWidget {
  final TimeOfDay slot;
  final bool isBooked;
  final String? patientName;
  final bool isDesktop;
  final VoidCallback onTap;

  const _SlotTile({
    required this.slot,
    required this.isBooked,
    required this.isDesktop,
    required this.onTap,
    this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr = slot.format(context);
    final scheme = Theme.of(context).colorScheme;

    final bgColor = isBooked
        ? scheme.primaryContainer
        : scheme.surfaceContainerHighest.withValues(alpha: 0.35);
    final borderColor = isBooked
        ? scheme.primary.withValues(alpha: 0.4)
        : scheme.outline.withValues(alpha: 0.12);
    final timeColor = isBooked
        ? scheme.primary
        : scheme.onSurface.withValues(alpha: 0.45);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 1.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                timeStr,
                style: TextStyle(
                  fontSize: isDesktop ? 14 : 11,
                  fontWeight: isBooked ? FontWeight.w700 : FontWeight.w400,
                  color: timeColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
              if (isBooked && patientName != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    patientName!,
                    style: TextStyle(
                      fontSize: isDesktop ? 11 : 9,
                      fontWeight: FontWeight.w500,
                      color: scheme.primary.withValues(alpha: 0.8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Time pill ─────────────────────────────────────────────────────────────────

class _TimePill extends StatelessWidget {
  final String timeLabel;
  const _TimePill({required this.timeLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        timeLabel,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

// ── Dialog field ──────────────────────────────────────────────────────────────

class _DialogField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final int maxLines;

  const _DialogField({
    required this.controller,
    required this.label,
    required this.icon,
    this.focusNode,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 13,
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.55),
        ),
        prefixIcon: Icon(icon, size: 18),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.outline.withValues(alpha: 0.25),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
        ),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
    );
  }
}
