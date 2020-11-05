class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

// i will put the non mandatory field in a square bracket eg: [description]
  Note(this._title, this._date, this._priority, [this._description]);

// this contains the id, and we have to give it a constructor
  Note.withId(this._id, this._title, this._date, this._priority,
      [this._description]);

  // Now create the getter for this fields:

  int get id => _id;

  String get title => _title;

  String get description => _description;

  int get priority => _priority;

  String get date => _date;

  // now we create a setter for the fields and conditions:
  // we will not create that of id becos id is generated automatically:

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  // becos our priority is either high or low:
  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }

  //now for date:
  set date(String newDate) {
    this._date = newDate;
  }

// Now becos flutter uses the MAP to get the SQFlite
// we have to convert everything to Map or Dictionary like python

// Now Convert the Note object into a Map object:

  Map<String, dynamic> toMap() {
    // we use dynamic cos of the different type of values i.e String and int that we input
    var map = Map<String, dynamic>();

    // so the id will not be empty
    if (id != null) {
      map['id'] = _id;
    }
// now we continue normally, still inside the Map:
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

  // Time to Extract from the Database
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
  }
}
