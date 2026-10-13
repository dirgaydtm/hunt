import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/supabase/supabase_provider.dart';
import '../models/opportunity_model.dart';
import 'opportunity_repository.dart';
import 'opportunity_service.dart';

final opportunityServiceProvider = Provider(
  (ref) => OpportunityService(ref.watch(supabaseClientProvider)),
);

final opportunityRepositoryProvider = Provider(
  (ref) => OpportunityRepository(ref.watch(opportunityServiceProvider)),
);

final opportunityByIdProvider =
    FutureProvider.family<OpportunityModel?, String>(
      (ref, id) => ref.watch(opportunityRepositoryProvider).getById(id),
    );

final searchResultsProvider =
    FutureProvider.family<List<OpportunityModel>, SearchFilters>(
      (ref, filters) =>
          ref.watch(opportunityRepositoryProvider).search(filters),
    );
