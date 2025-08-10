import 'package:flutter/material.dart';
import '../services/notifications_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Pierwsze Soboty')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeroBanner(colors: colors),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset('assets/images/fatima.jpg', fit: BoxFit.cover, height: 160),
          ),
          const SizedBox(height: 16),
          _PrimaryButton(
            icon: Icons.favorite_rounded,
            label: 'Rozpocznij nabożeństwo',
            onPressed: () => Navigator.pushNamed(context, '/conditions'),
          ),
          const SizedBox(height: 12),
          _PrimaryButton(
            icon: Icons.calendar_month_rounded,
            label: 'Kalendarz postępu',
            onPressed: () => Navigator.pushNamed(context, '/progress'),
          ),
          const SizedBox(height: 12),
          _PrimaryButton(
            icon: Icons.info_outline_rounded,
            label: 'Informacje',
            onPressed: () => Navigator.pushNamed(context, '/info'),
          ),
          const SizedBox(height: 12),
          _PrimaryButton(
            icon: Icons.people_rounded,
            label: 'Prośby o modlitwę (feed)',
            onPressed: () => Navigator.pushNamed(context, '/prayer-feed'),
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
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  final ColorScheme colors;
  const _HeroBanner({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primary,
            colors.primary.withValues(alpha: 0.85),
            const Color(0xFF3B82F6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.15),
            ),
            child: const Icon(Icons.favorite_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Nabożeństwo pierwszych sobót',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 6),
                Text(
                  '„Tym, którzy przez pięć miesięcy w pierwsze soboty odprawią nabożeństwa... wyjednam łaski potrzebne do zbawienia.”',
                  style: TextStyle(color: Colors.white, height: 1.3),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const _PrimaryButton({required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(label),
        ),
      ),
    );
  }
}