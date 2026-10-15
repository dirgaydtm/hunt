import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/category_tag.dart';
import '../../../../shared/widgets/hunt_accordion.dart';
import '../../../../shared/widgets/hunt_button.dart';
import '../../../../shared/data/opportunity_providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../bookmark/presentation/providers/bookmark_provider.dart';
import '../../../../shared/models/opportunity_model.dart';
import '../../../../shared/widgets/opportunity_image.dart';

/// Loads the opportunity by id. [initial] (passed from a list) is shown
/// immediately while the fresh copy loads.
class OpportunityDetailPage extends ConsumerWidget {
  final String id;
  final OpportunityModel? initial;

  const OpportunityDetailPage({super.key, required this.id, this.initial});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(opportunityByIdProvider(id));
    final opportunity = async.value ?? initial;
    if (opportunity != null) {
      return _OpportunityDetailView(opportunity: opportunity);
    }
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: async.isLoading
            ? const CircularProgressIndicator()
            : const Text('Peluang tidak ditemukan'),
      ),
    );
  }
}

class _OpportunityDetailView extends StatelessWidget {
  final OpportunityModel opportunity;

  const _OpportunityDetailView({required this.opportunity});

  Future<void> _toggleBookmark(BuildContext context, WidgetRef ref) async {
    final error = await ref
        .read(bookmarksProvider.notifier)
        .toggle(opportunity);
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.redNormal),
      );
    }
  }

  void _share(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    SharePlus.instance.share(
      ShareParams(
        subject: opportunity.title,
        text: [
          '${opportunity.title} — ${opportunity.organizer}',
          if (opportunity.dateRange != null) opportunity.dateRange!,
          if (opportunity.registrationUrl != null) opportunity.registrationUrl!,
          'Temukan peluang lainnya di Hunt!',
        ].join('\n'),
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }

  Future<void> _openRegistration(BuildContext context) async {
    final url = opportunity.registrationUrl;
    final uri = url == null ? null : Uri.tryParse(url);
    final opened =
        uri != null &&
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Link pendaftaran belum tersedia.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            _buildHeader(context),
            Padding(
              padding: .all(40),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      CategoryTag(category: opportunity.category),
                      if (opportunity.dateRange != null)
                        Text(
                          opportunity.dateRange!,
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 12,
                            color: AppColors.greyLightDarkActive,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    opportunity.title,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 24,
                      fontWeight: AppFontWeight.extraBold,
                      color: AppColors.greyDarkNormal,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    opportunity.organizer,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 16,
                      color: AppColors.greyLightDarkActive,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Divider(
                    height: 1,
                    color: AppColors.blueLightActive.withValues(alpha: 0.5),
                  ),
                  SizedBox(height: 22),
                  if (opportunity.description != null) ...[
                    Text(
                      'Deskripsi',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 14,
                        fontWeight: AppFontWeight.bold,
                        color: AppColors.blueDarkActive,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      opportunity.description!,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 12,
                        color: AppColors.greyDarkNormal,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                  if (opportunity.syarat.isNotEmpty)
                    HuntAccordion(
                      title: 'Syarat',
                      leadingIcon: Icons.push_pin,
                      items: opportunity.syarat,
                    ),
                  if (opportunity.berkas.isNotEmpty)
                    HuntAccordion(
                      title: 'Berkas',
                      leadingIcon: Icons.description,
                      items: opportunity.berkas,
                    ),
                  if (opportunity.ketentuan.isNotEmpty)
                    HuntAccordion(
                      title: 'Ketentuan',
                      leadingIcon: Icons.campaign,
                      items: opportunity.ketentuan,
                    ),
                  SizedBox(height: 32),
                  HuntButton(
                    text: 'Daftar Sekarang',
                    onPressed: () => _openRegistration(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _getGradientByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'lomba':
        return AppColors.yellowGradient;
      case 'magang':
        return AppColors.greenGradient;
      case 'beasiswa':
      default:
        return AppColors.blueGradient;
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 350,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
        image: opportunity.imagePath != null
            ? DecorationImage(
                image: opportunityImage(opportunity.imagePath!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.85,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
                gradient: _getGradientByCategory(opportunity.category),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  left: 24,
                  right: 24,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCircleBtn(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          Consumer(
                            builder: (context, ref, _) {
                              if (ref.watch(authProvider).value?.isAdmin ??
                                  false) {
                                return SizedBox.shrink();
                              }
                              final saved = ref.watch(
                                isBookmarkedProvider(opportunity.id),
                              );
                              return _buildCircleBtn(
                                icon: saved
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                onTap: () => _toggleBookmark(context, ref),
                              );
                            },
                          ),
                          SizedBox(width: 12),
                          _buildCircleBtn(
                            icon: Icons.reply,
                            onTap: () => _share(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleBtn({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: .all(12),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.blueNormal, size: 24),
      ),
    );
  }
}
