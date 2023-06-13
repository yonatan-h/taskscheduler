import 'package:sqflite/sqflite.dart';
import 'models/task.dart';
import 'package:path/path.dart';

class DataProvider {
  static Database? _db;

  static Future<void> init() async {
    String folderPath = await getDatabasesPath();
    String filePath = join(folderPath, 'tasks.db');
    _db = await openDatabase(filePath);

    String createTableQuery = '''
        CREATE TABLE IF NOT EXISTS tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            content VARCHAR,
            reminderTime VARCHAR
        );
        ''';

    (await db).execute(createTableQuery);

    //checking
    replaceTasks([Task(content: "abebe", reminderTime: DateTime.now())]);
    print(getTasks());
  }

  static Future<Database> get db async {
    if (_db == null) await init();
    return _db as Database;
  }

  static Future<List<Task>> getTasks() async {
    List<Map<String, Object?>> taskMaps = await (await db).query("tasks");
    List<Task> tasks = taskMaps
        .map((taskThing) {
          return {
            "id": taskThing["id"] as int,
            "content": taskThing["content"] as String,
            "reminderTime": taskThing["reminderTime"] as String
          };
        })
        .map((taskMap) => Task.fromMap(taskMap))
        .toList();

    return tasks;
  }

  static Future<void> replaceTasks(List<Task> tasks) async {
    await (await db).rawDelete("DELETE from tasks;");
    for (Task task in tasks) {
      await (await db).insert("tasks", task.toMap());
    }
  }
}
