import '../../../../core/data/opportunity_service.dart';
import '../../../../core/models/opportunity_model.dart';
import '../services/bookmark_service.dart';

class BookmarkRepository {
  final BookmarkService _bookmarkService;
  final OpportunityService _opportunityService;

  const BookmarkRepository(this._bookmarkService, this._opportunityService);

  Future<List<OpportunityModel>> getBookmarks() async {
    final rows = await _bookmarkService.getMine();
    return rows
        .map(
          (r) => OpportunityModel.fromJson(
            r,
            resolveImage: _opportunityService.publicImageUrl,
          ),
        )
        .toList();
  }

  Future<void> add(String opportunityId) => _bookmarkService.add(opportunityId);

  Future<void> remove(String opportunityId) =>
      _bookmarkService.remove(opportunityId);
}
