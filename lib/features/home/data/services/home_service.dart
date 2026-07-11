import '../models/opportunity_model.dart';

class HomeService {
  // Simulate network delay
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 1200));
  }

  Future<List<OpportunityModel>> getRecommendations() async {
    await _simulateDelay();
    return const [
      OpportunityModel(
        title: 'Beasiswa Unggulan',
        organizer: 'Kemendikbudristek',
        postedAt: '2 h ago',
        category: 'Beasiswa',
        dateRange: '10 Agustus - 15 September 2026',
        imagePath: 'assets/mock/BeasiswaUnggulan.png',
        description:
            'Program beasiswa prestasi yang diselenggarakan oleh Kemendikbudristek. Penerima beasiswa akan dibekali berbagai pelatihan intensif guna membentuk generasi muda berkarakter, berintegritas, serta siap menjadi pemimpin masa depan bagi indonesia.',
        syarat: [
          'Mahasiswa aktif program S1 atau D4 yang sedang menempuh Semester IV.',
          'Berkuliah di Perguruan Tinggi mitra resmi.',
          'Memiliki IPK minimum 3.00 pada Semester III.',
          'Aktif mengikuti kegiatan organisasi, baik di dalam maupun di luar lingkungan kampus.',
        ],
        berkas: [
          'Scan Pas Foto digital ukuran 4x6 cm berwarna dengan memakai jas almamater kampus.',
          'Scan Kartu Tanda Mahasiswa (KTM) dan Kartu Tanda Penduduk (KTP).',
          'Scan Transkrip Nilai hingga Semester III yang telah dilegalisir oleh Fakultas/Universitas.',
          'Scan Surat Keterangan aktif berorganisasi dan/atau sertifikat prestasi yang pernah diraih.',
          'Scan Surat Keterangan dari kampus (Rektorat/Fakultas) menyatakan tidak sedang menerima beasiswa lain.',
        ],
        ketentuan: [
          'Terikat kontrak kepesertaan beasiswa selama 1 tahun penuh.',
          'Dilarang keras melakukan double-funding selama periode kontrak berjalan.',
          'Mahasiswa wajib mempertahankan IPK minimal 3.00 hingga akhir Semester IV.',
          'Wajib menghadiri dan mengikuti seluruh rangkaian pelatihan soft skills.',
          'Segala keputusan panitia seleksi bersifat mutlak, sah, dan tidak dapat diganggu gugat.',
        ],
      ),
      OpportunityModel(
        title: 'IT Fest 2026',
        organizer: 'KBMDSI FILKOM UB',
        postedAt: '3 days ago',
        category: 'Lomba',
        dateRange: '8 Juni - 8 Juli 2026',
        imagePath: 'assets/mock/ITfest.png',
        description:
            'IT Fest 2026 adalah perlombaan teknologi tahunan tingkat nasional yang diselenggarakan oleh KBMDSI FILKOM Universitas Brawijaya. Acara ini merupakan ajang unjuk gigi bagi para inovator muda dalam memecahkan masalah nyata melalui solusi digital kreatif.',
        syarat: [
          'Mahasiswa aktif D3/D4/S1 dari seluruh universitas di Indonesia.',
          'Satu tim terdiri dari maksimal 3 orang dari universitas yang sama.',
          'Karya yang dikumpulkan harus orisinil dan belum pernah dipublikasikan.',
          'Peserta wajib mengikuti akun media sosial resmi IT Fest 2026.',
        ],
        berkas: [
          'Scan Kartu Tanda Mahasiswa (KTM).',
          'Proposal ide atau inovasi dalam format PDF.',
          'Surat Pernyataan Orisinalitas Karya bermaterai.',
          'Bukti pembayaran biaya pendaftaran lomba.',
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
        postedAt: '1 week ago',
        category: 'Magang',
        dateRange: '20 Juli - 30 Agustus 2026',
        imagePath: 'assets/mock/KataAI.png',
        description:
            'Bergabunglah sebagai Backend Engineer Intern di Kata.ai! Kamu akan terlibat langsung dalam pengembangan dan pemeliharaan arsitektur backend untuk produk-produk kecerdasan buatan kami. Kesempatan emas untuk belajar dari engineer berpengalaman.',
        syarat: [
          'Mahasiswa tingkat akhir atau fresh graduate jurusan Ilmu Komputer/Teknologi Informasi.',
          'Memiliki pemahaman kuat tentang algoritma dan struktur data.',
          'Familiar dengan bahasa pemrograman seperti Go, Python, atau Node.js.',
          'Memiliki minat besar di bidang Artificial Intelligence dan Software Engineering.',
        ],
        berkas: [
          'Curriculum Vitae (CV) atau Resume terbaru.',
          'Transkrip Nilai akademik terakhir.',
          'Tautan portofolio atau repositori GitHub/GitLab.',
          'Surat Pengantar dari kampus (opsional).',
        ],
        ketentuan: [
          'Program magang berlangsung selama 3 hingga 6 bulan (penuh waktu).',
          'Wajib hadir di kantor (WFO) minimal 3 hari dalam seminggu.',
          'Peserta akan mendapatkan uang saku kompetitif per bulan.',
        ],
      ),
    ];
  }

  Future<List<OpportunityModel>> getReminders() async {
    await _simulateDelay();
    return const [
      OpportunityModel(
        title: 'Djarum Beasiswa Plus',
        organizer: 'Djarum Foundation',
        category: 'Beasiswa',
        dateRange: '1 November 2026 - 31 Oktober 2027',
        urgencyText: 'Tutup dalam 1 hari',
        imagePath: 'assets/mock/Djarum.png',
        description:
            'Djarum Beasiswa Plus merupakan program beasiswa prestasi yang diselenggarakan oleh Djarum Foundation sejak tahun 1984. Djarum Beasiswa Plus mengintegrasikan pencapaian akademik dengan kecakapan emosional dan sosial. Penerima beasiswa akan dibekali berbagai pelatihan soft skills intensif yang dirancang guna membentuk generasi muda berkarakter, berintegritas, serta siap menjadi pemimpin masa depan bagi indonesia.',
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
          'Scan Surat Keterangan aktif berorganisasi dan/atau sertifikat prestasi yang pernah diraih.',
          'Scan Surat Keterangan dari kampus (Rektorat/Fakultas) menyatakan tidak sedang menerima beasiswa lain.',
        ],
        ketentuan: [
          'Terikat kontrak kepesertaan beasiswa selama 1 tahun penuh (Periode 1 November 2026 - 31 Oktober 2027).',
          'Dilarang keras melakukan double-funding (menerima beasiswa dari pihak/instansi lain) selama periode kontrak berjalan.',
          'Mahasiswa wajib mempertahankan IPK minimal 3.00 hingga akhir Semester IV.',
          'Wajib menghadiri dan mengikuti seluruh rangkaian pelatihan soft skills yang diselenggarakan oleh Djarum Foundation.',
          'Segala keputusan panitia seleksi bersifat mutlak, sah, dan tidak dapat diganggu gugat.',
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
            'IT Fest 2026 adalah perlombaan teknologi tahunan tingkat nasional yang diselenggarakan oleh KBMDSI FILKOM Universitas Brawijaya. Acara ini merupakan ajang unjuk gigi bagi para inovator muda dalam memecahkan masalah nyata melalui solusi digital kreatif.',
        syarat: [
          'Mahasiswa aktif D3/D4/S1 dari seluruh universitas di Indonesia.',
          'Satu tim terdiri dari maksimal 3 orang dari universitas yang sama.',
          'Karya yang dikumpulkan harus orisinil dan belum pernah dipublikasikan.',
          'Peserta wajib mengikuti akun media sosial resmi IT Fest 2026.',
        ],
        berkas: [
          'Scan Kartu Tanda Mahasiswa (KTM).',
          'Proposal ide atau inovasi dalam format PDF.',
          'Surat Pernyataan Orisinalitas Karya bermaterai.',
          'Bukti pembayaran biaya pendaftaran lomba.',
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
            'Bergabunglah sebagai Backend Engineer Intern di Kata.ai! Kamu akan terlibat langsung dalam pengembangan dan pemeliharaan arsitektur backend untuk produk-produk kecerdasan buatan kami. Kesempatan emas untuk belajar dari engineer berpengalaman.',
        syarat: [
          'Mahasiswa tingkat akhir atau fresh graduate jurusan Ilmu Komputer/Teknologi Informasi.',
          'Memiliki pemahaman kuat tentang algoritma dan struktur data.',
          'Familiar dengan bahasa pemrograman seperti Go, Python, atau Node.js.',
          'Memiliki minat besar di bidang Artificial Intelligence dan Software Engineering.',
        ],
        berkas: [
          'Curriculum Vitae (CV) atau Resume terbaru.',
          'Transkrip Nilai akademik terakhir.',
          'Tautan portofolio atau repositori GitHub/GitLab.',
          'Surat Pengantar dari kampus (opsional).',
        ],
        ketentuan: [
          'Program magang berlangsung selama 3 hingga 6 bulan (penuh waktu).',
          'Wajib hadir di kantor (WFO) minimal 3 hari dalam seminggu.',
          'Peserta akan mendapatkan uang saku kompetitif per bulan.',
        ],
      ),
    ];
  }

  Future<List<OpportunityModel>> getAllOpportunities() async {
    await _simulateDelay();
    return const [
      OpportunityModel(
        title: 'Djarum Beasiswa Plus',
        organizer: 'Djarum Foundation',
        category: 'Beasiswa',
        dateRange: '1 November 2026 - 31 Oktober 2027',
        imagePath: 'assets/mock/Djarum.png',
        description:
            'Djarum Beasiswa Plus merupakan program beasiswa prestasi yang diselenggarakan oleh Djarum Foundation sejak tahun 1984. Djarum Beasiswa Plus mengintegrasikan pencapaian akademik dengan kecakapan emosional dan sosial. Penerima beasiswa akan dibekali berbagai pelatihan soft skills intensif yang dirancang guna membentuk generasi muda berkarakter, berintegritas, serta siap menjadi pemimpin masa depan bagi indonesia.',
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
          'Scan Surat Keterangan aktif berorganisasi dan/atau sertifikat prestasi yang pernah diraih.',
          'Scan Surat Keterangan dari kampus (Rektorat/Fakultas) menyatakan tidak sedang menerima beasiswa lain.',
        ],
        ketentuan: [
          'Terikat kontrak kepesertaan beasiswa selama 1 tahun penuh (Periode 1 November 2026 - 31 Oktober 2027).',
          'Dilarang keras melakukan double-funding (menerima beasiswa dari pihak/instansi lain) selama periode kontrak berjalan.',
          'Mahasiswa wajib mempertahankan IPK minimal 3.00 hingga akhir Semester IV.',
          'Wajib menghadiri dan mengikuti seluruh rangkaian pelatihan soft skills yang diselenggarakan oleh Djarum Foundation.',
          'Segala keputusan panitia seleksi bersifat mutlak, sah, dan tidak dapat diganggu gugat.',
        ],
      ),
      OpportunityModel(
        title: 'Beasiswa Unggulan',
        organizer: 'Kemendikbudristek',
        category: 'Beasiswa',
        dateRange: '8 Juni - 8 Juli 2026',
        imagePath: 'assets/mock/BeasiswaUnggulan.png',
        description:
            'Program beasiswa prestasi yang diselenggarakan oleh Kemendikbudristek. Penerima beasiswa akan dibekali berbagai pelatihan intensif guna membentuk generasi muda berkarakter, berintegritas, serta siap menjadi pemimpin masa depan bagi indonesia.',
        syarat: [
          'Mahasiswa aktif program S1 atau D4 yang sedang menempuh Semester IV.',
          'Berkuliah di Perguruan Tinggi mitra resmi.',
          'Memiliki IPK minimum 3.00 pada Semester III.',
          'Aktif mengikuti kegiatan organisasi, baik di dalam maupun di luar lingkungan kampus.',
        ],
        berkas: [
          'Scan Pas Foto digital ukuran 4x6 cm berwarna dengan memakai jas almamater kampus.',
          'Scan Kartu Tanda Mahasiswa (KTM) dan Kartu Tanda Penduduk (KTP).',
          'Scan Transkrip Nilai hingga Semester III yang telah dilegalisir oleh Fakultas/Universitas.',
          'Scan Surat Keterangan aktif berorganisasi dan/atau sertifikat prestasi yang pernah diraih.',
          'Scan Surat Keterangan dari kampus (Rektorat/Fakultas) menyatakan tidak sedang menerima beasiswa lain.',
        ],
        ketentuan: [
          'Terikat kontrak kepesertaan beasiswa selama 1 tahun penuh.',
          'Dilarang keras melakukan double-funding selama periode kontrak berjalan.',
          'Mahasiswa wajib mempertahankan IPK minimal 3.00 hingga akhir Semester IV.',
          'Wajib menghadiri dan mengikuti seluruh rangkaian pelatihan soft skills.',
          'Segala keputusan panitia seleksi bersifat mutlak, sah, dan tidak dapat diganggu gugat.',
        ],
      ),
      OpportunityModel(
        title: 'IT Fest 2026',
        organizer: 'KBMDSI FILKOM UB',
        category: 'Lomba',
        dateRange: '8 Juni - 8 Juli 2026',
        imagePath: 'assets/mock/ITfest.png',
        description:
            'IT Fest 2026 adalah perlombaan teknologi tahunan tingkat nasional yang diselenggarakan oleh KBMDSI FILKOM Universitas Brawijaya. Acara ini merupakan ajang unjuk gigi bagi para inovator muda dalam memecahkan masalah nyata melalui solusi digital kreatif.',
        syarat: [
          'Mahasiswa aktif D3/D4/S1 dari seluruh universitas di Indonesia.',
          'Satu tim terdiri dari maksimal 3 orang dari universitas yang sama.',
          'Karya yang dikumpulkan harus orisinil dan belum pernah dipublikasikan.',
          'Peserta wajib mengikuti akun media sosial resmi IT Fest 2026.',
        ],
        berkas: [
          'Scan Kartu Tanda Mahasiswa (KTM).',
          'Proposal ide atau inovasi dalam format PDF.',
          'Surat Pernyataan Orisinalitas Karya bermaterai.',
          'Bukti pembayaran biaya pendaftaran lomba.',
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
        imagePath: 'assets/mock/KataAI.png',
        description:
            'Bergabunglah sebagai Backend Engineer Intern di Kata.ai! Kamu akan terlibat langsung dalam pengembangan dan pemeliharaan arsitektur backend untuk produk-produk kecerdasan buatan kami. Kesempatan emas untuk belajar dari engineer berpengalaman.',
        syarat: [
          'Mahasiswa tingkat akhir atau fresh graduate jurusan Ilmu Komputer/Teknologi Informasi.',
          'Memiliki pemahaman kuat tentang algoritma dan struktur data.',
          'Familiar dengan bahasa pemrograman seperti Go, Python, atau Node.js.',
          'Memiliki minat besar di bidang Artificial Intelligence dan Software Engineering.',
        ],
        berkas: [
          'Curriculum Vitae (CV) atau Resume terbaru.',
          'Transkrip Nilai akademik terakhir.',
          'Tautan portofolio atau repositori GitHub/GitLab.',
          'Surat Pengantar dari kampus (opsional).',
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
