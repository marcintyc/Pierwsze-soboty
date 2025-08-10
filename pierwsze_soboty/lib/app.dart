import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/conditions_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/info_screen.dart';

class PierwszeSobotyApp extends StatelessWidget {
  const PierwszeSobotyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2E5AAC),
      brightness: Brightness.light,
    ).copyWith(
      primary: const Color(0xFF2E5AAC),
      secondary: const Color(0xFFFFC857),
      surface: const Color(0xFFF7F9FC),
      onPrimary: Colors.white,
    );

    final theme = ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontWeight: FontWeight.w600),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(colorScheme.primary),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pierwsze Soboty',
      theme: theme,
      locale: const Locale('pl'),
      supportedLocales: const [Locale('pl')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/conditions': (context) => const ConditionsScreen(),
        '/progress': (context) => const ProgressScreen(),
        '/info': (context) => const InfoScreen(),
      },
    );
  }
}