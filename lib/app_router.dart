import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';

import 'package:notes/view/note_view.dart';
import 'package:notes/view/settings.dart';
import 'package:notes/view/widget/search.dart';
import 'package:notes/view/widget/sidebar.dart';
import 'view/home_view.dart';
import 'view/archive_view.dart';
import 'view/editor_view.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          const CupertinoPage(child: HomeView()),
    ),

    GoRoute(
      path: '/archive',
      pageBuilder: (context, state) =>
          const CupertinoPage(child: ArchiveView()),
    ),

   GoRoute(
  path: '/edit',
  builder: (context, state) {
    final from = state.uri.queryParameters['from'] ?? 'home';
    return EditorView(from: from);
  },
),

    GoRoute(
      path: '/sidebar',
      pageBuilder: (context, state) =>
          const CupertinoPage(child: Sidebar()),
    ),

   GoRoute(
  path: '/note/:id',
  builder: (context, state) {
    final id = int.parse(state.pathParameters['id']!);
    final from = state.uri.queryParameters['from'] ?? 'home';
    return NoteView(id: id, from: from);
  },
),


    GoRoute(
      path: '/edit/:id',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return CupertinoPage(child: EditorView(id: id));
      },
    ),

    GoRoute(
      path: '/search',
      pageBuilder: (context, state) =>
          const CupertinoPage(child: SearchView()),
    ),

    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) =>
          const CupertinoPage(child: SettingsView()),
    ),
  ],
);
