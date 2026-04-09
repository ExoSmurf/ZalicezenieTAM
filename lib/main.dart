import 'package:flutter/material.dart';
import 'taskRepo.dart';

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

  @override
  Widget build(BuildContext context) {
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
                  Center(child: Text("Masz dziś ${TaskRepository.task.length} zadania",
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
                    itemCount: TaskRepository.task.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                          title: TaskRepository.task[index].title,
                          subtitle: TaskRepository.task[index].deadline,
                          icon: Icons.eighteen_mp_sharp,
                          done: TaskRepository.task[index].done
                      );
                    }),)
                ],
              ),
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final Task? newTask = await Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddTaskScreen(),)
            );
            if (newTask != null) {
              setState(() {
                TaskRepository.task.add(newTask);
              });
            }
          },
          child: Icon(Icons.add),
        ),
        );
  }
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
          subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(subtitle),Text(done.toString())]),
        ),
      ),
    );
  }
}

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
