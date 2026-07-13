import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/search_page.dart';
import '../../features/home/presentation/pages/opportunity_detail_page.dart';
import '../../features/home/data/models/opportunity_model.dart';
import '../../features/calendar/presentation/pages/calendar_page.dart';
import '../../features/bookmark/presentation/pages/bookmark_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../shared/widgets/main_layout.dart';

abstract final class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const OnboardingPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
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
        path: '/search',
        builder: (context, state) {
          final query = state.extra as String? ?? '';
          return SearchPage(initialQuery: query);
        },
      ),
      GoRoute(
        path: '/detail',
        builder: (context, state) {
          final opp = state.extra as OpportunityModel;
          return OpportunityDetailPage(opportunity: opp);
        },
      ),
    ],
  );
}
