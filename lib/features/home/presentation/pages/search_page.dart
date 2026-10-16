import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/data/opportunity_providers.dart';
import '../../../../core/data/opportunity_repository.dart';
import '../../../../core/models/opportunity_model.dart';
import '../../../../core/widgets/filter_sheet.dart';
import '../../../../core/widgets/hunt_text_field.dart';
import '../../../../core/widgets/opportunity_card.dart';

class SearchPage extends ConsumerStatefulWidget {
  final SearchFilters initialFilters;

  const SearchPage({super.key, this.initialFilters = const SearchFilters()});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  late final TextEditingController _searchController;
  late SearchFilters _filters;
  Timer? _debounce;

  String get _query => _searchController.text;

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters;
    _searchController = TextEditingController(text: _filters.query);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    setState(() {}); // refresh the clear button
    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 350), () {
      setState(() => _filters = _filters.copyWith(query: value.trim()));
    });
  }

  void _showFilters() async {
    final result = await showModalBottomSheet<SearchFilters>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterSheet(initialFilters: _filters),
    );
    if (result == null) return;
    setState(() {
      var query = result.query;
      if (result.category != 'Semua') {
        query = result.category;
      } else if (opportunityCategories.containsValue(query)) {
        query = '';
      }
      _searchController.text = query;
      _filters = result.copyWith(query: query);
    });
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
            offset: Offset(0, 4),
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
              onChanged: _onQueryChanged,
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
                        _debounce?.cancel();
                        setState(() => _filters = _filters.copyWith(query: ''));
                      },
                    ),
                  IconButton(
                    icon: Icon(
                      Icons.tune_rounded,
                      color: _filters.hasFilters
                          ? AppColors.blueNormal
                          : AppColors.greyLightDark,
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

  Widget _buildContent(AsyncValue<List<OpportunityModel>> resultsAsync) {
    if (resultsAsync.hasError) {
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

    final isLoading = resultsAsync.isLoading && !resultsAsync.hasValue;
    return Skeletonizer(
      enabled: isLoading,
      child: Builder(
        builder: (context) {
          final filteredList = isLoading
              ? OpportunityModel.dummies
              : (resultsAsync.value ?? <OpportunityModel>[]);

          if (filteredList.isEmpty && !isLoading) {
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
            physics: BouncingScrollPhysics(),
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
                    context.push('/opportunity/${item.id}', extra: item);
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
                child: _buildContent(
                  ref.watch(searchResultsProvider(_filters)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
