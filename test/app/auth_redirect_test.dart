import 'package:flutter_test/flutter_test.dart';
import 'package:hunt/app/config/auth_redirect.dart';

String? redirect(
  String location, {
  bool loggedIn = false,
  bool onboardingSeen = false,
  bool isAdmin = false,
  bool profileLoading = false,
}) => authRedirect(
  location: location,
  loggedIn: loggedIn,
  onboardingSeen: onboardingSeen,
  isAdmin: isAdmin,
  profileLoading: profileLoading,
);

void main() {
  group('signed out', () {
    test('shows onboarding on first launch', () {
      expect(redirect('/'), isNull);
    });
    test('skips onboarding once seen', () {
      expect(redirect('/', onboardingSeen: true), '/login');
    });
    test('allows auth pages', () {
      expect(redirect('/login'), isNull);
      expect(redirect('/register'), isNull);
    });
    test('blocks app pages', () {
      expect(redirect('/home'), '/login');
      expect(redirect('/admin'), '/login');
    });
  });

  group('signed in', () {
    test('leaves auth pages for home', () {
      expect(redirect('/login', loggedIn: true), '/home');
      expect(redirect('/', loggedIn: true), '/home');
    });
    test('allows app pages', () {
      expect(redirect('/home', loggedIn: true), isNull);
    });
    test('blocks admin for regular users', () {
      expect(redirect('/admin', loggedIn: true), '/home');
    });
    test('waits for profile before deciding on admin', () {
      expect(redirect('/admin', loggedIn: true, profileLoading: true), isNull);
    });
    test('allows admin for admins', () {
      expect(
        redirect('/admin/opportunities/new', loggedIn: true, isAdmin: true),
        isNull,
      );
    });
    test('blocks bookmark for admins', () {
      expect(redirect('/bookmark', loggedIn: true, isAdmin: true), '/home');
      expect(redirect('/bookmark', loggedIn: true), isNull);
    });
  });
}
