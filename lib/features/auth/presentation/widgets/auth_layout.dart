import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/divider.dart';
import '../../../../shared/widgets/hunt_button.dart';
import '../providers/auth_provider.dart';
import 'auth_header.dart';

class AuthLayout extends ConsumerWidget {
  const AuthLayout({
    super.key,
    required this.title,
    required this.form,
    required this.googleText,
    required this.prompt,
    required this.action,
    required this.onAction,
    this.headerFraction = .5,
  });

  final String title, googleText, prompt, action;
  final Widget form;
  final VoidCallback onAction;
  final double headerFraction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authProvider).isLoading;
    final height = MediaQuery.sizeOf(context).height;
    final footerStyle = TextStyle(
      fontFamily: AppTextStyles.fontFamily,
      fontSize: 14,
    );

    Future<void> google() async {
      final error = await ref.read(authProvider.notifier).loginWithGoogle();
      if (error == null || !context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.redNormal),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.greyLightLightActive,
      body: Stack(
        children: [
          AuthHeader(height: height * headerFraction),
          SafeArea(
            child: CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: .symmetric(horizontal: 30, vertical: 24),
                    child: Column(
                      crossAxisAlignment: .stretch,
                      spacing: 32,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: .bottomCenter,
                            child: Text(
                              title,
                              textAlign: .center,
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 42,
                                fontWeight: AppFontWeight.extraBold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        form,
                        Expanded(
                          child: Align(
                            alignment: .topCenter,
                            child: Padding(
                              padding: .symmetric(horizontal: 40),
                              child: Column(
                                spacing: 16,
                                children: [
                                  HuntDivider(),
                                  HuntButton(
                                    text: googleText,
                                    isOutlined: true,
                                    isLoading: isLoading,
                                    leading: SvgPicture.asset(
                                      'assets/icons/google.svg',
                                      width: 20,
                                    ),
                                    onPressed: google,
                                  ),
                                  Row(
                                    mainAxisAlignment: .center,
                                    spacing: 4,
                                    children: [
                                      Text(
                                        prompt,
                                        style: footerStyle.copyWith(
                                          color: AppColors.greyLightDarker,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: isLoading ? null : onAction,
                                        child: Text(
                                          action,
                                          style: footerStyle.copyWith(
                                            fontWeight: AppFontWeight.bold,
                                            color: AppColors.blueNormalActive,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
