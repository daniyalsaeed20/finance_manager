// notification_service.dart
// Local notifications for daily log reminders and tax due date reminders

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);
    await _plugin.initialize(initSettings);
  }

  Future<void> scheduleDailyReminder({required int hour, required int minute}) async {
    final details = NotificationDetails(
      android: const AndroidNotificationDetails('daily_channel', 'Daily Reminders', importance: Importance.max, priority: Priority.high),
      iOS: const DarwinNotificationDetails(),
    );
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) scheduled = scheduled.add(const Duration(days: 1));
    await _plugin.zonedSchedule(
      1000,
      'Daily log reminder',
      'Don\'t forget to log today\'s income and expenses.',
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleOneOff({required int id, required DateTime date, required String title, required String body}) async {
    final details = NotificationDetails(
      android: const AndroidNotificationDetails('due_channel', 'Due Reminders', importance: Importance.max, priority: Priority.high),
      iOS: const DarwinNotificationDetails(),
    );
    final scheduled = tz.TZDateTime.from(date, tz.local);
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
    );
  }
}

