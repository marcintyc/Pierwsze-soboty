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
    // Refined Marian palette
    const Color marianBlue = Color(0xFF1E3A8A); // deep blue
    const Color marianBlueLight = Color(0xFF3B82F6); // light blue accent
    const Color marianGold = Color(0xFFD4AF37); // gold
    const Color marianPink = Color(0xFFF4A8C4); // delicate pink
    const Color marianSurface = Color(0xFFFAFCFF); // near-white

    final colorScheme = ColorScheme.fromSeed(
      seedColor: marianBlue,
      brightness: Brightness.light,
    ).copyWith(
      primary: marianBlue,
      secondary: marianGold,
      tertiary: marianPink,
      surface: marianSurface,
      background: marianSurface,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
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
        headlineMedium: TextStyle(fontWeight: FontWeight.w700),
        headlineSmall: TextStyle(fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontWeight: FontWeight.w600),
      ),
      iconTheme: IconThemeData(color: colorScheme.primary),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 3,
        shadowColor: marianBlue.withOpacity(0.06),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: marianBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(marianBlue),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? marianGold : Colors.white),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? marianBlueLight.withOpacity(0.6) : Colors.grey.shade300),
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