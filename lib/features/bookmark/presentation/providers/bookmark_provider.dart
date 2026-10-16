import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/opportunity_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/supabase/supabase_provider.dart';
import '../../../../core/data/opportunity_providers.dart';
import '../../../../core/data/opportunity_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/bookmark_repository.dart';

final bookmarkRepositoryProvider = Provider(
  (ref) => BookmarkRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(opportunityRepositoryProvider),
  ),
);

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
  final filters = ref.watch(bookmarkFiltersProvider);
  return ref
      .watch(bookmarksProvider)
      .whenData((bookmarks) => bookmarks.where(filters.matches).toList());
});
