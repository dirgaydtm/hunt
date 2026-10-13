import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_time_extension.dart';
import '../../../../shared/constants/locations.dart';
import '../../../../shared/data/opportunity_providers.dart';
import '../../../../shared/models/opportunity_model.dart';
import '../../../../shared/widgets/hunt_button.dart';
import '../../../../shared/widgets/hunt_calendar.dart';
import '../../../../shared/widgets/hunt_text_field.dart';
import '../../../../shared/widgets/opportunity_image.dart';
import '../providers/admin_provider.dart';
import '../widgets/string_list_editor.dart';

/// Loads the opportunity for editing ([id] != null) or starts a new one.
class OpportunityFormPage extends ConsumerWidget {
  final String? id;
  final OpportunityModel? initial;

  const OpportunityFormPage({super.key, this.id, this.initial});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = this.id;
    if (id == null) return const _OpportunityForm();
    if (initial != null) return _OpportunityForm(existing: initial);

    final async = ref.watch(opportunityByIdProvider(id));
    return async.when(
      data: (o) => o == null
          ? const Scaffold(body: Center(child: Text('Peluang tidak ditemukan')))
          : _OpportunityForm(existing: o),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) =>
          const Scaffold(body: Center(child: Text('Gagal memuat peluang'))),
    );
  }
}

class _OpportunityForm extends ConsumerStatefulWidget {
  final OpportunityModel? existing;

  const _OpportunityForm({this.existing});

  @override
  ConsumerState<_OpportunityForm> createState() => _OpportunityFormState();
}

class _OpportunityFormState extends ConsumerState<_OpportunityForm> {
  final _formKey = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.existing?.title);
  late final _organizer = TextEditingController(
    text: widget.existing?.organizer,
  );
  late final _description = TextEditingController(
    text: widget.existing?.description,
  );
  late final _url = TextEditingController(
    text: widget.existing?.registrationUrl,
  );

  late String _category = widget.existing?.category ?? 'Beasiswa';
  late String? _location = widget.existing?.location;
  late List<String> _syarat = widget.existing?.syarat ?? [];
  late List<String> _berkas = widget.existing?.berkas ?? [];
  late List<String> _ketentuan = widget.existing?.ketentuan ?? [];
  late DateTime? _start = widget.existing?.startDate;
  late DateTime? _end = widget.existing?.endDate;
  late DateTime? _event = widget.existing?.eventDate;
  late bool _published = widget.existing?.isPublished ?? true;
  late bool _recommended = widget.existing?.isRecommended ?? false;
  PickedImage? _newImage;

  bool get _isNew => widget.existing == null;

  @override
  void dispose() {
    for (final c in [_title, _organizer, _description, _url]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _trimOrNull(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  void _snack(String text, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: error
            ? AppColors.redNormal
            : AppColors.blueNormalActive,
      ),
    );
  }

  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() => _newImage = (name: file.name, bytes: bytes));
  }

  Future<void> _pickRegistrationRange() async {
    final result = await showDialog<DateTimeRange>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: HuntCalendar(
            initialDateRange: _start != null && _end != null
                ? DateTimeRange(start: _start!, end: _end!)
                : null,
          ),
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _start = result.start;
        _end = result.end;
      });
    }
  }

  Future<void> _pickEventDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _event ?? _end ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _event = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final opp = OpportunityModel(
      id: widget.existing?.id ?? '',
      title: _title.text.trim(),
      organizer: _organizer.text.trim(),
      category: _category,
      location: _location,
      description: _trimOrNull(_description),
      syarat: _syarat,
      berkas: _berkas,
      ketentuan: _ketentuan,
      startDate: _start,
      endDate: _end,
      eventDate: _event,
      registrationUrl: _trimOrNull(_url),
      rawImagePath: widget.existing?.rawImagePath,
      isPublished: _published,
      isRecommended: _recommended,
    );
    final error = await ref
        .read(adminControllerProvider.notifier)
        .save(opp, isNew: _isNew, newImage: _newImage);
    if (!mounted) return;
    if (error != null) return _snack(error, error: true);
    _snack(_isNew ? 'Peluang ditambahkan.' : 'Perubahan disimpan.');
    context.pop();
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus peluang?'),
        content: Text(
          '"${widget.existing!.title}" beserta bookmark dan notifikasinya '
          'akan dihapus permanen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.redNormal),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final error = await ref
        .read(adminControllerProvider.notifier)
        .delete(widget.existing!.id);
    if (!mounted) return;
    if (error != null) return _snack(error, error: true);
    _snack('Peluang dihapus.');
    context.pop();
  }

  String _fmt(DateTime? d) =>
      d == null ? '-' : '${d.day} ${d.toMonthName()} ${d.year}';

  Widget _sectionTitle(String text) => Text(
    text,
    style: TextStyle(
      fontFamily: AppTextStyles.fontFamily,
      fontWeight: AppFontWeight.bold,
      color: AppColors.blueDarkActive,
    ),
  );

  Widget _imagePreview() {
    final existing = widget.existing?.imagePath;
    final ImageProvider? image = _newImage != null
        ? MemoryImage(_newImage!.bytes)
        : existing != null
        ? opportunityImage(existing)
        : null;
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: AppColors.blueLightHover,
          borderRadius: BorderRadius.circular(16),
          image: image == null
              ? null
              : DecorationImage(image: image, fit: BoxFit.cover),
        ),
        alignment: Alignment.center,
        child: image == null
            ? const Column(
                mainAxisSize: .min,
                children: [
                  Icon(Icons.add_photo_alternate_outlined, size: 40),
                  Text('Pilih gambar'),
                ],
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref.watch(adminControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _isNew ? 'Peluang Baru' : 'Edit Peluang',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: AppFontWeight.bold,
          ),
        ),
        actions: [
          if (!_isNew)
            IconButton(
              tooltip: 'Hapus',
              icon: const Icon(Icons.delete_outline),
              color: AppColors.redNormal,
              onPressed: saving ? null : _delete,
            ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const .all(24),
            children: [
              _imagePreview(),
              const SizedBox(height: 20),
              HuntTextField(
                label: 'Judul',
                hintText: 'Contoh: Beasiswa Unggulan',
                controller: _title,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              HuntTextField(
                label: 'Penyelenggara',
                hintText: 'Contoh: Kemendikbudristek',
                controller: _organizer,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              _sectionTitle('Kategori'),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: [
                  for (final c in opportunityCategories.values)
                    ButtonSegment(value: c, label: Text(c)),
                ],
                selected: {_category},
                onSelectionChanged: (s) => setState(() => _category = s.first),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _location,
                isExpanded: true,
                menuMaxHeight: 360,
                decoration: const InputDecoration(
                  labelText: 'Lokasi',
                  prefixIcon: Icon(Icons.place_outlined),
                  border: OutlineInputBorder(),
                ),
                items: [
                  // keep legacy values selectable so editing doesn't drop them
                  for (final loc in {
                    ...Locations.nationwide,
                    ...Locations.all,
                    ?_location,
                  })
                    DropdownMenuItem(value: loc, child: Text(loc)),
                ],
                onChanged: (v) => setState(() => _location = v),
              ),
              const SizedBox(height: 16),
              _sectionTitle('Deskripsi'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _description,
                minLines: 3,
                maxLines: 8,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Deskripsi singkat peluang ...',
                ),
              ),
              const SizedBox(height: 16),
              _sectionTitle('Tanggal'),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.date_range_outlined),
                title: const Text('Periode pendaftaran'),
                subtitle: Text('${_fmt(_start)} - ${_fmt(_end)}'),
                onTap: _pickRegistrationRange,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_outlined),
                title: const Text('Tanggal acara (kalender)'),
                subtitle: Text(_fmt(_event)),
                trailing: _event == null
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _event = null),
                      ),
                onTap: _pickEventDate,
              ),
              const SizedBox(height: 8),
              HuntTextField(
                label: 'Link Pendaftaran',
                hintText: 'https://...',
                prefixIcon: Icons.link,
                controller: _url,
                keyboardType: TextInputType.url,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  final uri = Uri.tryParse(v.trim());
                  return uri == null || !uri.hasScheme
                      ? 'Link harus diawali http:// atau https://'
                      : null;
                },
              ),
              const SizedBox(height: 24),
              StringListEditor(
                label: 'Syarat',
                initial: _syarat,
                onChanged: (v) => _syarat = v,
              ),
              const SizedBox(height: 16),
              StringListEditor(
                label: 'Berkas',
                initial: _berkas,
                onChanged: (v) => _berkas = v,
              ),
              const SizedBox(height: 16),
              StringListEditor(
                label: 'Ketentuan',
                initial: _ketentuan,
                onChanged: (v) => _ketentuan = v,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Publikasikan'),
                subtitle: const Text('Matikan untuk menyimpan sebagai draft'),
                value: _published,
                onChanged: (v) => setState(() => _published = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Tampilkan di Rekomendasi'),
                value: _recommended,
                onChanged: (v) => setState(() => _recommended = v),
              ),
              const SizedBox(height: 24),
              HuntButton(text: 'Simpan', isLoading: saving, onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
