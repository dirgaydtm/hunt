import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/data/models/opportunity_model.dart';
import '../../data/repositories/calendar_repository.dart';
import '../../data/services/calendar_service.dart';

final calendarServiceProvider = Provider((_) => CalendarService());

final calendarRepositoryProvider = Provider(
  (ref) => CalendarRepository(ref.watch(calendarServiceProvider)),
);

final allCalendarEventsProvider = Provider<List<OpportunityModel>>(
  (ref) => ref.watch(calendarRepositoryProvider).getEvents(),
);

// Holds the current selected category
class CalendarCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'All';
  void setCategory(String c) => state = c;
}

final calendarCategoryProvider =
    NotifierProvider<CalendarCategoryNotifier, String>(
      CalendarCategoryNotifier.new,
    );

// Returns events filtered by category, for a given month
final filteredCalendarEventsProvider =
    Provider.family<List<OpportunityModel>, DateTime>((ref, month) {
      final all = ref.watch(allCalendarEventsProvider);
      final cat = ref.watch(calendarCategoryProvider);
      return all.where((e) {
        final d = e.eventDate;
        if (d == null) return false;
        final inMonth = d.year == month.year && d.month == month.month;
        final inCat = cat == 'All' || e.category == cat;
        return inMonth && inCat;
      }).toList();
    });

// Returns calendar marker events (for dot/circle on calendar days)
List<Map<String, dynamic>> toCalendarMarkers(
  List<OpportunityModel> events,
) => events
    .map((e) => {'date': e.eventDate, 'category': e.category, 'title': e.title})
    .toList();
