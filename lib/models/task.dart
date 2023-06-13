class Task {
  int? id;
  String content;
  DateTime reminderTime;

  Task({required this.content, required this.reminderTime, this.id});
  Task.fromMap(Map<String, Object> map)
      : id = map["id"] as int?,//need id when getting from db
        content = map["content"] as String,
        reminderTime = DateTime.parse(map["reminderTime"] as String);

  Map<String, Object> toMap() {
    Map<String, Object> map = {
      "content": content,
      "reminderTime": reminderTime.toIso8601String()
    //no id when saving to db
    };

    return map;
  }
}
