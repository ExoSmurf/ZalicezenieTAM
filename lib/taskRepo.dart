class TaskRepository {
  static List<Task> task = [
    Task(title: "spotkanie z wojtkiem", deadline: "jutro", done: true),
    Task(title: "wojna", deadline: "dzis", done: false),
    Task(title: "flutter", deadline: "po-jutrze", done: false),
  ];
}


class Task {
  final String title;
  final String deadline;
  final bool done;

  Task({required this.title, required this.deadline, required this.done});
}

