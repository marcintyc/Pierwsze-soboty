import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import '../services/notifications_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String _pixabayUrl = 'https://pixabay.com/get/gc035ced8adec1e2b87d2b0e81f4b9e6d2f5a5f5c6f0f2d7b1a4e8f3e4e8c7a74e8d9f9c5d3b7a1e2d3f7b9a1b2c3d4e5_1280.jpg';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Pierwsze Soboty'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen background image (network with offline fallback)
          Image.network(
            _pixabayUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Image.asset('assets/images/fatima.jpg', fit: BoxFit.cover),
          ),
          // Lighter gradient overlay for readability
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x4D000000), // ~30% black
                  Color(0x80000000), // ~50% black
                ],
              ),
            ),
          ),
          // Foreground content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 88, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Glass card with intro text
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Nabożeństwo pierwszych sobót',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '„Tym, którzy przez pięć miesięcy w pierwsze soboty odprawią nabożeństwa, w stanie łaski i w intencji wynagradzającej jej Niepokalanemu Sercu, wyjednam łaski potrzebne do zbawienia.”',
                              style: TextStyle(color: Colors.white, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _PrimaryButton(
                    icon: Icons.favorite_rounded,
                    label: 'Rozpocznij nabożeństwo',
                    onPressed: () => Navigator.pushNamed(context, '/conditions'),
                    background: colors.primary,
                    foreground: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  _PrimaryButton(
                    icon: Icons.calendar_month_rounded,
                    label: 'Kalendarz postępu',
                    onPressed: () => Navigator.pushNamed(context, '/progress'),
                    background: colors.primary,
                    foreground: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  _PrimaryButton(
                    icon: Icons.people_rounded,
                    label: 'Prośby o modlitwę (feed)',
                    onPressed: () => Navigator.pushNamed(context, '/prayer-feed'),
                    background: colors.primary,
                    foreground: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  _PrimaryButton(
                    icon: Icons.info_outline_rounded,
                    label: 'Informacje',
                    onPressed: () => Navigator.pushNamed(context, '/info'),
                    background: colors.primary,
                    foreground: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  _PrimaryButton(
                    icon: Icons.notifications_active_rounded,
                    label: 'Ustaw przypomnienie o pierwszej sobocie',
                    onPressed: () async {
                      await NotificationsService().scheduleFirstSaturdayReminder();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Przypomnienie ustawione')),
                        );
                      }
                    },
                    background: colors.primary,
                    foreground: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? background;
  final Color? foreground;
  const _PrimaryButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.background,
    this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground ?? Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}