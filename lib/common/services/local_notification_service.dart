import 'package:echojar/common/utils/toaster.dart';
import 'package:echojar/data/data.dart' show checkPointBodyMessages;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {

  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  static const androidDetails = AndroidNotificationDetails(
    'echo_jar_channel',
    'Let\'s grind!',
    icon: "@mipmap/launcher_icon", 
    channelDescription: 'Get notified to grind',
    importance: Importance.high,
    priority: Priority.high,
  );

  static void initialize() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const InitializationSettings initializationSettingsAndroid = InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/launcher_icon")
    );

    await _notificationsPlugin.initialize(
      initializationSettingsAndroid,
      onDidReceiveNotificationResponse: (details) {
        if (details.input != null) {
          print("onDidReceiveNotificationResponse, ${details.input} !!! ${details}");
        }
      },
    );

    final bool? granted = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    print("Notifications Granted: $granted");
  }

  static Future<void> scheduleProgressNotifications({
    required DateTime createdDate,
    required DateTime scheduledDate,
    required String title,
    required BuildContext context,
  }) async {
    final now = DateTime.now();
    final totalDuration = scheduledDate.difference(createdDate);
    if (totalDuration <= Duration.zero) return;

    const checkpoints = [0.2, 0.5, 0.8, 1.0];
    final notificationDetails = NotificationDetails(android: androidDetails);

    bool allCheckpointsPassed = true;

    for (int i = 0; i < checkpoints.length; i++) {
      final checkpoint = checkpoints[i];
      final triggerTime = createdDate.add(totalDuration * checkpoint);
      final id = (createdDate.millisecondsSinceEpoch ~/ 1000) + i;
      final body = checkPointBodyMessages[i];

      if (triggerTime.isBefore(now)) {
        debugPrint('Checkpoint $checkpoint already passed: $triggerTime');
        await _notificationsPlugin.show(
          id,
          title,
          'You have already completed ${checkpoint * 100}% of the journey!',
          notificationDetails,
        );
      } else {
        allCheckpointsPassed = false;

        await _notificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(triggerTime, tz.local),
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    }

    // Если все прошли — показать тост
    if (allCheckpointsPassed && context.mounted) {
      Toaster.showSuccessToast(context, title: 'This jar has already been opened 🎉');
    }
  }

  static Future<void> cancelAllNotifications() async {
    return await _notificationsPlugin.cancelAll();
  }

  static Future<void> printPendingNotifications() async {
    final pending = await _notificationsPlugin.pendingNotificationRequests();
    for (var p in pending) {
      debugPrint("Scheduled notification: ID=${p.id}, title=${p.title}, body=${p.body}");
    }
  }

  Future<void> cancelOldScheduledNotifications(DateTime cutoff) async {
    final pending = await _notificationsPlugin.pendingNotificationRequests();

    for (final notification in pending) {
      final id = notification.id;

      // You can embed a timestamp in the ID like you're doing and decode it here
      final timestamp = id * 1000;
      final scheduledTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

      if (scheduledTime.isBefore(cutoff)) {
        await _notificationsPlugin.cancel(id);
      }
    }
  }

  static Future<void> cancelProgressNotifications(DateTime createdDate) async {
    final baseId = createdDate.millisecondsSinceEpoch ~/ 1000;
    for (int i = 0; i < 4; i++) {
      await _notificationsPlugin.cancel(baseId + i);
    }
  }

  static Future<void> display(String title, String body) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      NotificationDetails notificationDetails = const NotificationDetails(
          android: androidDetails
      );
      await _notificationsPlugin.show(id, title, body, notificationDetails);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}