import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hunt/shared/widgets/divider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/hunt_button.dart';
import '../widgets/auth_header.dart';
import '../widgets/login_form.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  void _handleGoogleLogin(WidgetRef ref, BuildContext context) async {
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AuthHeader(height: MediaQuery.of(context).size.height * 0.5),
          ),
          Positioned.fill(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const .symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.22),
                    Text(
                      'Masuk',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 42,
                        fontWeight: AppFontWeight.extraBold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    const LoginForm(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Padding(
                      padding: .symmetric(horizontal: 100),
                      child: Column(
                        children: [
                          HuntDivider(text: 'atau'),
                          SizedBox(height: 24),
                          HuntButton(
                            text: 'Masuk dengan Google',
                            isOutlined: true,
                            isLoading: isLoading,
                            leading: SvgPicture.asset(
                              'assets/icons/google.svg',
                              width: 20,
                              height: 20,
                            ),
                            onPressed: () => _handleGoogleLogin(ref, context),
                          ),
                          SizedBox(height: 32),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: 14,
                                  color: AppColors.greyLightDarker,
                                ),
                                children: [
                                  const TextSpan(text: 'Belum memiliki akun? '),
                                  TextSpan(
                                    text: 'Daftar',
                                    style: TextStyle(
                                      fontWeight: AppFontWeight.bold,
                                      color: AppColors.blueNormalActive,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        if (!isLoading) {
                                          context.push('/register');
                                        }
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
