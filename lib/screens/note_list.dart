import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/screens/details_page.dart';
import 'package:note_keeper/screens/note_detail.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:strings/strings.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList; //this helps bring out our notelist
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(' Note List'),
      ),
      body: getNoteListView(),
      // Creating a FAB at the bottom

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB Clicked');
          navigateToDetail(Note('', '', 2), 'Add Note'); // top bar text
        },
        tooltip: 'add new Note',
        child: Icon(Icons.add),
      ),
    );
  }

//Let Us create the notelist view here:
  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white70,
          elevation: 20.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  //using icon and color defined
                  getPriorityColor(this.noteList[position].priority),
              child: getPriorityIcon(this.noteList[position].priority),
            ),
            title: Text(capitalize(this.noteList[position].title),
                style: titleStyle),
            subtitle: Text(this.noteList[position].date),
            trailing: Column(
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.delete, color: Colors.grey),
                  onTap: () {
                    _delete(context, noteList[position]);
                  },
                ),
                GestureDetector(
                  child: Icon(Icons.remove_red_eye, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailsPage(
                                  noteListTitle: this.noteList[position].title,
                                  noteListDescription:
                                      this.noteList[position].description,
                                  noteDate: this.noteList[position].date,
                                )));
                  },
                ),
              ],
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.noteList[position], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  // creating two helper class:
  // 1. returns the priority color based on the priority:
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  //2. to return the priority Icon:
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.star);
        break;
      case 2:
        return Icon(Icons.play_arrow);
        break;
      default:
        return Icon(Icons.play_arrow);
    }
  }

  // creating a Delete function to the button, and Notification snackbar
  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView(); // updates list view after deleting
    }
  }

  // function for snackbar:
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  // creating a function to use in different places
  // this is what updates the list page without clicking reload up here

  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NoteDetail(note, title)));

    if (result == true) {
      updateListView();
    }
  }

  // update list view function
  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
