import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/models/opportunity_model.dart';
import '../../../../core/widgets/opportunity_card.dart';
import '../providers/home_provider.dart';
import '../widgets/category_button.dart';
import '../widgets/home_header.dart';
import '../widgets/recommendation_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Widget _section(String title, Widget child) => Column(
    crossAxisAlignment: .start,
    spacing: 16,
    children: [
      Text(
        title,
        style: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 16,
          fontWeight: AppFontWeight.extraBold,
          color: AppColors.blueDarker,
        ),
      ),
      child,
    ],
  );

  Widget _async(
    AsyncValue<List<OpportunityModel>> async,
    String error,
    Widget Function(List<OpportunityModel>) builder,
  ) => async.hasError
      ? Center(
          child: Text(
            error,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: AppColors.greyDarkNormal,
            ),
          ),
        )
      : Skeletonizer(
          enabled: async.isLoading,
          child: builder(async.value ?? OpportunityModel.dummies),
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            HomeHeader(),
            Padding(
              padding: .all(32),
              child: Column(
                crossAxisAlignment: .start,
                spacing: 36,
                children: [
                  _section(
                    'Rekomendasi',
                    _async(
                      ref.watch(homeRecommendationsProvider),
                      'Gagal memuat rekomendasi',
                      (items) => SizedBox(
                        height: 108,
                        child: ListView(
                          scrollDirection: .horizontal,
                          physics: BouncingScrollPhysics(),
                          children: items.map(RecommendationCard.new).toList(),
                        ),
                      ),
                    ),
                  ),
                  _section(
                    'Kategori',
                    Padding(
                      padding: .symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
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
                  ),
                  _section(
                    'Pengingat',
                    _async(
                      ref.watch(homeRemindersProvider),
                      'Gagal memuat pengingat',
                      (items) => Column(
                        spacing: 10,
                        children: items.map(OpportunityCard.new).toList(),
                      ),
                    ),
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
