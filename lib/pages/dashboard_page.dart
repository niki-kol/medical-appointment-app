import '../helpers/imports.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppointmentProvider>(context);
    final isDesktop = MediaQuery.of(context).size.width > 600;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final todayApts =
        provider.allAppointments
            .where(
              (a) => a.dateTime.isAfter(today) && a.dateTime.isBefore(tomorrow),
            )
            .toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final upcoming = todayApts.where((a) => a.dateTime.isAfter(now)).toList();
    final nextApt = upcoming.isNotEmpty ? upcoming.first : null;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: isDesktop ? 64 : kToolbarHeight,
        titleSpacing: isDesktop ? 8 : NavigationToolbar.kMiddleSpacing,
        title: Text(
          'Πίνακας Ελέγχου',
          style: TextStyle(fontSize: isDesktop ? 18 : 16),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 780 : double.infinity,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 32 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Σημερινά Ραντεβού',
                        value: todayApts.length.toString(),
                        icon: Icons.calendar_today_outlined,
                        isDesktop: isDesktop,
                        color: Theme.of(context).colorScheme.primary,
                        bgColor: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                    SizedBox(width: isDesktop ? 16 : 12),
                    Expanded(
                      child: _StatCard(
                        label: 'Επερχόμενα',
                        value: upcoming.length.toString(),
                        icon: Icons.schedule_outlined,
                        isDesktop: isDesktop,
                        color: Colors.orange.shade700,
                        bgColor: Colors.orange.shade50,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isDesktop ? 28 : 20),
                if (nextApt != null) ...[
                  _SectionLabel(text: 'Επόμενο Ραντεβού', isDesktop: isDesktop),
                  SizedBox(height: isDesktop ? 12 : 8),
                  _NextCard(appointment: nextApt, isDesktop: isDesktop),
                  SizedBox(height: isDesktop ? 28 : 20),
                ],
                _SectionLabel(text: 'Πρόγραμμα Σήμερα', isDesktop: isDesktop),
                SizedBox(height: isDesktop ? 12 : 8),
                if (todayApts.isEmpty)
                  _EmptyState(isDesktop: isDesktop)
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: todayApts.length,
                    separatorBuilder: (_, _) =>
                        SizedBox(height: isDesktop ? 8 : 6),
                    itemBuilder: (context, index) {
                      final apt = todayApts[index];
                      final isPast = apt.dateTime.isBefore(now);
                      final isCurrent =
                          isPast &&
                          apt.dateTime
                              .add(const Duration(minutes: 30))
                              .isAfter(now);
                      return _ScheduleItem(
                        appointment: apt,
                        isPast: isPast,
                        isCurrent: isCurrent,
                        isDesktop: isDesktop,
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final bool isDesktop;
  const _SectionLabel({required this.text, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: isDesktop ? 13 : 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDesktop;
  final Color color;
  final Color bgColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDesktop,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 20 : 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: isDesktop ? 44 : 38,
            height: isDesktop ? 44 : 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: isDesktop ? 22 : 18, color: color),
          ),
          SizedBox(width: isDesktop ? 16 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isDesktop ? 28 : 24,
                    fontWeight: FontWeight.w800,
                    color: color,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isDesktop ? 12 : 11,
                    color: color.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NextCard extends StatelessWidget {
  final Appointment appointment;
  final bool isDesktop;
  const _NextCard({required this.appointment, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final timeStr = TimeOfDay.fromDateTime(
      appointment.dateTime,
    ).format(context);
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(isDesktop ? 20 : 16),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: isDesktop ? 52 : 44,
            height: isDesktop ? 52 : 44,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: isDesktop ? 28 : 24,
            ),
          ),
          SizedBox(width: isDesktop ? 18 : 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.patientName,
                  style: TextStyle(
                    fontSize: isDesktop ? 18 : 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      size: isDesktop ? 15 : 13,
                      color: scheme.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      timeStr,
                      style: TextStyle(
                        fontSize: isDesktop ? 14 : 13,
                        fontWeight: FontWeight.w600,
                        color: scheme.primary,
                      ),
                    ),
                    if (appointment.phoneNumber != null &&
                        appointment.phoneNumber!.isNotEmpty) ...[
                      SizedBox(width: isDesktop ? 16 : 12),
                      Icon(
                        Icons.phone_outlined,
                        size: isDesktop ? 15 : 13,
                        color: scheme.onSurface.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        appointment.phoneNumber!,
                        style: TextStyle(
                          fontSize: isDesktop ? 14 : 13,
                          color: scheme.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ],
                ),
                if (appointment.notes != null &&
                    appointment.notes!.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    appointment.notes!,
                    style: TextStyle(
                      fontSize: isDesktop ? 13 : 12,
                      color: scheme.onSurface.withValues(alpha: 0.45),
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final Appointment appointment;
  final bool isPast;
  final bool isCurrent;
  final bool isDesktop;

  const _ScheduleItem({
    required this.appointment,
    required this.isPast,
    required this.isCurrent,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr = TimeOfDay.fromDateTime(
      appointment.dateTime,
    ).format(context);
    final scheme = Theme.of(context).colorScheme;

    final bgColor = isCurrent
        ? Colors.green.shade50
        : isPast
        ? scheme.surfaceContainerHighest.withValues(alpha: 0.3)
        : scheme.surface;

    final borderColor = isCurrent
        ? Colors.green.shade200
        : isPast
        ? scheme.outline.withValues(alpha: 0.1)
        : scheme.outline.withValues(alpha: 0.15);

    final dotColor = isCurrent
        ? Colors.green
        : isPast
        ? scheme.onSurface.withValues(alpha: 0.25)
        : scheme.primary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 18 : 14,
        vertical: isDesktop ? 14 : 11,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: isDesktop ? 10 : 8,
            height: isDesktop ? 10 : 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          SizedBox(width: isDesktop ? 14 : 10),
          SizedBox(
            width: isDesktop ? 52 : 44,
            child: Text(
              timeStr,
              style: TextStyle(
                fontSize: isDesktop ? 15 : 13,
                fontWeight: FontWeight.w700,
                color: isCurrent
                    ? Colors.green.shade700
                    : isPast
                    ? scheme.onSurface.withValues(alpha: 0.3)
                    : scheme.primary,
              ),
            ),
          ),
          Container(
            width: 1,
            height: isDesktop ? 26 : 20,
            color: scheme.outline.withValues(alpha: 0.15),
            margin: EdgeInsets.symmetric(horizontal: isDesktop ? 14 : 10),
          ),
          Expanded(
            child: Text(
              appointment.patientName,
              style: TextStyle(
                fontSize: isDesktop ? 15 : 13,
                fontWeight: FontWeight.w600,
                color: isPast ? scheme.onSurface.withValues(alpha: 0.35) : null,
                decoration: isPast ? TextDecoration.lineThrough : null,
                decorationColor: scheme.onSurface.withValues(alpha: 0.25),
              ),
            ),
          ),
          if (appointment.phoneNumber != null &&
              appointment.phoneNumber!.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              appointment.phoneNumber!,
              style: TextStyle(
                fontSize: isDesktop ? 13 : 11,
                color: scheme.onSurface.withValues(alpha: 0.38),
              ),
            ),
          ],
          if (isCurrent) ...[
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'ΤΩΡΑ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isDesktop ? 11 : 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDesktop;
  const _EmptyState({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isDesktop ? 48 : 36),
        child: Column(
          children: [
            Icon(
              Icons.event_available_outlined,
              size: isDesktop ? 56 : 44,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.18),
            ),
            const SizedBox(height: 14),
            Text(
              'Δεν υπάρχουν ραντεβού σήμερα',
              style: TextStyle(
                fontSize: isDesktop ? 15 : 14,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
