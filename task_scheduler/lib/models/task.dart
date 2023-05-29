class Task {
  String content;
  DateTime reminderTime;

  Task({required this.content, required this.reminderTime});
  Task.fromMap(Map<String, String> map)
      : content = map["content"] as String,
        reminderTime = DateTime.parse(map["reminderTime"] as String);

  Map<String, String> toMap() {
    Map<String, String> map = {
      "content": content,
      "reminderTime": reminderTime.toIso8601String()
    };

    return map;
  }
}
