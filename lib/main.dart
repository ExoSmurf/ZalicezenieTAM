import 'package:flutter/material.dart';
import 'package:todo/services/task_local_db.dart';
import 'package:todo/services/task_sync_service.dart';
import 'taskRepo.dart';
import 'taskCard.dart';
import 'manipulateTasks.dart';
import 'dart:convert';
import './services/task_api_service.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('tasks');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _MyAppState();
}

class _MyAppState extends State<HomeScreen> {

  String filter = "wszystkie";
  String selectedFilter = "wszystkie";

  int allTaskCount = 0;
  int doneTaskCount = 0;
  int todoTaskCount = 0;

  void updateCounter(List<Task> tasks) {
    setState(() {
      allTaskCount = tasks.length;
      doneTaskCount = tasks.where((task) => task.done).length;
      todoTaskCount = allTaskCount - doneTaskCount; // skrócik
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Task> filteredTasks = TaskRepository.task; // pomimo liczby pojedynczej to cala lista

    if (selectedFilter == "wykonane") {
      filteredTasks = TaskRepository.task
          .where((task) => task.done)
          .toList();
    } else if (selectedFilter == "do zrobienia") {
      filteredTasks = TaskRepository.task
          .where((task) => !task.done)
          .toList();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("KrakFlow"),
        ),
        body: Center(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text("Masz dziś ${TaskRepository.task.length} zadania",
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
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: selectedFilter == "wszystkie" ?
                      Colors.blue : Colors.grey
                    ),
                    onPressed: () {
                      setState(() {
                        selectedFilter = "wszystkie";
                      });
                    }, child: Text("Wszystkie")
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: selectedFilter == "do zrobienia" ?
                        Colors.blue : Colors.grey
                    ),
                    onPressed: () {
                      setState(() {
                        selectedFilter = "do zrobienia";
                      });
                    }, child: Text("Do zrobienia")
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: selectedFilter == "wykonane" ?
                        Colors.blue : Colors.grey
                    ),
                    onPressed: () {
                      setState(() {
                        selectedFilter = "wykonane";
                      });
                    }, child: Text("Wykonane")
                  ),
                ],

              ),
              Expanded(
                  child: TaskListScreen(
                    onTasksLoaded: updateCounter,
                  ),
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("potwierdzenie"),
                          content: Text("czy na pewno chcesz usunac WSZYSKIE zadania?"),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Anuluj")
                            ),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    TaskLocalDb.deleteAtllTasks();
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text("usun")
                            ),
                          ],
                        );
                      }
                    );
                  }, icon: Icon(Icons.delete)
              ),
            SizedBox(height: 20),
            ],
          ),
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final Task? newTask = await Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddTaskScreen())
            );
            if (newTask != null) {
              setState(() {
                filteredTasks.add(newTask);
              });
            }
          },
          child: Icon(Icons.add),
        ),
        );
  }
}


class TaskListScreen extends StatefulWidget {
  final ValueChanged<List<Task>> onTasksLoaded;

  const TaskListScreen({super.key, required this.onTasksLoaded});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> tasksFuture;

  @override
  void initState() {
    super.initState();
    tasksFuture = TaskApiService.fetchTasks();
  }

  Future<List<Task>> loadTasks() async {
    await TaskSyncService.loadInitialDataIfNeeded();
    return TaskLocalDb.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
        future: tasksFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("blad: ${snapshot.error}"),
            );
          }

          final tasks = snapshot.data!;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onTasksLoaded(tasks);
          });

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Dismissible(
                  key: ValueKey(task.title),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("rm: ${task.title}"),
                        )
                    );
                    TaskLocalDb.deleteTask(task.id); // chyba potrzebne zeby na task nie wrocil
                  },
                  child: TaskCard(
                      title: task.title,
                      subtitle: task.deadline,
                      icon: Icons.eighteen_mp_sharp,
                      done: task.done,
                      onTap: () async {
                        final Task? updatedTask = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditTaskScreen(
                                      task: task
                                  )
                          ),
                        );
                        if (updatedTask != null) {
                          await TaskLocalDb.updateTask(updatedTask);

                          setState(() {
                            tasksFuture = loadTasks();
                          });
                        }
                      },
                      onChanged: (value) async {
                          final updatedTask = Task(
                              id: task.id,
                              title: task.title,
                              deadline: task.deadline,
                              done: value!
                          );
                          await TaskLocalDb.updateTask(updatedTask);

                          setState(() {
                            tasksFuture = loadTasks();
                          });
                      }
                  ));
            },
          );
        });
  }
}
