-- Seed data migrated from the old mock services.
-- Dates are relative to the seed day so the app always has live data.
-- image_path values starting with "assets/" are bundled app assets;
-- anything else is a path inside the "opportunity-images" bucket.

insert into public.opportunities
  (title, organizer, category, location, description, requirements, documents, terms,
   start_date, end_date, event_date, registration_url, image_path, is_recommended)
values
(
  'Beasiswa Unggulan', 'Kemendikbudristek', 'beasiswa', 'Nasional',
  'Program beasiswa prestasi yang diselenggarakan oleh Kemendikbudristek. Penerima beasiswa akan dibekali berbagai pelatihan intensif guna membentuk generasi muda berkarakter, berintegritas, serta siap menjadi pemimpin masa depan bagi indonesia.',
  array[
    'Mahasiswa aktif program S1 atau D4 yang sedang menempuh Semester IV.',
    'Berkuliah di Perguruan Tinggi mitra resmi.',
    'Memiliki IPK minimum 3.00 pada Semester III.',
    'Aktif mengikuti kegiatan organisasi, baik di dalam maupun di luar lingkungan kampus.'
  ],
  array[
    'Scan Pas Foto digital ukuran 4x6 cm berwarna dengan memakai jas almamater kampus.',
    'Scan Kartu Tanda Mahasiswa (KTM) dan Kartu Tanda Penduduk (KTP).',
    'Scan Transkrip Nilai hingga Semester III yang telah dilegalisir oleh Fakultas/Universitas.',
    'Scan Surat Keterangan aktif berorganisasi dan/atau sertifikat prestasi yang pernah diraih.',
    'Scan Surat Keterangan dari kampus (Rektorat/Fakultas) menyatakan tidak sedang menerima beasiswa lain.'
  ],
  array[
    'Terikat kontrak kepesertaan beasiswa selama 1 tahun penuh.',
    'Dilarang keras melakukan double-funding selama periode kontrak berjalan.',
    'Mahasiswa wajib mempertahankan IPK minimal 3.00 hingga akhir Semester IV.',
    'Wajib menghadiri dan mengikuti seluruh rangkaian pelatihan soft skills.',
    'Segala keputusan panitia seleksi bersifat mutlak, sah, dan tidak dapat diganggu gugat.'
  ],
  current_date - 5, current_date + 20, current_date + 20,
  'https://beasiswaunggulan.kemdikbud.go.id', 'assets/mock/BeasiswaUnggulan.png', true
),
(
  'IT Fest 2026', 'KBMDSI FILKOM UB', 'lomba', 'Malang',
  'IT Fest 2026 adalah perlombaan teknologi tahunan tingkat nasional yang diselenggarakan oleh KBMDSI FILKOM Universitas Brawijaya. Acara ini merupakan ajang unjuk gigi bagi para inovator muda dalam memecahkan masalah nyata melalui solusi digital kreatif.',
  array[
    'Mahasiswa aktif D3/D4/S1 dari seluruh universitas di Indonesia.',
    'Satu tim terdiri dari maksimal 3 orang dari universitas yang sama.',
    'Karya yang dikumpulkan harus orisinil dan belum pernah dipublikasikan.',
    'Peserta wajib mengikuti akun media sosial resmi IT Fest 2026.'
  ],
  array[
    'Scan Kartu Tanda Mahasiswa (KTM).',
    'Proposal ide atau inovasi dalam format PDF.',
    'Surat Pernyataan Orisinalitas Karya bermaterai.',
    'Bukti pembayaran biaya pendaftaran lomba.'
  ],
  array[
    'Setiap tim hanya diperbolehkan mengirimkan satu karya.',
    'Keputusan dewan juri bersifat final dan tidak dapat diganggu gugat.',
    'Peserta yang terbukti melakukan plagiarisme akan didiskualifikasi.'
  ],
  current_date - 14, current_date + 2, current_date + 12,
  null, 'assets/mock/ITfest.png', true
),
(
  'Backend Engineer Intern', 'Kata.ai', 'magang', 'Jakarta',
  'Bergabunglah sebagai Backend Engineer Intern di Kata.ai! Kamu akan terlibat langsung dalam pengembangan dan pemeliharaan arsitektur backend untuk produk-produk kecerdasan buatan kami. Kesempatan emas untuk belajar dari engineer berpengalaman.',
  array[
    'Mahasiswa tingkat akhir atau fresh graduate jurusan Ilmu Komputer/Teknologi Informasi.',
    'Memiliki pemahaman kuat tentang algoritma dan struktur data.',
    'Familiar dengan bahasa pemrograman seperti Go, Python, atau Node.js.',
    'Memiliki minat besar di bidang Artificial Intelligence dan Software Engineering.'
  ],
  array[
    'Curriculum Vitae (CV) atau Resume terbaru.',
    'Transkrip Nilai akademik terakhir.',
    'Tautan portofolio atau repositori GitHub/GitLab.',
    'Surat Pengantar dari kampus (opsional).'
  ],
  array[
    'Program magang berlangsung selama 3 hingga 6 bulan (penuh waktu).',
    'Wajib hadir di kantor (WFO) minimal 3 hari dalam seminggu.',
    'Peserta akan mendapatkan uang saku kompetitif per bulan.'
  ],
  current_date - 3, current_date + 9, current_date + 30,
  null, 'assets/mock/KataAI.png', true
),
(
  'Djarum Beasiswa Plus', 'Djarum Foundation', 'beasiswa', 'Nasional',
  'Djarum Beasiswa Plus merupakan program beasiswa prestasi yang diselenggarakan oleh Djarum Foundation sejak tahun 1984. Djarum Beasiswa Plus mengintegrasikan pencapaian akademik dengan kecakapan emosional dan sosial. Penerima beasiswa akan dibekali berbagai pelatihan soft skills intensif yang dirancang guna membentuk generasi muda berkarakter, berintegritas, serta siap menjadi pemimpin masa depan bagi indonesia.',
  array[
    'Mahasiswa aktif program S1 atau D4 yang sedang menempuh Semester IV.',
    'Berkuliah di Perguruan Tinggi mitra resmi Djarum Foundation.',
    'Memiliki IPK minimum 3.00 pada Semester III.',
    'Aktif mengikuti kegiatan organisasi, baik di dalam maupun di luar lingkungan kampus.'
  ],
  array[
    'Scan Pas Foto digital ukuran 4x6 cm berwarna dengan memakai jas almamater kampus.',
    'Scan Kartu Tanda Mahasiswa (KTM) dan Kartu Tanda Penduduk (KTP).',
    'Scan Transkrip Nilai hingga Semester III yang telah dilegalisir oleh Fakultas/Universitas.',
    'Scan Surat Keterangan aktif berorganisasi dan/atau sertifikat prestasi yang pernah diraih.',
    'Scan Surat Keterangan dari kampus (Rektorat/Fakultas) menyatakan tidak sedang menerima beasiswa lain.'
  ],
  array[
    'Terikat kontrak kepesertaan beasiswa selama 1 tahun penuh.',
    'Dilarang keras melakukan double-funding (menerima beasiswa dari pihak/instansi lain) selama periode kontrak berjalan.',
    'Mahasiswa wajib mempertahankan IPK minimal 3.00 hingga akhir Semester IV.',
    'Wajib menghadiri dan mengikuti seluruh rangkaian pelatihan soft skills yang diselenggarakan oleh Djarum Foundation.',
    'Segala keputusan panitia seleksi bersifat mutlak, sah, dan tidak dapat diganggu gugat.'
  ],
  current_date - 10, current_date + 1, current_date + 1,
  'https://djarumbeasiswaplus.org', 'assets/mock/Djarum.png', false
);
