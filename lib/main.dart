import 'package:flutter/material.dart';
import 'package:flutterhivefsqulit/screens/add_todo.dart';
import 'package:flutterhivefsqulit/screens/update_todo.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'client/hive_name.dart';
import 'models/todo.dart';


void main() async {
  //   hive initialization
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>(HiveBoxes.todo);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() async {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Todo Hive Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Todo>(HiveBoxes.todo).listenable(),
        builder: (context, Box<Todo> box, _) {
          if (box.values.isEmpty)
            return Center(
              child: Text("Todo list is empty"),
            );
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              print(index);
              Todo res = box.getAt(index);

              return Dismissible(
                background: Container(color: Colors.red),
                key: UniqueKey(),
                onDismissed: (direction) {
                  res.delete();
                },
                child: ListTile(
                    title: Text(res.task == null ? '' : res.task),
                    subtitle: Text(res.note == null ? '' : res.note),
                    onTap: () {
                      res.complete = !res.complete;
                      res.save();
                      print(index);
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => UpdateTodo(res.task,res.note,index)));
                    }),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddTodo())),
        tooltip: 'Add todo',
        child: Icon(Icons.add),
      ),
    );
  }
}