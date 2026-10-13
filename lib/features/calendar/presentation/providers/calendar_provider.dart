import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/data/opportunity_providers.dart';
import '../../../../shared/models/opportunity_model.dart';

/// All published events in the given month (any category).
final calendarMonthEventsProvider =
    FutureProvider.family<List<OpportunityModel>, DateTime>(
      (ref, month) =>
          ref.watch(opportunityRepositoryProvider).getByEventMonth(month),
    );

class CalendarCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'Semua';
  void setCategory(String c) => state = c;
}

final calendarCategoryProvider =
    NotifierProvider<CalendarCategoryNotifier, String>(
      CalendarCategoryNotifier.new,
    );
