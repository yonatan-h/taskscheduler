import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import '../models/task.dart';

class NotificationsDataProvider {
  var awesomeNotifications = AwesomeNotifications();

  Future<void> replaceReminders(List<Task> tasks) async {
    await awesomeNotifications.cancelAllSchedules();
    List<Future<void>> setReminderFutures = [];
    for (Task task in tasks) {
      nullIfPast(task);
      if (task.reminderTime == null) continue;
      setReminderFutures.add(_setReminder(task));
    }

    await Future.wait(setReminderFutures);
  }

  nullIfPast(Task task) {
    if (task.reminderTime == null) return;
    if (DateTime.now().compareTo(task.reminderTime!) >= 0) {
      task.reminderTime = null;
    }
  }

  Future<void> _setReminder(Task task) async {
    var notificationContent = NotificationContent(

      
        id: Random().nextInt(100),
        wakeUpScreen: true,
        category: NotificationCategory.Reminder,
        channelKey: "channel",
        title: "Reminder!",
        body: task.content);

    DateTime dateTime = task.reminderTime!;
    var notificationCalander = NotificationCalendar(
      
      day: dateTime.day,
      month: dateTime.month,
      year: dateTime.year,
      hour: dateTime.hour,
      minute: dateTime.minute,
      second: dateTime.second,
      preciseAlarm: true,
      allowWhileIdle: true, //even on battery low
    );

    await awesomeNotifications.createNotification(
        schedule: notificationCalander, content: notificationContent);
  }

  Stream get stream {
    return awesomeNotifications.displayedStream;
  }
}
