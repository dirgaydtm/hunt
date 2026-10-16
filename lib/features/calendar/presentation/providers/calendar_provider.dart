import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/opportunity_providers.dart';
import '../../../../core/models/opportunity_model.dart';

/// All published events in the given month (any category).
final calendarMonthEventsProvider =
    FutureProvider.family<List<OpportunityModel>, DateTime>(
      (ref, month) =>
          ref.watch(opportunityRepositoryProvider).getByEventMonth(month),
    );
