import 'package:flutter/material.dart';
import 'core/routing/app_router.dart';
import 'core/state/app_session.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const EstateHubApp());
}

class EstateHubApp extends StatelessWidget {
  const EstateHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppSession.instance,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'EstateHub',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: AppSession.instance.themeMode,
          routerConfig: appRouter,
        );
      },
    );
  }
}
