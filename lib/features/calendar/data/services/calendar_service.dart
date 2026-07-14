import '../../../home/data/models/opportunity_model.dart';

class CalendarService {
  List<OpportunityModel> getEvents() => [
    OpportunityModel(
      title: 'Djarum Beasiswa Plus',
      organizer: 'Djarum Foundation',
      category: 'Beasiswa',
      dateRange: '8 Juni - 8 Juli 2026',
      urgencyText: 'Tutup dalam 1hari',
      imagePath: 'assets/mock/BeasiswaUnggulan.png',
      eventDate: DateTime(2026, 7, 7),
    ),
    OpportunityModel(
      title: 'IT Fest 2026',
      organizer: 'KBMDSI FILKOM UB',
      category: 'Lomba',
      dateRange: '8 Juni - 8 Juli 2026',
      urgencyText: 'Tutup dalam 8jam',
      imagePath: 'assets/mock/ITfest.png',
      eventDate: DateTime(2026, 7, 16),
    ),
    OpportunityModel(
      title: 'Backend Engineer Intern',
      organizer: 'Kata.ai',
      category: 'Magang',
      dateRange: '1 Juli - 1 Agustus 2026',
      urgencyText: 'Tutup dalam 2hari',
      imagePath: null,
      eventDate: DateTime(2026, 7, 20),
    ),
    OpportunityModel(
      title: 'Djarum Beasiswa Plus',
      organizer: 'Djarum Foundation',
      category: 'Beasiswa',
      dateRange: '8 Juni - 8 Juli 2026',
      urgencyText: 'Tutup dalam 1hari',
      imagePath: 'assets/mock/BeasiswaUnggulan.png',
      eventDate: DateTime(2026, 7, 7),
    ),
  ];
}
