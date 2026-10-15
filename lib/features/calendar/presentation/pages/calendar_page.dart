import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/opportunity_model.dart';
import '../../../../shared/widgets/hunt_calendar.dart';
import '../../../../shared/widgets/opportunity_card.dart';
import '../providers/calendar_provider.dart';

const _kMonths = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _start, _end;

  @override
  Widget build(BuildContext context) {
    final category = ref.watch(calendarCategoryProvider);
    final monthEvents = ref.watch(calendarMonthEventsProvider(_focusedMonth));
    final all = monthEvents.value ?? <OpportunityModel>[];
    final markers = all
        .where((e) => e.eventDate != null)
        .map(
          (e) => {
            'date': e.eventDate!,
            'category': e.category,
            'title': e.title,
          },
        )
        .toList();
    final events = all.where((e) {
      final inCat = category == 'All' || e.category == category;
      final d = e.eventDate;
      final inRange =
          _start == null ||
          (d != null && !d.isBefore(_start!) && !d.isAfter(_end ?? _start!));
      return inCat && inRange;
    }).toList();
    String day(DateTime d) => '${d.day} ${_kMonths[d.month - 1]}';
    final period = _start == null
        ? 'Bulan ${_kMonths[_focusedMonth.month - 1]}'
        : _end == null || isSameDay(_start, _end)
        ? day(_start!)
        : '${day(_start!)} - ${day(_end!)}';
    final title = '${category == 'All' ? 'Semua' : category} $period';

    return Scaffold(
      backgroundColor: AppColors.blueNormal,
      body: Column(
        children: [
          Padding(
            padding: .all(30),
            child: ClipRRect(
              borderRadius: .circular(24),
              child: Container(
                color: Colors.white,
                child: HuntCalendar(
                  events: markers,
                  showCategoryFilter: true,
                  initialCategory: category,
                  onCategoryChanged: (c) => ref
                      .read(calendarCategoryProvider.notifier)
                      .setCategory(c),
                  onMonthChanged: (m) => setState(() {
                    _focusedMonth = DateTime(m.year, m.month);
                    _start = _end = null;
                  }),
                  onRangeChanged: (s, e) => setState(() {
                    _start = s;
                    _end = e;
                  }),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: monthEvents.hasError
                  ? Center(child: Text('Gagal memuat event'))
                  : monthEvents.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : events.isEmpty
                  ? Center(
                      child: Text(
                        _start != null
                            ? 'Tidak ada event di tanggal ini'
                            : 'Tidak ada event di bulan ini',
                      ),
                    )
                  : ListView(
                      padding: .symmetric(horizontal: 24, vertical: 16),
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 16,
                            fontWeight: AppFontWeight.bold,
                            color: AppColors.blueDarkActive,
                          ),
                        ),
                        SizedBox(height: 12),
                        ...events.map(
                          (e) => Padding(
                            padding: .only(bottom: 12),
                            child: OpportunityCard(
                              title: e.title,
                              organizer: e.organizer,
                              category: e.category,
                              urgencyText: e.urgencyText(),
                              imagePath: e.imagePath,
                              hasBackground: true,
                              onTap: () => context.push(
                                '/opportunity/${e.id}',
                                extra: e,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
