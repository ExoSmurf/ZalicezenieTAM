import 'dart:math';

class TaskRepository {
  static List<Task> task = [
    Task(id: Random().nextInt(100000), title: "spotkanie z wojtkiem", deadline: "jutro", done: true),
    Task(id: Random().nextInt(100000), title: "wojna", deadline: "dzis", done: false),
    Task(id: Random().nextInt(100000), title: "flutter", deadline: "po-jutrze", done: false),
  ];
  static void remove(index) {
    task.removeAt(index);
  }
}


class Task {
  final int id;
  final String title;
  final String deadline;
  // final String priority;
  final bool done;

  Task({required this.id, required this.title, required this.deadline, required this.done});
  Map<String, dynamic> toMap() {
    return {
      "id" : id,
      "title" : title,
      "deadline" : deadline,
      "done" : done,
    };
  }

  factory Task.fromMap(Map map) {
    return Task(
      id : map['id'],
      title : map['title'],
      deadline : map['deadline'],
      done : map['done'],
    );
  }
}

