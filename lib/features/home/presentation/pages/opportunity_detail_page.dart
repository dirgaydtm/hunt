import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/category_tag.dart';
import '../../../../shared/widgets/hunt_accordion.dart';
import '../../../../shared/widgets/hunt_button.dart';
import '../../data/models/opportunity_model.dart';

class OpportunityDetailPage extends StatelessWidget {
  final OpportunityModel opportunity;

  const OpportunityDetailPage({super.key, required this.opportunity});

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
                  if (opportunity.syarat != null &&
                      opportunity.syarat!.isNotEmpty)
                    HuntAccordion(
                      title: 'Syarat',
                      leadingIcon: Icons.push_pin,
                      items: opportunity.syarat!,
                    ),
                  if (opportunity.berkas != null &&
                      opportunity.berkas!.isNotEmpty)
                    HuntAccordion(
                      title: 'Berkas',
                      leadingIcon: Icons.description,
                      items: opportunity.berkas!,
                    ),
                  if (opportunity.ketentuan != null &&
                      opportunity.ketentuan!.isNotEmpty)
                    HuntAccordion(
                      title: 'Ketentuan',
                      leadingIcon: Icons.campaign,
                      items: opportunity.ketentuan!,
                    ),
                  SizedBox(height: 32),
                  HuntButton(
                    text: 'Daftar Sekarang',
                    onPressed: () {
                      context.go('/home');
                    },
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
                image: AssetImage(opportunity.imagePath!),
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
                          _buildCircleBtn(
                            icon: Icons.bookmark_border,
                            onTap: () {},
                          ),
                          SizedBox(width: 12),
                          _buildCircleBtn(icon: Icons.reply, onTap: () {}),
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
