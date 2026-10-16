import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/opportunity_providers.dart';
import '../../../../core/models/opportunity_model.dart';

final homeRecommendationsProvider = FutureProvider<List<OpportunityModel>>(
  (ref) => ref.watch(opportunityRepositoryProvider).getRecommended(),
);

final homeRemindersProvider = FutureProvider<List<OpportunityModel>>(
  (ref) => ref.watch(opportunityRepositoryProvider).getUpcomingDeadlines(),
);
