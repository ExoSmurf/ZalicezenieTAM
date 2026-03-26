import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  List<Task> task = [
    Task(title: "spotkanie z wojtkiem", deadline: "jutro", done: true),
    Task(title: "wojna", deadline: "dzis", done: false),
    Task(title: "flutter", deadline: "po-jutrze", done: false),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text("KrakFlow"),
        ),
        body: Center(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Text("Masz dziś ${task.length} zadania",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ))),
                  SizedBox(height: 16),
                  Center(child: Text("Dzisiejsze zadania")),
                  SizedBox(height: 16),
                ],
              ),
              Text("KrakFlow"),
              Text("Organizacja studiów"),
              Text("Dzisiejsze zadanka"),
              SizedBox(height: 100),
              Expanded(
                  child: ListView.builder(
                    itemCount: task.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                          title: task[index].title,
                          subtitle: task[index].deadline,
                          icon: Icons.eighteen_mp_sharp,
                          done: task[index].done
                      );
                    }),)
                ],
              ),
          ),
        ),
      );
  }
}

class Task {
  final String title;
  final String deadline;
  final bool done;

  Task({required this.title, required this.deadline, required this.done});
}

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool done;

  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 100),
      child: Card(
        child: ListTile(
          leading: Icon(icon),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Row(children: [Text(subtitle), Text(done.toString())]),
        ),
      ),
    );
  }
}