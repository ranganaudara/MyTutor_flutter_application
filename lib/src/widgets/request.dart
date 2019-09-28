import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_app_new/src/models/district_list.dart';

class RequestWidget extends StatefulWidget {
  @override
  _RequestWidgetState createState() => _RequestWidgetState();
}

class _RequestWidgetState extends State<RequestWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String requestUrl = "https://guarded-beyond-19031.herokuapp.com/makeRequest";
  String _currentSubjectSelected;
  String _currentDaySelected;
  String _currentLocationSelected;
  String _day;
  String _subject;
  String _location;
  String _studentEmail;
  String _tutorEmail;

  List<String> subjectList = ["Mathematics", "Physics", "Biology", "Chemistry"];

  List<String> days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Satarday"
  ];

  @override
  void initState() {
    super.initState();
    _getEmail();
  }

  @override
  Widget build(BuildContext context) {
    //subjectList = widget.myTutor['subject'];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Send Request"),
      ),
      body: Center(
        child: Container(
          width: 300.0,
          height: 400.0,
          child: Card(
            elevation: 3.0,
            color: Colors.grey[300],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 15.0,
                ),
                Text('Choose the Day', style: TextStyle(fontSize: 20.0)),
                _chooseDay(),
                SizedBox(
                  height: 15.0,
                ),
                Text('Choose the Subject', style: TextStyle(fontSize: 20.0)),
                _chooseSubject(),
                SizedBox(
                  height: 15.0,
                ),
                Text('Choose the Location', style: TextStyle(fontSize: 20.0)),
                _chooseLocation(),
                SizedBox(
                  height: 15.0,
                ),
                _submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      height: 40.0,
      width: 100.0,
      child: RaisedButton(
        color: Colors.blue[300],
        child: Text("Submit"),
        onPressed: () {
          if (_day == null || _location == null || _subject == null) {
            _showSnackBar('Please fill out every field!');
          } else {
            _sendRequest();
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  Widget _chooseSubject() {
    return Container(
      child: DropdownButton<String>(
        items: subjectList.map((dropDownItem) {
          return DropdownMenuItem<String>(
            value: dropDownItem,
            child: Text(dropDownItem),
          );
        }).toList(),
        onChanged: (String valueSelected) {
          _onDropDownSubjectSelected(valueSelected);
        },
        value: _currentSubjectSelected,
        hint: Text('Select a Day'),
      ),
    );
  }

  Widget _chooseDay() {
    return Container(
      child: DropdownButton<String>(
        items: days.map((dropDownItem) {
          return DropdownMenuItem<String>(
            value: dropDownItem,
            child: Text(dropDownItem),
          );
        }).toList(),
        onChanged: (String valueSelected) {
          _onDropDownDaySelected(valueSelected);
        },
        value: _currentDaySelected,
        hint: Text('Select a Subject'),
      ),
    );
  }

  Widget _chooseLocation() {
    return Container(
      child: DropdownButton<String>(
        items: districtList.map((dropDownItem) {
          return DropdownMenuItem<String>(
            value: dropDownItem,
            child: Text(dropDownItem),
          );
        }).toList(),
        onChanged: (String valueSelected) {
          _onDropDownLocationSelected(valueSelected);
        },
        value: _currentLocationSelected,
        hint: Text('Select a Location'),
      ),
    );
  }

  void _onDropDownSubjectSelected(String valueSelected) {
    setState(() {
      this._currentSubjectSelected = valueSelected;
      this._subject = valueSelected;
    });
  }

  void _onDropDownDaySelected(String valueSelected) {
    setState(() {
      this._currentDaySelected = valueSelected;
      this._day = valueSelected;
    });
  }

  void _onDropDownLocationSelected(String valueSelected) {
    setState(() {
      this._currentLocationSelected = valueSelected;
      this._location = valueSelected;
    });
  }

  void _sendRequest() async {
    Map<String, dynamic> requestBody = {
      "student": "$_studentEmail",
      "tutor": "$_tutorEmail",
      "day": "$_day",
      "location": "$_location",
      "subject": "$_subject",
    };

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return buildLoadingDialog();
        });

    http.post(requestUrl, body: requestBody).then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);
      Navigator.pop(context);
      setState(() {
        if (res['success'] == true) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/student_logged',
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.pop(context);
          _showSnackBar("Request send failed!");
        }
        print(res['success']);
      });
    });
  }

  _getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _studentEmail = prefs.getString("email");
      _tutorEmail = prefs.get("selectedTutorEmail");
    });
  }

  Widget buildLoadingDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListTile(
          leading: CircularProgressIndicator(),
          title: Text('Loading...'),
        ),
      ),
    );
  }

  void _showSnackBar(String msg) {
    final snackBar = SnackBar(
      content: Text(
        '$msg',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.blueGrey,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}

//Map<String, dynamic> res,
