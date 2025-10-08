import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/home_page.dart';
import 'pages/story_detail_page.dart';
import 'pages/web_view_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'story/:id',
            name: 'story',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return StoryDetailPage(storyId: id);
            },
          ),
          GoRoute(
            path: 'webview',
            name: 'webview',
            builder: (context, state) {
              final url = state.uri.queryParameters['url']!;
              final title = state.uri.queryParameters['title'] ?? 'Web View';
              return WebViewPage(url: url, title: title);
            },
          ),
        ],
      ),
    ],
  );
});