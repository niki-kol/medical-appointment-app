import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/appointment_provider.dart';
import '../models/appointment.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  DateTimeRange? _dateRange;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _dateRange,
      locale: const Locale('el', 'GR'),
    );
    if (picked != null) setState(() => _dateRange = picked);
  }

  List<Appointment> _filtered(List<Appointment> all) {
    var list = all;

    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list.where((a) {
        return a.patientName.toLowerCase().contains(q) ||
            (a.phoneNumber?.contains(q) ?? false);
      }).toList();
    }

    if (_dateRange != null) {
      final start = DateTime(
        _dateRange!.start.year,
        _dateRange!.start.month,
        _dateRange!.start.day,
      );
      final end = DateTime(
        _dateRange!.end.year,
        _dateRange!.end.month,
        _dateRange!.end.day,
        23,
        59,
        59,
      );
      list = list
          .where((a) => a.dateTime.isAfter(start) && a.dateTime.isBefore(end))
          .toList();
    }

    list.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppointmentProvider>(context);
    final results = _filtered(provider.allAppointments);
    final isDesktop = MediaQuery.of(context).size.width > 600;
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'el_GR');
    final shortDateFormat = DateFormat('dd/MM/yy');

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: isDesktop ? 64 : kToolbarHeight,
        titleSpacing: isDesktop ? 8 : NavigationToolbar.kMiddleSpacing,
        title: Text(
          'Αναζήτηση Ραντεβού',
          style: TextStyle(fontSize: isDesktop ? 18 : 16),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 720 : double.infinity,
          ),
          child: Column(
            children: [
              // ── Search & filter area ──
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isDesktop ? 24 : 16,
                  isDesktop ? 20 : 14,
                  isDesktop ? 24 : 16,
                  isDesktop ? 12 : 10,
                ),
                child: Column(
                  children: [
                    // Search bar
                    TextField(
                      controller: _searchCtrl,
                      style: TextStyle(fontSize: isDesktop ? 15 : 14),
                      decoration: InputDecoration(
                        hintText: 'Αναζήτηση ονόματος ή τηλεφώνου...',
                        hintStyle: TextStyle(
                          fontSize: isDesktop ? 14 : 13,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: (0.4)),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: isDesktop ? 20 : 18,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: (0.4)),
                        ),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: isDesktop ? 18 : 16,
                                ),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  setState(() => _query = '');
                                },
                              )
                            : null,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: isDesktop ? 14 : 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withValues(alpha: (0.25)),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withValues(alpha: (0.2)),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: (0.3)),
                      ),
                      onChanged: (v) => setState(() => _query = v),
                    ),

                    SizedBox(height: isDesktop ? 10 : 8),

                    // Date filter row
                    Row(
                      children: [
                        // Date range pill
                        GestureDetector(
                          onTap: _pickDateRange,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 14 : 12,
                              vertical: isDesktop ? 8 : 7,
                            ),
                            decoration: BoxDecoration(
                              color: _dateRange != null
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer
                                  : Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest
                                        .withValues(alpha: (0.4)),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _dateRange != null
                                    ? Theme.of(context).colorScheme.primary
                                          .withValues(alpha: (0.3))
                                    : Theme.of(context).colorScheme.outline
                                          .withValues(alpha: (0.2)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.date_range_outlined,
                                  size: isDesktop ? 16 : 14,
                                  color: _dateRange != null
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface
                                            .withValues(alpha: (0.45)),
                                ),
                                SizedBox(width: isDesktop ? 7 : 5),
                                Text(
                                  _dateRange == null
                                      ? 'Επιλογή ημερομηνιών'
                                      : '${shortDateFormat.format(_dateRange!.start)}  –  ${shortDateFormat.format(_dateRange!.end)}',
                                  style: TextStyle(
                                    fontSize: isDesktop ? 13 : 12,
                                    fontWeight: FontWeight.w500,
                                    color: _dateRange != null
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: (0.5)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Clear button — only when filter active
                        if (_dateRange != null) ...[
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => setState(() => _dateRange = null),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isDesktop ? 12 : 10,
                                vertical: isDesktop ? 8 : 7,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .errorContainer
                                    .withValues(alpha: (0.3)),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.error.withValues(alpha: (0.2)),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.close,
                                    size: isDesktop ? 14 : 13,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Καθαρισμός',
                                    style: TextStyle(
                                      fontSize: isDesktop ? 12 : 11,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // ── Result count ──
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 24 : 16,
                  vertical: isDesktop ? 4 : 2,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Βρέθηκαν ${results.length} ραντεβού',
                    style: TextStyle(
                      fontSize: isDesktop ? 12 : 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: (0.4)),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 4),
              const Divider(height: 1),
              const SizedBox(height: 4),

              // ── Results list ──
              Expanded(
                child: results.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _query.isEmpty && _dateRange == null
                                  ? Icons.search_outlined
                                  : Icons.search_off_outlined,
                              size: isDesktop ? 60 : 48,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: (0.18)),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              _query.isEmpty && _dateRange == null
                                  ? 'Χρησιμοποιήστε την αναζήτηση'
                                  : 'Δεν βρέθηκαν ραντεβού',
                              style: TextStyle(
                                fontSize: isDesktop ? 15 : 14,
                                color: Theme.of(context).colorScheme.onSurface
                                    .withValues(alpha: (0.35)),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 24 : 12,
                          vertical: isDesktop ? 8 : 6,
                        ),
                        itemCount: results.length,
                        separatorBuilder: (_, _) =>
                            SizedBox(height: isDesktop ? 8 : 6),
                        itemBuilder: (context, index) {
                          final apt = results[index];
                          final isPast = apt.dateTime.isBefore(DateTime.now());
                          final initials = _initials(apt.patientName);

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {},
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: isPast
                                      ? Theme.of(context)
                                            .colorScheme
                                            .surfaceContainerHighest
                                            .withValues(alpha: (0.25))
                                      : Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isPast
                                        ? Theme.of(context).colorScheme.outline
                                              .withValues(alpha: (0.1))
                                        : Theme.of(context).colorScheme.outline
                                              .withValues(alpha: (0.18)),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isDesktop ? 16 : 12,
                                    vertical: isDesktop ? 14 : 10,
                                  ),
                                  child: Row(
                                    children: [
                                      // Avatar
                                      CircleAvatar(
                                        radius: isDesktop ? 22 : 18,
                                        backgroundColor: isPast
                                            ? Theme.of(context)
                                                  .colorScheme
                                                  .surfaceContainerHighest
                                            : Theme.of(
                                                context,
                                              ).colorScheme.primaryContainer,
                                        child: Text(
                                          initials,
                                          style: TextStyle(
                                            fontSize: isDesktop ? 13 : 11,
                                            fontWeight: FontWeight.w700,
                                            color: isPast
                                                ? Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: (0.4))
                                                : Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: isDesktop ? 14 : 10),

                                      // Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              apt.patientName,
                                              style: TextStyle(
                                                fontSize: isDesktop ? 15 : 13,
                                                fontWeight: FontWeight.w600,
                                                color: isPast
                                                    ? Theme.of(context)
                                                          .colorScheme
                                                          .onSurface
                                                          .withValues(
                                                            alpha: (0.45),
                                                          )
                                                    : null,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.phone_outlined,
                                                  size: isDesktop ? 13 : 11,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: (0.4)),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  apt.phoneNumber ?? '—',
                                                  style: TextStyle(
                                                    fontSize: isDesktop
                                                        ? 13
                                                        : 11,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface
                                                        .withValues(
                                                          alpha: (0.5),
                                                        ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: isDesktop ? 12 : 8,
                                                ),
                                                Icon(
                                                  Icons.schedule_outlined,
                                                  size: isDesktop ? 13 : 11,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: (0.4)),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  dateFormat.format(
                                                    apt.dateTime,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: isDesktop
                                                        ? 13
                                                        : 11,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface
                                                        .withValues(
                                                          alpha: (0.5),
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Past / upcoming badge
                                      SizedBox(width: isDesktop ? 12 : 8),
                                      _Badge(
                                        isPast: isPast,
                                        isDesktop: isDesktop,
                                      ),

                                      // Delete menu
                                      PopupMenuButton<String>(
                                        icon: Icon(
                                          Icons.more_vert,
                                          size: isDesktop ? 20 : 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: (0.35)),
                                        ),
                                        itemBuilder: (_) => [
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.red,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  'Διαγραφή',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                        onSelected: (v) {
                                          if (v == 'delete') {
                                            _confirmDelete(
                                              context,
                                              provider,
                                              apt,
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
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
      ),
    );
  }

  // Extract up to 2 initials from a name
  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  void _confirmDelete(
    BuildContext context,
    AppointmentProvider provider,
    Appointment appointment,
  ) {
    final isDesktop = MediaQuery.of(context).size.width > 600;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        insetPadding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 200 : 40,
          vertical: 40,
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
                    Icons.warning_amber_outlined,
                    color: Colors.red.shade400,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Διαγραφή Ραντεβού',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Θέλετε να διαγράψετε το ραντεβού του/της ${appointment.patientName};',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: (0.7)),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Άκυρο'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                    ),
                    onPressed: () {
                      provider.deleteAppointment(appointment);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Το ραντεβού διαγράφηκε'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    child: const Text('Διαγραφή'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Small past/upcoming badge ─────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final bool isPast;
  final bool isDesktop;

  const _Badge({required this.isPast, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final bgColor = isPast
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : Theme.of(context).colorScheme.primaryContainer;
    final textColor = isPast
        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: (0.45))
        : Theme.of(context).colorScheme.primary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 10 : 8,
        vertical: isDesktop ? 4 : 3,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isPast ? 'Παρελθόν' : 'Επερχόμενο',
        style: TextStyle(
          fontSize: isDesktop ? 11 : 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
