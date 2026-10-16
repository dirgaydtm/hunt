import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../supabase/supabase_provider.dart';
import '../models/opportunity_model.dart';
import 'opportunity_repository.dart';

final opportunityRepositoryProvider = Provider(
  (ref) => OpportunityRepository(ref.watch(supabaseClientProvider)),
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
