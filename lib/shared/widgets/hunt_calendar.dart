import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_time_extension.dart';

class HuntCalendar extends StatefulWidget {
  final DateTimeRange? initialDateRange;
  final bool showCategoryFilter;
  final List<Map<String, dynamic>>? events;
  final Function(String)? onCategoryChanged;
  final String initialCategory;
  final RangeSelectionMode selectionMode;

  const HuntCalendar({
    super.key,
    this.initialDateRange,
    this.showCategoryFilter = false,
    this.events,
    this.onCategoryChanged,
    this.initialCategory = 'All',
    this.selectionMode = RangeSelectionMode.toggledOn,
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
    shape: BoxShape.circle,
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

  void _updateMonth(int offset) => setState(
    () => _currentMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + offset,
    ),
  );

  void _selectDates(DateTime? s, DateTime? e, DateTime focus) {
    setState(() {
      _start = s;
      _end = e;
      _currentMonth = focus;
    });

    if (s != null && e != null && !widget.showCategoryFilter) {
      final nav = Navigator.of(context);
      Future.delayed(Duration(milliseconds: 300), () {
        if (mounted) nav.pop(DateTimeRange(start: s, end: e));
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
    final content = SingleChildScrollView(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 24),
          _buildCalendar(),
          SizedBox(height: 24),
          _buildDateRangeDisplay(),
        ],
      ),
    );

    return widget.showCategoryFilter
        ? Column(
            children: [
              Expanded(child: content),
              _buildCategoryFilter(),
            ],
          )
        : content;
  }

  Widget _buildHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          shape: BoxShape.circle,
        ),
        child: IconButton(
          padding: .all(12),
          icon: Icon(
            Icons.notifications_rounded,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {},
        ),
      ),
    ],
  );

  Widget _buildCalendar() => TableCalendar(
    firstDay: DateTime.utc(2000, 1, 1),
    lastDay: DateTime.utc(2100, 12, 31),
    focusedDay: _currentMonth,
    headerVisible: false,
    daysOfWeekHeight: 40,
    startingDayOfWeek: StartingDayOfWeek.sunday,
    availableGestures: AvailableGestures.horizontalSwipe,
    onPageChanged: (d) => setState(() => _currentMonth = d),
    rangeSelectionMode: widget.selectionMode,
    rangeStartDay: _start,
    rangeEndDay: _end,
    onDaySelected: widget.selectionMode == RangeSelectionMode.toggledOff
        ? (s, f) => _selectDates(s, s, f)
        : null,
    onRangeSelected: widget.selectionMode == RangeSelectionMode.toggledOn
        ? _selectDates
        : null,
    eventLoader: _getEvents,
    calendarBuilders: CalendarBuilders(
      markerBuilder: (ctx, day, evs) {
        if (evs.isEmpty) return SizedBox();
        return Positioned.fill(
          child: Container(
            margin: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: (evs.first as Map)['gradient'],
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: _ts(16, AppFontWeight.bold, Colors.white),
            ),
          ),
        );
      },
      dowBuilder: (ctx, day) => Center(
        child: Text(
          ['S', 'M', 'T', 'W', 'T', 'F', 'S'][day.weekday % 7],
          style: _ts(16, AppFontWeight.bold, AppColors.orangeNormal),
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
      selectedTextStyle: _ts(16, AppFontWeight.bold, Colors.white),
      selectedDecoration: _gradCircle,
      todayDecoration: BoxDecoration(
        color: AppColors.blueNormal.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      rangeStartDecoration: _gradCircle,
      rangeEndDecoration: _gradCircle,
      rangeHighlightColor: AppColors.blueNormal.withValues(alpha: 0.1),
      withinRangeTextStyle: _ts(16, AppFontWeight.bold, AppColors.blueDark),
    ),
  );

  Widget _buildDateRangeDisplay() => Center(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.blueLightActive, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _start?.toFormattedDate() ?? 'Pilih',
            style: _ts(14, AppFontWeight.bold, AppColors.blueDarkActive),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('-', style: TextStyle(color: AppColors.blueDarkActive)),
          ),
          Text(
            _end?.toFormattedDate() ?? 'Tanggal',
            style: _ts(14, AppFontWeight.bold, AppColors.blueDarkActive),
          ),
        ],
      ),
    ),
  );

  Widget _buildCategoryFilter() => Container(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    decoration: BoxDecoration(
      color: AppColors.orangeNormal,
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Filter Kategori: ',
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
