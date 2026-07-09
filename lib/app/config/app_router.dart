import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';

abstract final class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => const MyHomePage(title: 'Hunt Home Page'),
      ),
    ],
  );
}
