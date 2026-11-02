import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (kIsWeb) return;
    tzdata.initializeTimeZones();
    try {
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
    } catch (_) {/* falls back to UTC */}
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    try {
      await _plugin.initialize(settings);
      await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      _initialized = true;
    } catch (_) {
      _initialized = false;
    }
  }

  Future<void> showBudgetAlert(String category, double spent, double limit) async {
    if (kIsWeb || !_initialized) return;
    const details = NotificationDetails(
      android: AndroidNotificationDetails('budget_alerts', 'Budget alerts',
        channelDescription: 'Alerts when a category reaches its budget limit.',
        importance: Importance.high, priority: Priority.high),
    );
    try {
      await _plugin.show(category.hashCode & 0x7fffffff, 'Budget limit reached',
        '$category spending is ₹${spent.toStringAsFixed(2)} of ₹${limit.toStringAsFixed(2)}.', details);
    } catch (_) {}
  }

  Future<void> showDailyReminder() async {
    if (kIsWeb || !_initialized) return;
    const details = NotificationDetails(
      android: AndroidNotificationDetails('expense_reminders', 'Expense reminders',
        channelDescription: 'A reminder to record your daily expenses.',
        importance: Importance.defaultImportance, priority: Priority.defaultPriority),
    );
    try {
      await _plugin.show(9001, 'Record today’s expenses',
        'Take a moment to update your Expense Manager.', details);
    } catch (_) {}
  }

  /// Schedules a recurring reminder for 8:00 PM device-local time.
  Future<bool> scheduleDailyReminder() async {
    if (kIsWeb || !_initialized) return false;
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 20);
    if (!scheduled.isAfter(now)) scheduled = scheduled.add(const Duration(days: 1));
    const details = NotificationDetails(
      android: AndroidNotificationDetails('scheduled_expense_reminders', 'Daily expense reminders',
        channelDescription: 'Daily reminder to record expenses.',
        importance: Importance.defaultImportance, priority: Priority.defaultPriority),
    );
    try {
      await _plugin.zonedSchedule(9002, 'Daily expense reminder',
        'Remember to record today’s income and expenses.', scheduled, details,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time);
      return true;
    } catch (_) { return false; }
  }

  Future<void> cancelDailyReminder() async {
    if (kIsWeb) return;
    try { await _plugin.cancel(9002); } catch (_) {}
  }
}
