import 'package:final_project/widgets/build_text.dart';
import 'package:flutter/material.dart';
import 'package:final_project/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class NoteForm extends StatefulWidget {
  final Map? todolist;

  const NoteForm({required this.todolist, Key? key}) : super(key: key);

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  var userData;

  bool isEdit = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final todo = widget.todolist;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final desc = todo['description'];
      titleController.text = title;
      descController.text = desc;
    }
  }
  void _getInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString("user");
    var user = convert.jsonDecode(userJson.toString());
    setState(() {
      userData = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Color(0xFF00BCD4),
            Color(0xFF26C6DA),
            Color(0xFF4DD0E1),
            Color(0xFF80DEEA),
          ])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: 50,
            elevation: 0.5,
            backgroundColor: const Color(0xFF0097A7),
            shadowColor: const Color(0xFF006064),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50))),
            title: Image(image: AssetImage('assets/logo.png')),
          ),
          body: Card(
            color: const Color(0xFFE0F7FA),
            elevation: 10,
            shadowColor: const Color(0xFF00838F),
            shape: const BeveledRectangleBorder(
                side: BorderSide(color: Color(0xFF0097A7), width: 1.0),
                borderRadius:
                    BorderRadius.only(topLeft: Radius.elliptical(25, 50))),
            child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      isEdit ? 'Update Note' : 'Add Note',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.blueGrey,
                      ),
                    ),
                    buildTextField('Title', titleController),
                    buildTextField2('Description', descController),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          isEdit ? updateNote() : addNote();
                        },
                        child: Text(isEdit ? 'Update Note' : 'Add Note')),
                    const SizedBox(height: 40,)
                  ],
                )),
          )),
    );
  }

  void addNote() async {
    _getInfo();
    var data = {
      'userID': userData['id'],
      'title': titleController.text,
      'description': descController.text
    };
    await CallApi().addNote(data, 'add');
    Navigator.pop(context, data);
  }

  void updateNote() async {
    var data = {
      'id': widget.todolist!['id'],
      'title': titleController.text,
      'description': descController.text
    };
    await CallApi().updateData(data, 'update');
    Navigator.pop(context, widget.todolist);
  }
}
