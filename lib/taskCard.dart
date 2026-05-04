import 'package:flutter/material.dart';
import 'taskRepo.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool done;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onChanged;

  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.done,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 100),
      child: Card(
        child: ListTile(
          onTap: onTap,
          leading: Checkbox(
              value: done,
              onChanged: onChanged
          ),
          title: Text(
            title,
            style: TextStyle(
              decoration: done ? TextDecoration.lineThrough : TextDecoration.none,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: done ? Colors.black : Colors.blue,
            ),
          ),
          subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(subtitle),Text(done.toString())]),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}