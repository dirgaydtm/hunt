import '../../../home/data/models/opportunity_model.dart';
import '../services/bookmark_service.dart';

class BookmarkRepository {
  final BookmarkService _bookmarkService;

  const BookmarkRepository(this._bookmarkService);

  Future<List<OpportunityModel>> getBookmarks() {
    return _bookmarkService.getBookmarks();
  }
}
