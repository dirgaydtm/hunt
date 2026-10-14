import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/preferences/preferences_provider.dart';
import '../../features/admin/presentation/pages/admin_page.dart';
import '../../features/admin/presentation/pages/admin_users_page.dart';
import '../../features/admin/presentation/pages/broadcast_page.dart';
import '../../features/admin/presentation/pages/opportunity_form_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/search_page.dart';
import '../../features/home/presentation/pages/opportunity_detail_page.dart';
import '../../shared/models/opportunity_model.dart';
import '../../features/calendar/presentation/pages/calendar_page.dart';
import '../../features/bookmark/presentation/pages/bookmark_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../shared/data/opportunity_repository.dart';
import '../../shared/widgets/main_layout.dart';
import 'auth_redirect.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref.listen(authProvider, (_, _) => refresh.value++);
  ref.listen(passwordRecoveryProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      return authRedirect(
        location: state.matchedLocation,
        loggedIn: ref.read(authRepositoryProvider).currentSession != null,
        onboardingSeen:
            ref.read(sharedPreferencesProvider).getBool(onboardingSeenKey) ??
            false,
        recoveringPassword: ref.read(passwordRecoveryProvider),
        isAdmin: auth.value?.isAdmin ?? false,
        profileLoading: auth.isLoading,
      );
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const OnboardingPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) =>
                const HomePage(title: 'Hunt Home Page'),
          ),
          GoRoute(
            path: '/calendar',
            builder: (context, state) => const CalendarPage(),
          ),
          GoRoute(
            path: '/bookmark',
            builder: (context, state) => const BookmarkPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminPage(),
        routes: [
          GoRoute(
            path: 'opportunities/new',
            builder: (context, state) => const OpportunityFormPage(),
          ),
          GoRoute(
            path: 'opportunities/:id/edit',
            builder: (context, state) => OpportunityFormPage(
              id: state.pathParameters['id'],
              initial: switch (state.extra) {
                final OpportunityModel o => o,
                _ => null,
              },
            ),
          ),
          GoRoute(
            path: 'users',
            builder: (context, state) => const AdminUsersPage(),
          ),
          GoRoute(
            path: 'broadcast',
            builder: (context, state) => const BroadcastPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => SearchPage(
          initialFilters: switch (state.extra) {
            final SearchFilters f => f,
            _ => const SearchFilters(),
          },
        ),
      ),
      GoRoute(
        path: '/opportunity/:id',
        builder: (context, state) => OpportunityDetailPage(
          id: state.pathParameters['id']!,
          initial: switch (state.extra) {
            final OpportunityModel o => o,
            _ => null,
          },
        ),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
