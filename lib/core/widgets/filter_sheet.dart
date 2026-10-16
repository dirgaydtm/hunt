import 'package:flutter/material.dart';

import '../constants/locations.dart';
import '../models/opportunity_model.dart';
import '../data/opportunity_repository.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/date_time_extension.dart';
import 'hunt_button.dart';
import 'hunt_calendar.dart';
import 'location_sheet.dart';

/// Pops a [SearchFilters] (keeping the initial query) when applied.
class FilterSheet extends StatefulWidget {
  final SearchFilters? initialFilters;

  const FilterSheet({super.key, this.initialFilters});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late var _f = widget.initialFilters ?? const SearchFilters();

  TextStyle _ts(double size, Color color, [FontWeight? weight]) => TextStyle(
    fontFamily: AppTextStyles.fontFamily,
    fontSize: size,
    fontWeight: weight,
    color: color,
  );

  void _set(SearchFilters f) => setState(() => _f = f);

  void _setLocations(List<String> locations) =>
      _set(_f.copyWith(locations: locations));

  void _toggleLocation(String location) => _setLocations(
    _f.locations.contains(location)
        ? _f.locations.where((l) => l != location).toList()
        : [..._f.locations, location],
  );

  Future<void> _pickLocations() async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          LocationSheet(initialSelectedLocations: _f.locations),
    );
    if (result != null) _setLocations(result);
  }

  Future<void> _pickDate() async {
    final result = await HuntCalendar.pickRange(context, _f.dateRange);
    if (result != null) _set(_f.copyWith(dateRange: () => result));
  }

  Widget _chip(
    String label,
    bool selected,
    VoidCallback onTap, {
    double fontSize = 12,
    double horizontalPadding = 8,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: .symmetric(horizontal: horizontalPadding, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? AppColors.blueDark : Colors.white,
        border: .all(
          color: selected ? AppColors.blueDark : AppColors.blueLightActive,
        ),
        borderRadius: .circular(48),
      ),
      child: Text(
        label,
        style: _ts(
          fontSize,
          selected ? Colors.white : AppColors.blueDark,
          selected ? AppFontWeight.semiBold : AppFontWeight.regular,
        ),
      ),
    ),
  );

  Widget _title(String text) =>
      Text(text, style: _ts(14, AppColors.blueDarker, AppFontWeight.bold));

  @override
  Widget build(BuildContext context) {
    final range = _f.dateRange;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .vertical(top: .circular(28)),
      ),
      padding: .only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: .fromLTRB(44, 12, 44, 16),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.greyLightDark,
                    borderRadius: .circular(10),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  SizedBox(width: 64),
                  Text(
                    'Filter',
                    style: _ts(
                      20,
                      AppColors.blueDarkActive,
                      AppFontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _set(SearchFilters(query: _f.query)),
                    child: Text(
                      'Reset',
                      style: _ts(14, AppColors.greyLightDarkActive),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              _title('Kategori'),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final cat in categoryFilters)
                    _chip(
                      cat,
                      _f.category == cat,
                      () => _set(_f.copyWith(category: cat)),
                    ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  _title('Lokasi'),
                  GestureDetector(
                    onTap: _pickLocations,
                    child: Row(
                      spacing: 4,
                      children: [
                        Text(
                          _f.locations.isEmpty
                              ? 'Semua'
                              : '${_f.locations.length} Terpilih',
                          style: _ts(14, AppColors.greyLightDarkActive),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: AppColors.greyLightDarkActive,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final loc in Locations.popular)
                    _chip(
                      loc,
                      _f.locations.contains(loc),
                      () => _toggleLocation(loc),
                      fontSize: 11,
                      horizontalPadding: 14,
                    ),
                ],
              ),
              SizedBox(height: 24),
              _title('Batas Waktu'),
              SizedBox(height: 12),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: .symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: .all(color: AppColors.blueLightActive),
                    borderRadius: .circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        range == null
                            ? 'Pilih Tanggal'
                            : range.start == range.end
                            ? range.start.toFormattedDate()
                            : '${range.start.toFormattedDate()} - ${range.end.toFormattedDate()}',
                        style: _ts(14, AppColors.greyDarkNormal),
                      ),
                      Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.blueLightActive,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              HuntButton(
                text: 'Terapkan',
                onPressed: () => Navigator.pop(context, _f),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
