import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/models/opportunity_model.dart';
import '../../../../core/utils/date_time_extension.dart';
import '../../../../core/widgets/hunt_calendar.dart';
import '../../../../core/widgets/opportunity_card.dart';
import '../providers/calendar_provider.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _start, _end;
  String _category = 'Semua';

  @override
  Widget build(BuildContext context) {
    final monthEvents = ref.watch(calendarMonthEventsProvider(_focusedMonth));
    final inCategory = (monthEvents.value ?? <OpportunityModel>[])
        .where((e) => _category == 'Semua' || e.category == _category)
        .toList();
    final events = inCategory.where((e) {
      final d = e.eventDate;
      return _start == null ||
          (d != null && !d.isBefore(_start!) && !d.isAfter(_end ?? _start!));
    }).toList();
    String month(DateTime d) => d.toMonthName().substring(0, 3);
    String day(DateTime d) => '${d.day} ${month(d)}';
    final period = _start == null
        ? 'Bulan ${month(_focusedMonth)}'
        : _end == null || isSameDay(_start, _end)
        ? day(_start!)
        : '${day(_start!)} - ${day(_end!)}';
    final title = '$_category $period';
    final barStyle = TextStyle(
      fontFamily: AppTextStyles.fontFamily,
      fontSize: 16,
      fontWeight: AppFontWeight.bold,
      color: Colors.white,
    );

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
                child: Column(
                  children: [
                    HuntCalendar(
                      events: inCategory,
                      onMonthChanged: (m) => setState(() {
                        _focusedMonth = DateTime(m.year, m.month);
                        _start = _end = null;
                      }),
                      onRangeChanged: (s, e) => setState(() {
                        _start = s;
                        _end = e;
                      }),
                    ),
                    Container(
                      padding: .symmetric(horizontal: 24, vertical: 8),
                      color: AppColors.orangeNormal,
                      child: Row(
                        spacing: 8,
                        children: [
                          Text('Filter Kategori:', style: barStyle),
                          DropdownButton<String>(
                            value: _category,
                            dropdownColor: AppColors.orangeNormal,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            underline: SizedBox.shrink(),
                            style: barStyle,
                            items: [
                              for (final c in categoryFilters)
                                DropdownMenuItem(value: c, child: Text(c)),
                            ],
                            onChanged: (c) => setState(() => _category = c!),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                            child: OpportunityCard(e),
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
