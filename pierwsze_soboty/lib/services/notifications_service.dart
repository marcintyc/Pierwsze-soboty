import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    if (kIsWeb) return; // notifications not supported on web
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final InitializationSettings initSettings = InitializationSettings(android: androidInit, iOS: iosInit);
    await _plugin.initialize(initSettings);
  }

  Future<void> scheduleFirstSaturdayReminder() async {
    if (kIsWeb) return;

    final next = _nextFirstSaturday();
    const int id = 1001;
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'pierwsze_soboty_channel',
      'Pierwsze Soboty Powiadomienia',
      channelDescription: 'Przypomnienia o pierwszych sobotach miesiąca',
      importance: Importance.high,
      priority: Priority.high,
    );
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
    final NotificationDetails details = const NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.zonedSchedule(
      id,
      'Pierwsza sobota miesiąca',
      'Pamiętaj o nabożeństwie wynagradzającym',
      tz.TZDateTime.from(next, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  DateTime _nextFirstSaturday() {
    final now = DateTime.now();
    DateTime candidate = DateTime(now.year, now.month, 1);
    // find first Saturday this month
    while (candidate.weekday != DateTime.saturday) {
      candidate = candidate.add(const Duration(days: 1));
    }
    if (candidate.isBefore(now)) {
      // move to next month
      DateTime nextMonth = DateTime(now.year, now.month + 1, 1);
      while (nextMonth.weekday != DateTime.saturday) {
        nextMonth = nextMonth.add(const Duration(days: 1));
      }
      return nextMonth.add(const Duration(hours: 9));
    }
    return candidate.add(const Duration(hours: 9)); // 9:00 default
  }
}