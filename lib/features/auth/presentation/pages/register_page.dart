import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/hunt_button.dart';
import '../widgets/auth_header.dart';
import '../widgets/register_form.dart';
import '../../../../shared/widgets/divider.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  void _handleGoogleRegister(WidgetRef ref, BuildContext context) async {
    final success = await ref.read(authProvider.notifier).loginWithGoogle();
    if (success && context.mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.greyLightLightActive,
      body: Stack(
        children: [
          const Positioned(top: 0, left: 0, right: 0, child: AuthHeader()),
          Positioned.fill(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: .symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.10),
                    Text(
                      'Daftar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 42,
                        fontWeight: AppFontWeight.extraBold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    const RegisterForm(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100),
                      child: Column(
                        crossAxisAlignment: .stretch,
                        children: [
                          const HuntDivider(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          HuntButton(
                            text: 'Daftar dengan Google',
                            isOutlined: true,
                            isLoading: isLoading,
                            leading: SvgPicture.asset(
                              'assets/icons/google.svg',
                              width: 20,
                              height: 20,
                            ),
                            onPressed: () =>
                                _handleGoogleRegister(ref, context),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: 14,
                                  color: AppColors.greyLightDarker,
                                ),
                                children: [
                                  const TextSpan(text: 'Sudah memiliki akun? '),
                                  TextSpan(
                                    text: 'Masuk',
                                    style: TextStyle(
                                      fontWeight: AppFontWeight.bold,
                                      color: AppColors.blueNormalActive,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        if (!isLoading) context.pop();
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
