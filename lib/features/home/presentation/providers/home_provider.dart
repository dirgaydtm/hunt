import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/opportunity_model.dart';
import '../../data/services/home_service.dart';
import '../../data/repositories/home_repository.dart';

// Dependency Providers
final homeServiceProvider = Provider((ref) => HomeService());

final homeRepositoryProvider = Provider((ref) => HomeRepository(
      ref.watch(homeServiceProvider),
    ));

// State Providers (Idiomatic Async Data Fetching)
final homeRecommendationsProvider =
    FutureProvider<List<OpportunityModel>>((ref) async {
  return ref.watch(homeRepositoryProvider).getRecommendations();
});

final homeRemindersProvider =
    FutureProvider<List<OpportunityModel>>((ref) async {
  return ref.watch(homeRepositoryProvider).getReminders();
});

final homeAllOpportunitiesProvider =
    FutureProvider<List<OpportunityModel>>((ref) async {
  return ref.watch(homeRepositoryProvider).getAllOpportunities();
});
