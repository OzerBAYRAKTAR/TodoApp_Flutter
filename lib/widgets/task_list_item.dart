import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_flutter/data/local_storage.dart';
import 'package:todo_app_flutter/main.dart';
import 'package:todo_app_flutter/models/task_model.dart';

class TaskListItem extends StatefulWidget {
  final Task task; // <-- make it final

  const TaskListItem({super.key, required this.task});

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  TextEditingController _taskName = TextEditingController();
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    _taskName.text = widget.task.name;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 2)
          ]),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            widget.task.isCompleted = !widget.task.isCompleted;
            _localStorage.updateTask(task: widget.task);
            setState(() {});
          },
          child: Container(
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
                color: widget.task.isCompleted ? Colors.green : Colors.white,
                border: Border.all(color: Colors.grey, width: 0.8),
                shape: BoxShape.circle),
          ),
        ),
        title: widget.task.isCompleted
            ? Text(
                widget.task.name,
                style: TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                controller: _taskName,
                minLines: 1,
                maxLength: null,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (yeniDeger) {
                  if (yeniDeger.length > 3) {
                    widget.task.name = yeniDeger;
                    _localStorage.updateTask(task: widget.task);
                  }
                },
              ),
        trailing: Text(
          DateFormat('hh:mm a').format(widget.task.createdAt),
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
