import 'package:flutter/material.dart';
import 'taskRepo.dart';
import 'taskCard.dart';


class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});

  final TextEditingController tileController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController prioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Nowe zadanie"),
        ),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: tileController,
                  decoration: InputDecoration(
                      labelText: "Tytuł zadania",
                      border: OutlineInputBorder()
                  ),
                ),
                TextField(
                  controller: deadlineController,
                  decoration: InputDecoration(
                      labelText: "deadline zadania",
                      border: OutlineInputBorder()
                  ),
                ),
                TextField(
                  controller: prioController,
                  decoration: InputDecoration(
                      labelText: "priorytet zadania",
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(onPressed: () {
                  final newTask = Task(title: tileController.text,
                      deadline: deadlineController.text,
                      done: false);

                  Navigator.pop(context, newTask);
                }, child: Text("Zapisz"))
              ],)
        )
    );
  }
}

class EditTaskScreen extends StatelessWidget {
  final Task task;
  EditTaskScreen({super.key, required this.task});

  final TextEditingController tileController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController boolController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edytuj zadanie ${task.title}"),
        ),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: tileController,
                  decoration: InputDecoration(
                      labelText: "tytuł (${task.title})",
                      border: OutlineInputBorder()
                  ),
                ),
                TextField(
                  controller: deadlineController,
                  decoration: InputDecoration(
                      labelText: "deadline (${task.deadline})",
                      border: OutlineInputBorder()
                  ),
                ),
                // Checkbox(
                //     value: task.done,
                //     onChanged: (value) {
                //       setState(() {
                //         taskDone = value!;
                //       });
                //     }),
                SizedBox(height: 16),
                ElevatedButton(onPressed: () {
                  final editedTask = Task(title: tileController.text,
                      deadline: deadlineController.text,
                      done: false); //do zmiany po checkbox

                  Navigator.pop(context, editedTask);
                }, child: Text("Zapisz"))
              ],)
        )
    );
  }
}