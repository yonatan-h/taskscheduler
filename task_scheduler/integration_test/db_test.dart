// import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_scheduler/db.dart';
import 'package:task_scheduler/models/task.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  print('testing if test has begun');
  group('init and test database', () {
    test('should init db', () async {
      var db = await DataProvider.db;
      expect(db, isNot(null));
    });

    test('get tasks has no error', () async {
      var tasks = await DataProvider.getTasks();
      expect(tasks, isA<List<Task>>());
    });

    test('replace tasks has no error', () async {
      List<Task> tasks = [
        Task(content: "do this", reminderTime: DateTime(2023, 5, 28, 12, 50)),
        Task(content: "do that", reminderTime: DateTime(2023, 5, 28, 12, 50)),
        Task(
            content: "do all these",
            reminderTime: DateTime(2023, 5, 28, 12, 50)),
      ];

      await DataProvider.replaceTasks(tasks);
      expect(1, 1);
    });

    test('tasks should have have a "do that" task', () async {
      List<Task> tasks = await DataProvider.getTasks();
      Task? target = tasks.firstWhere((Task task) => task.content == "do this");
      expect(target, isNot(null));
    });

    test('table should replace, not grow', () async {
      List<Task> tasks = [Task(content: "abebe", reminderTime: DateTime.now())];
      await DataProvider.replaceTasks(tasks);
      int length = (await DataProvider.getTasks()).length;
      expect(length, 1);
    });
  });
}
