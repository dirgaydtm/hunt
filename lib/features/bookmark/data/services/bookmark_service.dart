import '../../../home/data/models/opportunity_model.dart';

class BookmarkService {
  Future<List<OpportunityModel>> getBookmarks() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return const [
      OpportunityModel(
        title: 'Djarum Beasiswa Plus',
        organizer: 'Djarum Foundation',
        category: 'Beasiswa',
        dateRange: '1 November 2026 - 31 Oktober 2027',
        urgencyText: 'Tutup dalam 1 hari',
        imagePath: 'assets/mock/Djarum.png',
        description:
            'Djarum Beasiswa Plus merupakan program beasiswa prestasi yang diselenggarakan oleh Djarum Foundation sejak tahun 1984. Djarum Beasiswa Plus mengintegrasikan pencapaian akademik dengan kecakapan emosional dan sosial.',
        syarat: [
          'Mahasiswa aktif program S1 atau D4 yang sedang menempuh Semester IV.',
          'Berkuliah di Perguruan Tinggi mitra resmi Djarum Foundation.',
          'Memiliki IPK minimum 3.00 pada Semester III.',
          'Aktif mengikuti kegiatan organisasi, baik di dalam maupun di luar lingkungan kampus.',
        ],
        berkas: [
          'Scan Pas Foto digital ukuran 4x6 cm berwarna dengan memakai jas almamater kampus.',
          'Scan Kartu Tanda Mahasiswa (KTM) dan Kartu Tanda Penduduk (KTP).',
          'Scan Transkrip Nilai hingga Semester III yang telah dilegalisir oleh Fakultas/Universitas.',
        ],
        ketentuan: [
          'Terikat kontrak kepesertaan beasiswa selama 1 tahun penuh.',
          'Dilarang keras melakukan double-funding.',
          'Mahasiswa wajib mempertahankan IPK minimal 3.00 hingga akhir Semester IV.',
        ],
      ),
      OpportunityModel(
        title: 'IT Fest 2026',
        organizer: 'KBMDSI FILKOM UB',
        category: 'Lomba',
        dateRange: '8 Juni - 8 Juli 2026',
        urgencyText: 'Tutup dalam 8 jam',
        imagePath: 'assets/mock/ITfest.png',
        description:
            'IT Fest 2026 adalah perlombaan teknologi tahunan tingkat nasional yang diselenggarakan oleh KBMDSI FILKOM Universitas Brawijaya.',
        syarat: [
          'Mahasiswa aktif D3/D4/S1 dari seluruh universitas di Indonesia.',
          'Satu tim terdiri dari maksimal 3 orang dari universitas yang sama.',
          'Karya yang dikumpulkan harus orisinil dan belum pernah dipublikasikan.',
        ],
        berkas: [
          'Scan Kartu Tanda Mahasiswa (KTM).',
          'Proposal ide atau inovasi dalam format PDF.',
          'Surat Pernyataan Orisinalitas Karya bermaterai.',
        ],
        ketentuan: [
          'Setiap tim hanya diperbolehkan mengirimkan satu karya.',
          'Keputusan dewan juri bersifat final dan tidak dapat diganggu gugat.',
          'Peserta yang terbukti melakukan plagiarisme akan didiskualifikasi.',
        ],
      ),
      OpportunityModel(
        title: 'Backend Engineer Intern',
        organizer: 'Kata.ai',
        category: 'Magang',
        dateRange: '20 Juli - 30 Agustus 2026',
        urgencyText: 'Tutup dalam 2 hari',
        imagePath: 'assets/mock/KataAI.png',
        description:
            'Bergabunglah sebagai Backend Engineer Intern di Kata.ai! Kamu akan terlibat langsung dalam pengembangan dan pemeliharaan arsitektur backend untuk produk-produk kecerdasan buatan kami.',
        syarat: [
          'Mahasiswa tingkat akhir atau fresh graduate jurusan Ilmu Komputer/Teknologi Informasi.',
          'Memiliki pemahaman kuat tentang algoritma dan struktur data.',
          'Familiar dengan bahasa pemrograman seperti Go, Python, atau Node.js.',
        ],
        berkas: [
          'Curriculum Vitae (CV) atau Resume terbaru.',
          'Transkrip Nilai akademik terakhir.',
          'Tautan portofolio atau repositori GitHub/GitLab.',
        ],
        ketentuan: [
          'Program magang berlangsung selama 3 hingga 6 bulan (penuh waktu).',
          'Wajib hadir di kantor (WFO) minimal 3 hari dalam seminggu.',
          'Peserta akan mendapatkan uang saku kompetitif per bulan.',
        ],
      ),
    ];
  }
}
