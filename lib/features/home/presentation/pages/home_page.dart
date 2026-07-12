import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/opportunity_card.dart';
import '../../data/models/opportunity_model.dart';
import '../providers/home_provider.dart';
import '../widgets/category_button.dart';
import '../widgets/home_header.dart';
import '../widgets/recommendation_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key, required this.title});

  final String title;

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppTextStyles.fontFamily,
        fontSize: 16,
        fontWeight: AppFontWeight.extraBold,
        color: AppColors.blueDarker,
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          color: AppColors.greyDarkNormal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsAsync = ref.watch(homeRecommendationsProvider);
    final remindersAsync = ref.watch(homeRemindersProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            const HomeHeader(),
            Padding(
              padding: const .all(32),
              child: Column(
                crossAxisAlignment: .start,
                spacing: 36,
                children: [
                  Column(
                    crossAxisAlignment: .start,
                    spacing: 16,
                    children: [
                      _buildSectionTitle('Rekomendasi'),
                      recommendationsAsync.hasError
                          ? _buildError('Gagal memuat rekomendasi')
                          : Skeletonizer(
                              enabled: recommendationsAsync.isLoading,
                              child: SizedBox(
                                height: 108,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  children:
                                      (recommendationsAsync.value ??
                                              OpportunityModel.dummies)
                                          .map((opp) {
                                            return RecommendationCard(
                                              title: opp.title,
                                              organizer: opp.organizer,
                                              category: opp.category,
                                              postedAt: opp.postedAt,
                                              imagePath: opp.imagePath,
                                              onTap: () {
                                                context.push('/detail', extra: opp);
                                              },
                                            );
                                          })
                                          .toList(),
                                ),
                              ),
                            ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: .start,
                    spacing: 16,
                    children: [
                      _buildSectionTitle('Kategori'),
                      Padding(
                        padding: const .symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: .spaceBetween,
                          children: const [
                            CategoryButton(
                              label: 'Beasiswa',
                              icon: Icons.school_outlined,
                              color: AppColors.blueNormal,
                              lightColor: AppColors.blueLightHover,
                            ),
                            CategoryButton(
                              label: 'Lomba',
                              icon: Icons.emoji_events_outlined,
                              color: AppColors.yellowDark,
                              lightColor: AppColors.yellowLightHover,
                            ),
                            CategoryButton(
                              label: 'Magang',
                              icon: Icons.business_outlined,
                              color: AppColors.greenNormal,
                              lightColor: AppColors.greenLightHover,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: .start,
                    spacing: 16,
                    children: [
                      _buildSectionTitle('Pengingat'),
                      remindersAsync.hasError
                          ? _buildError('Gagal memuat pengingat')
                          : Skeletonizer(
                              enabled: remindersAsync.isLoading,
                              child: Column(
                                spacing: 10,
                                children:
                                    (remindersAsync.value ??
                                            OpportunityModel.dummies)
                                        .map((opp) {
                                          return OpportunityCard(
                                            title: opp.title,
                                            organizer: opp.organizer,
                                            category: opp.category,
                                            urgencyText: opp.urgencyText,
                                            imagePath: opp.imagePath,
                                            onTap: () {
                                              context.push('/detail', extra: opp);
                                            },
                                          );
                                        })
                                        .toList(),
                              ),
                            ),
                    ],
                  ),

                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
