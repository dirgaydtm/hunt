import '../../../home/data/models/opportunity_model.dart';
import '../services/calendar_service.dart';

class CalendarRepository {
  final CalendarService _service;
  CalendarRepository(this._service);

  List<OpportunityModel> getEvents() => _service.getEvents();
}
