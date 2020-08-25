import 'package:flutter/material.dart';
import 'package:flutterhivefsqulit/client/hive_name.dart';
import 'package:flutterhivefsqulit/models/todo.dart';
import 'package:hive/hive.dart';


class UpdateTodo extends StatefulWidget {
  String task,note;
  int index;
  UpdateTodo(this.task,this.note,this.index);
  final formKey = GlobalKey<FormState>();

  @override
  _UpdateTodoState createState() => _UpdateTodoState();
}

class _UpdateTodoState extends State<UpdateTodo> {
  String task;
  String note;
  int index;
  final _formKey = GlobalKey<FormState>();
  Box<Todo> box;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   // Todo res = box.getAt(0);
   // print(res.task);
   setState(() {
     task=widget.task;
     note=widget.note;
     index=widget.index;
   });
   print(task);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    initialValue: task,
                    decoration: const InputDecoration(
                      labelText: 'Task',
                    ),
                    onChanged: (value) {
                      setState(() {
                        task = value;
                      });
                    },
                    validator: (val) {
                      return val.trim().isEmpty
                          ? 'Task name should not be empty'
                          : null;
                    },
                  ),
                  TextFormField(
                    initialValue: note,
                    decoration: const InputDecoration(
                      labelText: 'Note',
                    ),
                    onChanged: (value) {
                      setState(() {
                        note = value == null ? '' : value;
                      });
                    },
                  ),
                  OutlineButton(
                    child: Text('Update'),
                    onPressed: _validateAndSave,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      _onFormSubmit();
    } else {
      print('form is invalid');
    }
  }

  void _onFormSubmit() {
    Box<Todo> contactsBox = Hive.box<Todo>(HiveBoxes.todo);
    contactsBox.putAt(index, Todo(task: task,note: note));
    Navigator.of(context).pop();
  }
}