import 'package:flutter/material.dart';
import 'taskRepo.dart';
import 'taskCard.dart';
import 'manipulateTasks.dart';

void main() {
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
                  child: ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return Dismissible(
                          key: ValueKey(task.title),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (direction) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("rm: ${task.title}"),
                              )
                            );
                            TaskRepository.remove(index); // chyba potrzebne zeby na task nie wrocil
                          },
                          child: TaskCard(
                            title: task.title,
                            subtitle: task.deadline,
                            icon: Icons.eighteen_mp_sharp,
                            done: task.done,
                            onTap: () async {
                              final realIndex = TaskRepository.task.indexOf(task);
                              // trzeba zrobic real index poniewaz filteredTask tworzy
                              // kopie i nowa liste, indexy nie sa zawsze takie same
                              final Task? updatedTask = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditTaskScreen(
                                        task: task
                                    )
                                ),
                              );
                              if (updatedTask != null) {
                                setState(() {
                                  TaskRepository.task[realIndex] = updatedTask;
                              });
                              }
                            },
                            onChanged: (value) async {
                              final realIndex = TaskRepository.task.indexOf(task);
                              setState(() {
                                TaskRepository.task[realIndex] = Task(
                                  title: task.title,
                                  deadline: task.deadline,
                                  done: value!
                                );
                              });
                            }
                      ));
                    }),),
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
                                        TaskRepository.task.clear();
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




