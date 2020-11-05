import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';
// import 'dart:async';
// import 'package:sqflite/sqflite.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _priorities = ['High', 'Low']; //dropdown values

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;

// controller for editing values:
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.bodyText2;

    titleController.text = note.title;
    descriptionController.text = note.description;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            //First element
            ListTile(
              title: DropdownButton(
                items: _priorities.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),
                style: textStyle,
                value: getPriorityAsString(note.priority),
                onChanged: (valueSelectedByUser) {
                  setState(() {
                    debugPrint('User Selected $valueSelectedByUser');
                    updatePriorityAsInt(valueSelectedByUser);
                  });
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),

            /// Second Element: Text fields
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint('Something changed in the title text field ');
                  updateTitle();
                },
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),

            // Third Element:
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                keyboardType: TextInputType.multiline,
                maxLength: null,
                maxLines: null,
                onChanged: (value) {
                  debugPrint('Something changed in the description field ');
                  updateDescription();
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            // Creating Buttons on a row:

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text('Save', textScaleFactor: 1.5),
                        onPressed: () {
                          setState(() {
                            debugPrint('Save button Pressed');
                            _save();
                          });
                        }),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text('Delete', textScaleFactor: 1.5),
                        onPressed: () {
                          setState(() {
                            debugPrint('Delete button Pressed');
                            _delete();
                          });
                        }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Convert the String priority to the form of integer (int) before saving it to database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  // now Convert int priority to String and Display to our user in the drop down
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority;
  }

  // update the Title of our Note object;
  void updateTitle() {
    note.title = titleController.text;
  }

  // update the description of our Note object
  void updateDescription() {
    note.description = descriptionController.text;
  }

  // Save to database when save button is clicked
  void _save() async {
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      // Case 1: Update operation
      result = await helper.updateNote(note);
    } else {
      // Case 2: Insert operation
      result = await helper.insertNote(note);
    }
    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: if User is trying to delete the New Note i.e he has come to
    // the detail page by pressing the FAB of NoteList page.

    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }
    // Case 2: User is trying to delete the old note which already has  valid ID.
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error occurred while Deleting Note');
    }
  }

// function code to display Alert dialog:
  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  // function to automatically go back navigation button
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
