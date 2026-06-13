import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/home/data/models/opportunity_model.dart';
import '../../data/repositories/bookmark_repository.dart';
import '../../data/services/bookmark_service.dart';

final bookmarkServiceProvider = Provider((ref) => BookmarkService());

final bookmarkRepositoryProvider = Provider((ref) {
  return BookmarkRepository(ref.watch(bookmarkServiceProvider));
});

// Provides a list of mock bookmarks loaded from BookmarkRepository.
final mockBookmarksProvider = FutureProvider<List<OpportunityModel>>((ref) {
  final repo = ref.watch(bookmarkRepositoryProvider);
  return repo.getBookmarks();
});

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

final filteredBookmarksProvider = Provider<AsyncValue<List<OpportunityModel>>>((
  ref,
) {
  final bookmarksAsync = ref.watch(mockBookmarksProvider);
  final selectedCategory = ref.watch(bookmarkCategoryProvider);
  final searchQuery = ref.watch(bookmarkSearchQueryProvider).toLowerCase();

  return bookmarksAsync.whenData((bookmarks) {
    var filtered = bookmarks;

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
