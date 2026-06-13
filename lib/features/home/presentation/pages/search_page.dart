import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/hunt_text_field.dart';
import '../../../../shared/widgets/opportunity_card.dart';
import '../../data/models/opportunity_model.dart';
import '../providers/home_provider.dart';
import '../../../../shared/widgets/filter_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchPage extends ConsumerStatefulWidget {
  final String initialQuery;

  const SearchPage({super.key, required this.initialQuery});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  late TextEditingController _searchController;
  late String _query;
  Map<String, dynamic>? _appliedFilters;

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    _searchController = TextEditingController(text: _query);
    if (const ['beasiswa', 'lomba', 'magang'].contains(_query.toLowerCase())) {
      _appliedFilters = {
        'category': _query,
        'locations': <String>[],
        'date': DateTime(2026, 7, 9),
      };
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilters() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterSheet(initialFilters: _appliedFilters),
    );

    if (result != null) {
      setState(() {
        _appliedFilters = result;
        final selectedCat = result['category'] as String;
        if (selectedCat != 'Semua') {
          _query = selectedCat;
          _searchController.text = selectedCat;
        } else if (_query == 'Beasiswa' ||
            _query == 'Lomba' ||
            _query == 'Magang') {
          _query = '';
          _searchController.text = '';
        }
      });
    }
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: .symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.greyLightDark.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.blueDarkActive),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 8),
          Expanded(
            child: HuntTextField(
              controller: _searchController,
              hintText: 'Cari peluang ...',
              onChanged: (val) => setState(() => _query = val),
              suffixIcon: Row(
                mainAxisSize: .min,
                mainAxisAlignment: .end,
                children: [
                  if (_query.isNotEmpty)
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: AppColors.greyLightDark,
                        size: 18,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    ),
                  IconButton(
                    icon: Icon(
                      Icons.tune_rounded,
                      color: AppColors.greyLightDark,
                      size: 18,
                    ),
                    onPressed: _showFilters,
                  ),
                  SizedBox(width: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AsyncValue<List<OpportunityModel>> allOppsAsync) {
    if (allOppsAsync.hasError) {
      return Center(
        child: Text(
          'Gagal memuat peluang',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            color: AppColors.greyDarkNormal,
          ),
        ),
      );
    }

    return Skeletonizer(
      enabled: allOppsAsync.isLoading,
      child: Builder(
        builder: (context) {
          final allOpportunities = allOppsAsync.isLoading
              ? OpportunityModel.dummies
              : (allOppsAsync.value ?? []);

          final filteredList = allOppsAsync.isLoading
              ? allOpportunities
              : allOpportunities.where((opp) {
                  final q = _query.toLowerCase();
                  final matchQuery =
                      q.isEmpty ||
                      opp.title.toLowerCase().contains(q) ||
                      opp.organizer.toLowerCase().contains(q) ||
                      opp.category.toLowerCase().contains(q);

                  final matchFilter =
                      _appliedFilters == null ||
                      ((_appliedFilters!['category'] == 'Semua' ||
                              opp.category == _appliedFilters!['category']) &&
                          (_appliedFilters!['locations'].isEmpty ||
                              _appliedFilters!['locations'].any(
                                (loc) =>
                                    opp.title.toLowerCase().contains(loc) ||
                                    opp.organizer.toLowerCase().contains(loc),
                              )));

                  return matchQuery && matchFilter;
                }).toList();

          if (filteredList.isEmpty && !allOppsAsync.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 64,
                    color: AppColors.greyLightDark,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Peluang tidak ditemukan',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 16,
                      fontWeight: AppFontWeight.bold,
                      color: AppColors.greyLightDarkActive,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: filteredList.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = filteredList[index];
              return Padding(
                padding: .only(bottom: 16),
                child: OpportunityCard(
                  title: item.title,
                  organizer: item.organizer,
                  category: item.category,
                  dateRange: item.dateRange,
                  imagePath: item.imagePath,
                  hasBackground: false,
                  onTap: () {
                    context.push('/detail', extra: item);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: .symmetric(horizontal: 32),
          child: Column(
            children: [
              _buildSearchHeader(),
              SizedBox(height: 8),
              Expanded(
                child: _buildContent(ref.watch(homeAllOpportunitiesProvider)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
