import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:todo_app_flutter/data/local_storage.dart';
import 'package:todo_app_flutter/main.dart';
import 'package:todo_app_flutter/widgets/custom_search_delegate.dart';
import 'package:todo_app_flutter/widgets/task_list_item.dart';

import '../models/task_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTasks = <Task>[];
    _getAllTasksFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              _showAddTaskBottomSheet(context);
            },
            child: Text(
              'Bugün Neler Yapacaksın?',
              style: TextStyle(color: Colors.black),
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(onPressed: () {
              _showSearchPage();
            }, icon: const Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  _showAddTaskBottomSheet(context);
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        body: _allTasks.isNotEmpty
            ? ListView.builder(
                itemBuilder: (context, index) {
                  var _oankiListeElemani = _allTasks[index];
                  return Dismissible(
                    background: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.grey, 
                        ),
                        SizedBox(width: 20),
                        Text('Bu Görev silindi')
                      ],
                    ),
                    key: Key(_oankiListeElemani.id),
                    onDismissed: (direction) {
                      _allTasks.removeAt(index);
                      _localStorage.deleteTask(task: _oankiListeElemani);
                      setState(() {});
                    },
                    child: TaskListItem(task: _oankiListeElemani),
                  );
                },
                itemCount: _allTasks.length,
              )
            : Center(
                child: Text('Hadi Görev Ekle'),
              ));
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // <-- This is important
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              child: TextField(
                autofocus: true,
                style: TextStyle(fontSize: 24),
                decoration: const InputDecoration(
                  hintText: 'Görev Nedir?',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  Navigator.of(context).pop();
                  if (value.length > 3) {
                    DatePicker.showTimePicker(context, showSecondsColumn: false,
                        onConfirm: (time) async {
                      var yeniEklenecekGorev =
                          Task.create(name: value, createdAt: time);
                      _allTasks.insert(0, yeniEklenecekGorev);
                      await _localStorage.addTask(task: yeniEklenecekGorev);
                      setState(() {});
                    });
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _getAllTasksFromDb() async{
    _allTasks = await _localStorage.getAllTasks();
    setState(() {
    });

  }

  void _showSearchPage() async {
   await showSearch(context: context, delegate: CustomSearchDelegate(allTasks: _allTasks));
   _getAllTasksFromDb();
  }
}
