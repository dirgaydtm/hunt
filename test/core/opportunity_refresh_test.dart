import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hunt/core/data/opportunity_providers.dart';
import 'package:hunt/core/data/opportunity_repository.dart';
import 'package:hunt/core/models/opportunity_model.dart';
import 'package:hunt/features/calendar/presentation/providers/calendar_provider.dart';

var calls = 0;

class _FakeRepository implements OpportunityRepository {
  @override
  Future<List<OpportunityModel>> getByEventMonth(DateTime month) async {
    calls++;
    return [];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('invalidating the repository refetches every list using it', () async {
    final container = ProviderContainer(
      overrides: [
        opportunityRepositoryProvider.overrideWith((ref) => _FakeRepository()),
      ],
    );
    addTearDown(container.dispose);
    final month = DateTime(2026, 10);
    container.listen(calendarMonthEventsProvider(month), (_, _) {});

    await container.read(calendarMonthEventsProvider(month).future);
    container.invalidate(opportunityRepositoryProvider);
    await container.read(calendarMonthEventsProvider(month).future);

    expect(calls, 2);
  });
}
