import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';



class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin
      _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();
    final String timeZoneName =
        await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(
    tz.getLocation(
        timeZoneName,
    ),
    );
    const ios =
        DarwinInitializationSettings();

    const android =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings =
        InitializationSettings(
      android: android,
      iOS: ios,
    );

    await _notifications.initialize(
      settings,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static FlutterLocalNotificationsPlugin
      get instance => _notifications;

    static Future<void> schedulePartialProtection({
    required Duration duration,
    }) async {
    await _notifications.zonedSchedule(
        101,
        'Focus Session Finished',
        'Your Partial Protection session has ended.',
        tz.TZDateTime.now(
        tz.local,
        ).add(duration),
        const NotificationDetails(
        iOS: DarwinNotificationDetails(),
        android: AndroidNotificationDetails(
            'partial_protection',
            'Partial Protection',
            channelDescription:
                'Partial protection notifications',
            importance: Importance.high,
            priority: Priority.high,
        ),
        ),
        androidScheduleMode:
            AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: null,
    );
    }

    static Future<void> cancelPartialProtection() async {
    await _notifications.cancel(101);
    }
static Future<void> showMilestoneNotification({
  required String title,
  required String body,
}) async {
  await _notifications.show(
    102,
    title,
    body,
    const NotificationDetails(
      iOS: DarwinNotificationDetails(),
      android: AndroidNotificationDetails(
        'progress_notifications',
        'Progress Notifications',
        channelDescription:
            'Milestones and achievements',
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
  );
}

static Future<void> showLevelUpNotification({
  required int level,
}) async {
  await showMilestoneNotification(
    title: 'Level Up!',
    body: 'Congratulations! You reached Level $level.',
  );
}

static Future<void> scheduleRecurringProgressReminder({
required Duration duration,
}) async {
await _notifications.zonedSchedule(
  103,
  'Keep Going!',
  'Check your CleanMind progress and keep your streak alive.',
  tz.TZDateTime.now(tz.local).add(duration),
  const NotificationDetails(
    iOS: DarwinNotificationDetails(),
    android: AndroidNotificationDetails(
      'progress_notifications',
      'Progress Notifications',
      channelDescription:
          'Recurring progress reminders',
      importance: Importance.high,
      priority: Priority.high,
    ),
  ),
  androidScheduleMode:
      AndroidScheduleMode.exactAllowWhileIdle,
  matchDateTimeComponents: null,
);
}

static Future<void> cancelRecurringProgressReminder() async {
await _notifications.cancel(103);
}
}