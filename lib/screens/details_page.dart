import 'package:flutter/material.dart';
import 'package:strings/strings.dart';

class DetailsPage extends StatelessWidget {
  final String noteListTitle;
  final String noteDate;
  final String noteListDescription;

  DetailsPage(
      {Key key, this.noteListDescription, this.noteListTitle, this.noteDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note Details"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 350,
              height: 100,
              color: Colors.green,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      capitalize(noteListTitle),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(noteDate),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(19.0),
            child: Text(capitalize(noteListDescription)),
          ),
        ],
      ),
    );
  }
}
