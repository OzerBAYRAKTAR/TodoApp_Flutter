import 'package:flutter/material.dart';
import 'package:todo_app_flutter/data/local_storage.dart';
import 'package:todo_app_flutter/main.dart';
import 'package:todo_app_flutter/models/task_model.dart';
import 'package:todo_app_flutter/widgets/task_list_item.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTasks;

  CustomSearchDelegate({required this.allTasks});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isNotEmpty) {
            query = '';
            showSuggestions(context); // Optional: refreshes the UI
          }
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
        onTap: () {
          close(context, null);
        },
        child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 24));
  }

  @override
  Widget buildResults(BuildContext context) {
    var filteredList = allTasks
        .where(
            (gorev) => gorev.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredList.length >0 ? ListView.builder(
      itemBuilder: (context, index) {
        var _oankiListeElemani = filteredList[index];
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
          onDismissed: (direction) async {
            filteredList.removeAt(index);
            await locator<LocalStorage>().deleteTask(task: _oankiListeElemani);
          },
          child: TaskListItem(task: _oankiListeElemani),
        );
      },
      itemCount: filteredList.length,
    ) : const Center(child: Text('Aradığınızı bulamadık!'),);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
