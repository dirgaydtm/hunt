import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/data/opportunity_providers.dart';
import '../../../../shared/models/opportunity_model.dart';

final homeRecommendationsProvider = FutureProvider<List<OpportunityModel>>(
  (ref) => ref.watch(opportunityRepositoryProvider).getRecommended(),
);

final homeRemindersProvider = FutureProvider<List<OpportunityModel>>(
  (ref) => ref.watch(opportunityRepositoryProvider).getUpcomingDeadlines(),
);
