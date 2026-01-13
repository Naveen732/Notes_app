import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_router.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Keep Notes',
      routerConfig: router,
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.systemYellow,
        barBackgroundColor: CupertinoColors.systemGroupedBackground,
        scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(color: CupertinoColors.label, fontSize: 16),
        ),
      ),
    );
  }
}
