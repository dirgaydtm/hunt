import 'package:flutter/material.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/opportunity_model.dart';
import '../../../../shared/widgets/hunt_calendar.dart';
import '../../../../shared/widgets/opportunity_card.dart';
import '../../../notifications/presentation/widgets/notification_bell.dart';
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
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final category = ref.watch(calendarCategoryProvider);
    final monthEvents = ref.watch(calendarMonthEventsProvider(_focusedMonth));
    final all = monthEvents.value ?? const <OpportunityModel>[];
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
      final inCat = category == 'Semua' || e.category == category;
      final onDay =
          _selectedDay == null || isSameDay(e.eventDate, _selectedDay);
      return inCat && onDay;
    }).toList();
    final period = _selectedDay != null
        ? '${_selectedDay!.day} ${_kMonths[_selectedDay!.month - 1]}'
        : 'Bulan ${_kMonths[_focusedMonth.month - 1]}';
    final title = '${category == 'Semua' ? 'Event' : category} $period';

    return Scaffold(
      backgroundColor: AppColors.blueNormal,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                color: Colors.white,
                child: HuntCalendar(
                  events: markers,
                  showCategoryFilter: true,
                  headerAction: const NotificationBell(
                    icon: Icons.notifications_rounded,
                    padding: EdgeInsets.all(12),
                  ),
                  selectionMode: RangeSelectionMode.toggledOff,
                  initialCategory: category,
                  onCategoryChanged: (c) => ref
                      .read(calendarCategoryProvider.notifier)
                      .setCategory(c),
                  onMonthChanged: (m) => setState(() {
                    _focusedMonth = DateTime(m.year, m.month);
                    _selectedDay = null;
                  }),
                  onDaySelected: (d) => setState(() => _selectedDay = d),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: monthEvents.hasError
                  ? const Center(child: Text('Gagal memuat event'))
                  : monthEvents.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : events.isEmpty
                  ? Center(
                      child: Text(
                        _selectedDay != null
                            ? 'Tidak ada event di tanggal ini'
                            : 'Tidak ada event di bulan ini',
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 16,
                            fontWeight: AppFontWeight.bold,
                            color: AppColors.blueDarkActive,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...events.map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
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
