import 'package:hive/hive.dart';

import '../models/task_model.dart';

abstract class LocalStorage {
  Future<void> addTask({required Task task});

  Future<Task> getTask({required String id});

  Future<List<Task>> getAllTasks();

  Future<bool> deleteTask({required Task task});

  Future<Task> updateTask({required Task task});
}

class HiveLocalStorage extends LocalStorage {
  late Box<Task> _taskBox;

  HiveLocalStorage() {
    _taskBox = Hive.box('tasks');
  }

  @override
  Future<void> addTask({required Task task}) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required Task task}) async {
    await task.delete();
    return true;
  }

  @override
  Future<List<Task>> getAllTasks() async {
    List<Task> _allTask = <Task>[];
    _allTask = _taskBox.values.toList();

    if (_allTask.isNotEmpty) {
      _allTask.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return _allTask;
  }

  @override
  Future<Task> getTask({required String id}) async {
    final task = _taskBox.get(id);
    if (task != null) {
      return task;
    } else {
      throw Exception("Task with id $id not found");
    }
  }

  @override
  Future<Task> updateTask({required Task task}) async {
    await task.save();
    return task;
  }
}
