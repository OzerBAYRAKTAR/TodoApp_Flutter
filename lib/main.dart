import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app_flutter/data/local_storage.dart';
import 'package:todo_app_flutter/models/task_model.dart';
import 'package:todo_app_flutter/pages/home_page.dart';

final locator = GetIt.instance;

void setUp() {
  locator.registerSingleton<LocalStorage>(HiveLocalStorage());
}

Future<void> setUpHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  var taskBox = await Hive.openBox<Task>('tasks');
  for (var task in taskBox.values) {
    if(task.createdAt.day != DateTime.now().day) {
      taskBox.delete(task.id);
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  await setUpHive();
  setUp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        home: const HomePage());
  }
}
