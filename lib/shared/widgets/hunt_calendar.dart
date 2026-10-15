import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_time_extension.dart';
import '../../features/notifications/presentation/widgets/notification_bell.dart';

class HuntCalendar extends StatefulWidget {
  final DateTimeRange? initialDateRange;
  final bool showCategoryFilter;
  final List<Map<String, dynamic>>? events;
  final Function(String)? onCategoryChanged;
  final Function(DateTime)? onMonthChanged;

  /// Called on every range tap; [end] is null until the second date is picked.
  final void Function(DateTime? start, DateTime? end)? onRangeChanged;
  final String initialCategory;

  const HuntCalendar({
    super.key,
    this.initialDateRange,
    this.showCategoryFilter = false,
    this.events,
    this.onCategoryChanged,
    this.onMonthChanged,
    this.onRangeChanged,
    this.initialCategory = 'All',
  });

  @override
  State<HuntCalendar> createState() => _HuntCalendarState();
}

class _HuntCalendarState extends State<HuntCalendar> {
  late DateTime _currentMonth;
  DateTime? _start, _end;
  late String _category;

  static final _gradCircle = BoxDecoration(
    gradient: AppColors.blueGradient,
    shape: .circle,
  );

  TextStyle _ts(double s, FontWeight w, Color c) => TextStyle(
    fontFamily: AppTextStyles.fontFamily,
    fontSize: s,
    fontWeight: w,
    color: c,
  );

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
    _start = widget.initialDateRange?.start;
    _end = widget.initialDateRange?.end;
    _currentMonth = _start ?? DateTime.now();
  }

  void _updateMonth(int offset) {
    final newMonth = DateTime(_currentMonth.year, _currentMonth.month + offset);
    setState(() => _currentMonth = newMonth);
    widget.onMonthChanged?.call(newMonth);
  }

  void _selectDates(DateTime? start, DateTime? end, DateTime focus) {
    setState(() {
      _start = start;
      _end = end;
      _currentMonth = focus;
    });
    widget.onRangeChanged?.call(start, end);

    if (start != null && end != null && !widget.showCategoryFilter) {
      final nav = Navigator.of(context);
      Future.delayed(Duration(milliseconds: 300), () {
        if (mounted) nav.pop(DateTimeRange(start: start, end: end));
      });
    }
  }

  List<Map<String, dynamic>> _getEvents(DateTime day) {
    return widget.events?.where((e) {
          final d = e['date'] as DateTime;
          return d.year == day.year &&
              d.month == day.month &&
              d.day == day.day &&
              (_category == 'All' || e['category'] == _category);
        }).toList() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    final inner = Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        _buildHeader(),
        SizedBox(height: 12),
        _buildCalendar(),
        SizedBox(height: 16),
        _buildDateRangeDisplay(),
      ],
    );

    final content = widget.showCategoryFilter
        ? Padding(padding: .all(24), child: inner)
        : SingleChildScrollView(padding: .all(24), child: inner);

    return widget.showCategoryFilter
        ? Column(
            mainAxisSize: .min,
            children: [content, _buildCategoryFilter()],
          )
        : content;
  }

  Widget _buildHeader() => Row(
    mainAxisAlignment: .spaceBetween,
    children: [
      Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.blueNormal,
              size: 20,
            ),
            onPressed: () => _updateMonth(-1),
          ),
          SizedBox(width: 8),
          Text(
            '${_currentMonth.toMonthName()} ${_currentMonth.year}',
            style: _ts(18, AppFontWeight.bold, AppColors.blueDarkActive),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.blueNormal,
              size: 20,
            ),
            onPressed: () => _updateMonth(1),
          ),
        ],
      ),
      Container(
        decoration: BoxDecoration(
          color: AppColors.blueNormalHover,
          shape: .circle,
        ),
        child: NotificationBell(
          icon: Icons.notifications_rounded,
          padding: .all(12),
        ),
      ),
    ],
  );

  Widget _buildCalendar() => TableCalendar(
    firstDay: DateTime.utc(2000, 1, 1),
    lastDay: DateTime.utc(2100, 12, 31),
    focusedDay: _currentMonth,
    headerVisible: false,
    rowHeight: 44,
    daysOfWeekHeight: 28,
    startingDayOfWeek: .sunday,
    availableGestures: .horizontalSwipe,
    onPageChanged: (d) {
      setState(() => _currentMonth = d);
      widget.onMonthChanged?.call(d);
    },
    rangeSelectionMode: .toggledOn,
    rangeStartDay: _start,
    rangeEndDay: _end,
    onRangeSelected: _selectDates,
    eventLoader: _getEvents,
    calendarBuilders: CalendarBuilders(
      markerBuilder: (ctx, day, evs) {
        if (evs.isEmpty) return SizedBox();
        final category =
            (evs.first as Map)['category'] as String? ?? 'Beasiswa';
        final gradient =
            {
              'Beasiswa': AppColors.blueGradient,
              'Lomba': AppColors.yellowGradient,
              'Magang': AppColors.greenGradient,
            }[category] ??
            AppColors.blueGradient;
        return Positioned.fill(
          child: Container(
            margin: .all(2),
            decoration: BoxDecoration(shape: .circle, gradient: gradient),
            alignment: .center,
            child: Text(
              '${day.day}',
              style: _ts(14, AppFontWeight.bold, Colors.white),
            ),
          ),
        );
      },
      dowBuilder: (ctx, day) => Center(
        child: Text(
          ['S', 'M', 'T', 'W', 'T', 'F', 'S'][day.weekday % 7],
          style: _ts(14, AppFontWeight.bold, AppColors.orangeNormal),
        ),
      ),
    ),
    calendarStyle: CalendarStyle(
      defaultTextStyle: _ts(
        16,
        AppFontWeight.regular,
        AppColors.greyLightDarkActive,
      ),
      weekendTextStyle: _ts(
        16,
        AppFontWeight.regular,
        AppColors.greyLightDarkActive,
      ),
      outsideTextStyle: _ts(
        16,
        AppFontWeight.regular,
        AppColors.greyLightDarker,
      ),
      selectedTextStyle: _ts(14, AppFontWeight.bold, Colors.white),
      selectedDecoration: _gradCircle,
      todayDecoration: BoxDecoration(
        color: AppColors.blueNormal.withValues(alpha: 0.3),
        shape: .circle,
      ),
      rangeStartDecoration: _gradCircle,
      rangeEndDecoration: _gradCircle,
      rangeHighlightColor: AppColors.blueNormal.withValues(alpha: 0.1),
      withinRangeTextStyle: _ts(14, AppFontWeight.bold, AppColors.blueDark),
    ),
  );

  Widget _datePill(DateTime? date, String hint, Color border) => Container(
    padding: .symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      border: .all(color: border, width: 1.5),
      borderRadius: .circular(20),
    ),
    child: Text(
      date?.toFormattedDate() ?? hint,
      style: _ts(14, AppFontWeight.bold, AppColors.blueDarkActive),
    ),
  );

  Widget _buildDateRangeDisplay() => Row(
    mainAxisAlignment: .center,
    spacing: 8,
    children: [
      _datePill(_start, 'Pilih', AppColors.blueLightActive),
      Text('-', style: TextStyle(color: AppColors.blueDarkActive)),
      _datePill(_end, 'Tanggal', AppColors.blueDark),
    ],
  );

  Widget _buildCategoryFilter() => Container(
    padding: .symmetric(horizontal: 24, vertical: 8),
    color: AppColors.orangeNormal,
    child: Row(
      spacing: 8,
      children: [
        Text(
          'Filter Kategori:',
          style: _ts(16, AppFontWeight.bold, Colors.white),
        ),
        DropdownButton<String>(
          value: _category,
          dropdownColor: AppColors.orangeNormal,
          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
          underline: SizedBox.shrink(),
          style: _ts(16, AppFontWeight.bold, Colors.white),
          items: [
            'All',
            'Beasiswa',
            'Lomba',
            'Magang',
          ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: (v) {
            if (v == null) return;
            setState(() => _category = v);
            widget.onCategoryChanged?.call(v);
          },
        ),
      ],
    ),
  );
}
