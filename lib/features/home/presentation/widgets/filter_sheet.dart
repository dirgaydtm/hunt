import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_time_extension.dart';
import '../../../../shared/widgets/hunt_calendar.dart';
import '../constants/home_constants.dart';
import 'location_sheet.dart';
import '../../../../shared/widgets/hunt_button.dart';

class FilterSheet extends StatefulWidget {
  final Map<String, dynamic>? initialFilters;

  const FilterSheet({super.key, this.initialFilters});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  String _selectedCategory = 'Semua';
  List<String> _selectedLocations = [];
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    if (widget.initialFilters != null) {
      _selectedCategory = widget.initialFilters!['category'] ?? 'Semua';
      _selectedLocations = List<String>.from(
        widget.initialFilters!['locations'] ?? [],
      );
      _selectedDateRange = widget.initialFilters!['date'] as DateTimeRange?;
    }
  }

  void _showLocationSelector() async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          LocationSheet(initialSelectedLocations: _selectedLocations),
    );

    if (result != null) {
      setState(() {
        _selectedLocations = result;
      });
    }
  }

  void _togglePopularLocation(String location) {
    setState(() {
      if (_selectedLocations.contains(location)) {
        _selectedLocations.remove(location);
      } else {
        _selectedLocations.add(location);
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final result = await showDialog<DateTimeRange>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          child: HuntCalendar(initialDateRange: _selectedDateRange),
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedDateRange = result;
      });
    }
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    double fontSize = 12,
    double horizontalPadding = 8,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blueDark : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.blueDark : AppColors.blueLightActive,
          ),
          borderRadius: BorderRadius.circular(48),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: fontSize,
            fontWeight: isSelected
                ? AppFontWeight.semiBold
                : AppFontWeight.regular,
            color: isSelected ? Colors.white : AppColors.blueDark,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 44),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),

              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.greyLightDark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 64),
                  Text(
                    'Filter',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 20,
                      fontWeight: AppFontWeight.bold,
                      color: AppColors.blueDarkActive,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'Semua';
                        _selectedLocations.clear();
                        _selectedDateRange = null;
                      });
                    },
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 14,
                        color: AppColors.greyLightDarkActive,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kategori',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      fontWeight: AppFontWeight.bold,
                      color: AppColors.blueDarker,
                    ),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Semua', 'Beasiswa', 'Lomba', 'Magang'].map((
                      cat,
                    ) {
                      return _buildFilterChip(
                        label: cat,
                        isSelected: _selectedCategory == cat,
                        onTap: () => setState(() => _selectedCategory = cat),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 24),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lokasi',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14,
                          fontWeight: AppFontWeight.bold,
                          color: AppColors.blueDarker,
                        ),
                      ),
                      GestureDetector(
                        onTap: _showLocationSelector,
                        child: Row(
                          children: [
                            Text(
                              _selectedLocations.isEmpty
                                  ? 'Semua'
                                  : '${_selectedLocations.length} Terpilih',
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 14,
                                color: AppColors.greyLightDarkActive,
                              ),
                            ),
                            SizedBox(width: 4),
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
                    children: HomeConstants.popularLocations.map((loc) {
                      return _buildFilterChip(
                        label: loc,
                        isSelected: _selectedLocations.contains(loc),
                        onTap: () => _togglePopularLocation(loc),
                        fontSize: 11,
                        horizontalPadding: 14,
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 24),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Batas Waktu',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      fontWeight: AppFontWeight.bold,
                      color: AppColors.blueDarker,
                    ),
                  ),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.blueLightActive),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedDateRange != null
                                ? (_selectedDateRange!.start ==
                                          _selectedDateRange!.end
                                      ? _selectedDateRange!.start
                                            .toFormattedDate()
                                      : '${_selectedDateRange!.start.toFormattedDate()} - ${_selectedDateRange!.end.toFormattedDate()}')
                                : 'Pilih Tanggal',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 14,
                              color: AppColors.greyDarkNormal,
                            ),
                          ),
                          Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.blueLightActive,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              HuntButton(
                text: 'Terapkan',
                onPressed: () {
                  Navigator.pop(context, {
                    'category': _selectedCategory,
                    'locations': _selectedLocations,
                    'date': _selectedDateRange,
                  });
                },
              ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
