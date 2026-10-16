import 'package:flutter/material.dart';

import '../constants/locations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'hunt_button.dart';
import 'hunt_text_field.dart';

class LocationSheet extends StatefulWidget {
  final List<String> initialSelectedLocations;

  const LocationSheet({super.key, required this.initialSelectedLocations});

  @override
  State<LocationSheet> createState() => _LocationSheetState();
}

class _LocationSheetState extends State<LocationSheet> {
  late final _selectedLocations = List.of(widget.initialSelectedLocations);
  late final _searchController = TextEditingController()
    ..addListener(() => setState(() {}));

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleLocation(String location) {
    setState(() {
      if (_selectedLocations.contains(location)) {
        _selectedLocations.remove(location);
      } else {
        _selectedLocations.add(location);
      }
    });
  }

  Widget _buildLocationChip(String location, double width) {
    final isSelected = _selectedLocations.contains(location);

    return SizedBox(
      width: width,
      child: InkWell(
        borderRadius: .circular(48),
        onTap: () => _toggleLocation(location),
        child: Container(
          padding: .symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blueDark : Colors.white,
            borderRadius: .circular(16),
            border: .all(
              color: isSelected
                  ? AppColors.blueDark
                  : AppColors.blueLightActive,
            ),
          ),
          child: Text(
            location,
            textAlign: .center,
            maxLines: 1,
            overflow: .ellipsis,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 13,
              fontWeight: isSelected
                  ? AppFontWeight.bold
                  : AppFontWeight.regular,
              color: isSelected ? Colors.white : AppColors.blueDark,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.toLowerCase();
    final filteredLocations = Locations.all
        .where((location) => location.toLowerCase().contains(query))
        .toList();

    return Container(
      height: MediaQuery.sizeOf(context).height * .85,
      padding: .symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .vertical(top: .circular(28)),
      ),
      child: Column(
        children: [
          SizedBox(height: 12),

          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.greyLightDark,
              borderRadius: .circular(10),
            ),
          ),

          SizedBox(height: 12),

          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: AppColors.blueDark),
              ),
              Text(
                'Lokasi',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 20,
                  fontWeight: AppFontWeight.extraBold,
                  color: AppColors.blueDarker,
                ),
              ),
              TextButton(
                onPressed: () => setState(_selectedLocations.clear),
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

          SizedBox(height: 16),

          Padding(
            padding: .symmetric(horizontal: 20),
            child: HuntTextField(
              controller: _searchController,
              hintText: 'Cari lokasi...',
              prefixIcon: Icons.search,
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: _searchController.clear,
                      icon: Icon(Icons.close),
                    ),
            ),
          ),

          SizedBox(height: 30),

          Expanded(
            child: SingleChildScrollView(
              padding: .symmetric(horizontal: 24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const spacing = 12.0;
                  final itemWidth = (constraints.maxWidth - spacing) / 2;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: 12,
                    children: filteredLocations
                        .map(
                          (location) => _buildLocationChip(location, itemWidth),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ),

          Padding(
            padding: .all(24),
            child: HuntButton(
              text: 'Konfirmasi',
              onPressed: () {
                Navigator.pop(context, _selectedLocations);
              },
            ),
          ),
        ],
      ),
    );
  }
}
