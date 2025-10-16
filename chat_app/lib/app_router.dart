// lib/app_router.dart
import 'package:go_router/go_router.dart';
import 'pages/splash_screen.dart';
import 'pages/chat_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      name: 'chat',
      builder: (context, state) => const ChatScreen(),
    ),
  ],
);