import '../helpers/imports.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final isDesktop = MediaQuery.of(context).size.width > 600;

    // Today's appointments for the strip at the bottom
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final todayAppointments =
        appointmentProvider.allAppointments
            .where(
              (a) => a.dateTime.isAfter(today) && a.dateTime.isBefore(tomorrow),
            )
            .toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: isDesktop ? 64 : kToolbarHeight,
        titleSpacing: isDesktop ? 32 : 16,
        title: const Text('Ραντεβού'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            iconSize: isDesktop ? 22 : 20,
            tooltip: 'Αναζήτηση',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.dashboard_outlined),
            iconSize: isDesktop ? 22 : 20,
            tooltip: 'Πίνακας Ελέγχου',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DashboardPage()),
            ),
          ),
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode(context)
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            iconSize: isDesktop ? 22 : 20,
            tooltip: 'Αλλαγή θέματος',
            onPressed: themeProvider.toggleTheme,
          ),
          SizedBox(width: isDesktop ? 16 : 4),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 720 : double.infinity,
          ),
          child: Column(
            children: [
              // ── Calendar ──
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 0 : 0,
                  vertical: isDesktop ? 8 : 0,
                ),
                child: TableCalendar(
                  locale: 'el_GR',
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rowHeight: isDesktop ? 56 : 44,
                  daysOfWeekHeight: isDesktop ? 32 : 24,
                  eventLoader: (day) =>
                      appointmentProvider.getAppointmentsForDay(day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DayAppointmentsPage(day: selectedDay),
                      ),
                    );
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontSize: isDesktop ? 18 : 15,
                      fontWeight: FontWeight.w600,
                    ),
                    headerPadding: EdgeInsets.symmetric(
                      vertical: isDesktop ? 12 : 8,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      size: isDesktop ? 28 : 22,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      size: isDesktop ? 28 : 22,
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      fontSize: isDesktop ? 13 : 11,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    weekendStyle: TextStyle(
                      fontSize: isDesktop ? 13 : 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.red.shade400,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    cellMargin: EdgeInsets.all(isDesktop ? 4 : 2),
                    todayDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: isDesktop ? 15 : 13,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? 15 : 13,
                    ),
                    defaultTextStyle: TextStyle(
                      fontSize: isDesktop ? 15 : 13,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black87
                          : Colors.white70,
                    ),
                    weekendTextStyle: TextStyle(
                      fontSize: isDesktop ? 15 : 13,
                      color: Colors.red.shade400,
                    ),
                    outsideTextStyle: TextStyle(
                      fontSize: isDesktop ? 15 : 13,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    markerDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    markersMaxCount: 1,
                    markerSize: isDesktop ? 7 : 5,
                    markerMargin: const EdgeInsets.symmetric(horizontal: 0.3),
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      if (events.isEmpty) return null;
                      return Positioned(
                        bottom: isDesktop ? 4 : 2,
                        child: Container(
                          width: isDesktop ? 18 : 14,
                          height: isDesktop ? 14 : 11,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${events.length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isDesktop ? 9 : 7,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const Divider(height: 1),

              // ── Today's appointments strip ──
              Expanded(
                child: todayAppointments.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.event_available_outlined,
                              size: isDesktop ? 56 : 44,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.2),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Δεν υπάρχουν ραντεβού σήμερα',
                              style: TextStyle(
                                fontSize: isDesktop ? 15 : 13,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              isDesktop ? 24 : 16,
                              isDesktop ? 16 : 12,
                              isDesktop ? 24 : 16,
                              isDesktop ? 8 : 6,
                            ),
                            child: Text(
                              'Σήμερα',
                              style: TextStyle(
                                fontSize: isDesktop ? 12 : 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.45),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.symmetric(
                                horizontal: isDesktop ? 24 : 12,
                                vertical: isDesktop ? 4 : 2,
                              ),
                              itemCount: todayAppointments.length,
                              separatorBuilder: (_, _) =>
                                  SizedBox(height: isDesktop ? 6 : 4),
                              itemBuilder: (context, index) {
                                final apt = todayAppointments[index];
                                final isPast = apt.dateTime.isBefore(now);
                                final timeStr = TimeOfDay.fromDateTime(
                                  apt.dateTime,
                                ).format(context);

                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            DayAppointmentsPage(day: today),
                                      ),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isDesktop ? 16 : 12,
                                        vertical: isDesktop ? 12 : 9,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isPast
                                            ? Theme.of(context)
                                                  .colorScheme
                                                  .surfaceContainerHighest
                                                  .withValues(alpha: 0.4)
                                            : Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer
                                                  .withValues(alpha: 0.35),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: isPast
                                              ? Theme.of(context)
                                                    .colorScheme
                                                    .outline
                                                    .withValues(alpha: 0.1)
                                              : Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withValues(alpha: 0.15),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          // Time chip
                                          Container(
                                            width: isDesktop ? 56 : 46,
                                            alignment: Alignment.center,
                                            child: Text(
                                              timeStr,
                                              style: TextStyle(
                                                fontSize: isDesktop ? 14 : 12,
                                                fontWeight: FontWeight.w700,
                                                color: isPast
                                                    ? Theme.of(context)
                                                          .colorScheme
                                                          .onSurface
                                                          .withValues(
                                                            alpha: 0.35,
                                                          )
                                                    : Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: isDesktop ? 28 : 22,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline
                                                .withValues(alpha: 0.15),
                                            margin: EdgeInsets.symmetric(
                                              horizontal: isDesktop ? 14 : 10,
                                            ),
                                          ),
                                          // Name
                                          Expanded(
                                            child: Text(
                                              apt.patientName,
                                              style: TextStyle(
                                                fontSize: isDesktop ? 14 : 13,
                                                fontWeight: FontWeight.w500,
                                                color: isPast
                                                    ? Theme.of(context)
                                                          .colorScheme
                                                          .onSurface
                                                          .withValues(
                                                            alpha: 0.35,
                                                          )
                                                    : null,
                                                decoration: isPast
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                                decorationColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .onSurface
                                                        .withValues(alpha: 0.3),
                                              ),
                                            ),
                                          ),
                                          // Phone
                                          if (apt.phoneNumber != null &&
                                              apt.phoneNumber!.isNotEmpty) ...[
                                            const SizedBox(width: 8),
                                            Text(
                                              apt.phoneNumber!,
                                              style: TextStyle(
                                                fontSize: isDesktop ? 13 : 11,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.4),
                                              ),
                                            ),
                                          ],
                                          // Arrow
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.chevron_right,
                                            size: isDesktop ? 18 : 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.25),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
