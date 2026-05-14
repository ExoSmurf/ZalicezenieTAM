import 'task_api_service.dart';
import 'task_local_db.dart';

class TaskSyncService {
  static Future<void> loadInitialDataIfNeeded() async {
    if (!TaskLocalDb.isEmpty()) {
      print("db istnieje, returnowane");
      return;
    }
    final tasks = await TaskApiService.fetchTasks();
    await TaskLocalDb.saveTasks(tasks);
  }
}