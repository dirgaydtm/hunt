import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/data/opportunity_repository.dart';
import '../../../../core/widgets/category_tag.dart';
import '../providers/admin_provider.dart';

class AdminPage extends ConsumerStatefulWidget {
  const AdminPage({super.key});

  @override
  ConsumerState<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage> {
  var _filters = const SearchFilters();

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(adminOpportunitiesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Panel Admin',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: AppFontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Kelola pengguna',
            icon: const Icon(Icons.people_outline),
            onPressed: () => context.push('/admin/users'),
          ),
          IconButton(
            tooltip: 'Broadcast notifikasi',
            icon: const Icon(Icons.campaign_outlined),
            onPressed: () => context.push('/admin/broadcast'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.blueNormal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Peluang Baru'),
        onPressed: () => context.push('/admin/opportunities/new'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const .fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari judul atau penyelenggara ...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) =>
                  setState(() => _filters = SearchFilters(query: v.trim())),
            ),
          ),
          Expanded(
            child: async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  const Center(child: Text('Gagal memuat peluang')),
              data: (all) {
                final items = all.where(_filters.matches).toList();
                if (items.isEmpty) {
                  return const Center(child: Text('Belum ada peluang'));
                }
                return RefreshIndicator(
                  onRefresh: () =>
                      ref.refresh(adminOpportunitiesProvider.future),
                  child: ListView.separated(
                    padding: const .only(bottom: 96),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final o = items[i];
                      return ListTile(
                        title: Text(o.title),
                        subtitle: Text(
                          [
                            o.organizer,
                            if (o.dateRange != null) o.dateRange!,
                          ].join(' · '),
                        ),
                        leading: CategoryTag(category: o.category),
                        trailing: Row(
                          mainAxisSize: .min,
                          children: [
                            if (o.isRecommended)
                              const Icon(
                                Icons.star_rounded,
                                color: AppColors.yellowDark,
                              ),
                            if (!o.isPublished)
                              const Chip(
                                label: Text('Draft'),
                                visualDensity: .compact,
                              ),
                          ],
                        ),
                        onTap: () => context.push(
                          '/admin/opportunities/${o.id}/edit',
                          extra: o,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
