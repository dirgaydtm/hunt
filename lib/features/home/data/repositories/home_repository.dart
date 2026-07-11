import '../models/opportunity_model.dart';
import '../services/home_service.dart';

class HomeRepository {
  final HomeService _homeService;

  const HomeRepository(this._homeService);

  Future<List<OpportunityModel>> getRecommendations() {
    return _homeService.getRecommendations();
  }

  Future<List<OpportunityModel>> getReminders() {
    return _homeService.getReminders();
  }

  Future<List<OpportunityModel>> getAllOpportunities() {
    return _homeService.getAllOpportunities();
  }
}
