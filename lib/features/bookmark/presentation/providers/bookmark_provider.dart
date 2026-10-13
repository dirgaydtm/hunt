import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/opportunity_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/supabase/supabase_provider.dart';
import '../../../../shared/data/opportunity_providers.dart';
import '../../../../shared/data/opportunity_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/bookmark_repository.dart';
import '../../data/services/bookmark_service.dart';

final bookmarkServiceProvider = Provider(
  (ref) => BookmarkService(ref.watch(supabaseClientProvider)),
);

final bookmarkRepositoryProvider = Provider((ref) {
  return BookmarkRepository(
    ref.watch(bookmarkServiceProvider),
    ref.watch(opportunityServiceProvider),
  );
});

/// The signed-in user's bookmarks, with optimistic add/remove.
class BookmarksNotifier extends AsyncNotifier<List<OpportunityModel>> {
  @override
  Future<List<OpportunityModel>> build() async {
    // Reload when the signed-in user changes.
    final userId = ref.watch(authProvider.select((a) => a.value?.id));
    if (userId == null) return [];
    return ref.watch(bookmarkRepositoryProvider).getBookmarks();
  }

  /// Returns an error message on failure, null on success.
  Future<String?> toggle(OpportunityModel opp) async {
    final previous = state.value ?? const <OpportunityModel>[];
    final wasBookmarked = previous.any((o) => o.id == opp.id);
    state = AsyncData(
      wasBookmarked
          ? previous.where((o) => o.id != opp.id).toList()
          : [opp, ...previous],
    );
    try {
      final repo = ref.read(bookmarkRepositoryProvider);
      wasBookmarked ? await repo.remove(opp.id) : await repo.add(opp.id);
      return null;
    } catch (e) {
      state = AsyncData(previous);
      return failureMessage(e);
    }
  }
}

final bookmarksProvider =
    AsyncNotifierProvider<BookmarksNotifier, List<OpportunityModel>>(
      BookmarksNotifier.new,
    );

final isBookmarkedProvider = Provider.family<bool, String>(
  (ref, id) =>
      ref.watch(bookmarksProvider).value?.any((o) => o.id == id) ?? false,
);

class BookmarkCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'Semua';

  void setCategory(String category) {
    state = category;
  }
}

final bookmarkCategoryProvider =
    NotifierProvider<BookmarkCategoryNotifier, String>(
      BookmarkCategoryNotifier.new,
    );

class BookmarkSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}

final bookmarkSearchQueryProvider =
    NotifierProvider<BookmarkSearchQueryNotifier, String>(
      BookmarkSearchQueryNotifier.new,
    );

/// Extra filters from the filter sheet (locations, date range).
class BookmarkFiltersNotifier extends Notifier<SearchFilters> {
  @override
  SearchFilters build() => const SearchFilters();

  void set(SearchFilters filters) => state = filters;
}

final bookmarkFiltersProvider =
    NotifierProvider<BookmarkFiltersNotifier, SearchFilters>(
      BookmarkFiltersNotifier.new,
    );

final filteredBookmarksProvider = Provider<AsyncValue<List<OpportunityModel>>>((
  ref,
) {
  final bookmarksAsync = ref.watch(bookmarksProvider);
  final filters = ref.watch(bookmarkFiltersProvider);
  final selectedCategory = ref.watch(bookmarkCategoryProvider);
  final searchQuery = ref.watch(bookmarkSearchQueryProvider).toLowerCase();

  return bookmarksAsync.whenData((bookmarks) {
    var filtered = bookmarks;

    filtered = filtered.where(filters.matches).toList();

    if (selectedCategory != 'Semua') {
      filtered = filtered
          .where(
            (item) =>
                item.category.toLowerCase() == selectedCategory.toLowerCase(),
          )
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (item) =>
                item.title.toLowerCase().contains(searchQuery) ||
                item.organizer.toLowerCase().contains(searchQuery),
          )
          .toList();
    }

    return filtered;
  });
});
