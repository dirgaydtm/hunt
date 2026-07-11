import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/onboarding_slide.dart';
import '../widgets/onboarding_button.dart';
import '../constants/onboarding_constants.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPageIndex < onboardingSlides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPageIndex == onboardingSlides.length - 1;
    final progress = (_currentPageIndex + 1) / onboardingSlides.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Blurred Mesh Gradient Background
          Positioned.fill(
            child: ClipRect(
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: 75, sigmaY: 75),
                child: Stack(
                  children: [
                    // Mint-Green Circle (Bottom Left)
                    Positioned(
                      left: -40,
                      bottom: -20,
                      child: Container(
                        width: 321,
                        height: 321,
                        decoration: ShapeDecoration(
                          gradient: RadialGradient(
                            colors: [Color(0xFFD5FFFA), Color(0xFFA7E854)],
                          ),
                          shape: OvalBorder(),
                        ),
                      ),
                    ),
                    // Green-Yellow Circle (Middle Right)
                    Positioned(
                      right: -80,
                      top: MediaQuery.of(context).size.height * 0.35,
                      child: Container(
                        width: 284,
                        height: 284,
                        decoration: ShapeDecoration(
                          gradient: RadialGradient(
                            colors: [Color(0xFFA7E854), Color(0xFFFFD43F)],
                          ),
                          shape: OvalBorder(),
                        ),
                      ),
                    ),
                    // Blue-Cyan Circle (Top Left)
                    Positioned(
                      left: -125,
                      top: 56,
                      child: Container(
                        width: 292,
                        height: 292,
                        decoration: const ShapeDecoration(
                          gradient: RadialGradient(
                            colors: [Color(0xFF407BFF), Color(0xFF3FDCFF)],
                          ),
                          shape: OvalBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main View Content
          PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPageIndex = index),
            children: onboardingSlides
                .map((slide) => OnboardingSlide(slide: slide))
                .toList(),
          ),

          // Bottom Action Row
          Positioned(
            bottom: 110,
            left: 40,
            right: 40,
            child: Row(
              mainAxisAlignment: .spaceBetween,
              crossAxisAlignment: .end,
              children: [
                Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    Row(
                      children: List.generate(onboardingSlides.length, (index) {
                        final isActive = index == _currentPageIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: EdgeInsets.only(right: 6),
                          height: 8,
                          width: isActive ? 24 : 8,
                          decoration: BoxDecoration(
                            borderRadius: .circular(4),
                            color: isActive
                                ? AppColors.orangeNormal
                                : AppColors.blueLightActive,
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 16,
                          fontWeight: AppFontWeight.semiBold,
                          color: AppColors.greyDarkNormal,
                        ),
                      ),
                    ),
                  ],
                ),
                OnboardingButton(
                  isLastPage: isLastPage,
                  progress: progress,
                  onTap: _onNextPressed,
                  key: ValueKey('onboarding_button_$_currentPageIndex'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
