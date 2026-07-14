import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
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
  DateTime _focusedMonth = DateTime(2026, 7);

  List<Map<String, dynamic>> get _markers => ref
      .watch(allCalendarEventsProvider)
      .map(
        (e) => {'date': e.eventDate, 'category': e.category, 'title': e.title},
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final category = ref.watch(calendarCategoryProvider);
    final events = ref.watch(filteredCalendarEventsProvider(_focusedMonth));
    final title = category == 'All'
        ? 'Semua'
        : '$category Bulan ${_kMonths[_focusedMonth.month - 1]}';

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
                  events: _markers,
                  showCategoryFilter: true,
                  selectionMode: RangeSelectionMode.toggledOff,
                  initialDateRange: DateTimeRange(
                    start: _focusedMonth,
                    end: _focusedMonth,
                  ),
                  initialCategory: category,
                  onCategoryChanged: (c) => ref
                      .read(calendarCategoryProvider.notifier)
                      .setCategory(c),
                  onMonthChanged: (m) => setState(() => _focusedMonth = m),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: events.isEmpty
                  ? const Center(child: Text('Tidak ada event di bulan ini'))
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
                              urgencyText: e.urgencyText,
                              imagePath: e.imagePath,
                              hasBackground: true,
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
