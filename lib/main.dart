import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_portfolio/screen/main_page.dart';
import 'package:my_portfolio/service/theme_service.dart';

import 'package:my_portfolio/service/cursor_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => CursorService()),
      ],
      child: const PortfolioApp(),
    ),
  );
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amal Mathew | Flutter Developer',
      themeMode: themeService.themeMode,
      theme: ThemeService.lightTheme,
      darkTheme: ThemeService.darkTheme,
      home: const PortfolioScrollablePage(),
    );
  }
}
