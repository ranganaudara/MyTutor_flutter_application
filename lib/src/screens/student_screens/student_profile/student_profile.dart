import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_app_new/src/models/student_model.dart';
import 'package:tutor_app_new/src/screens/student_screens/student_profile/student_profile_edit.dart';

class StudentProfile extends StatefulWidget {
  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  NetworkStatus _networkStatus;

  MediaQueryData queryData;
  String studentEmail;
  Student student;

  @override
  void initState() {
    super.initState();
    _networkStatus = NetworkStatus.LOADING;
    _getStudentEmail();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Builder(builder: (context) {
        switch (_networkStatus) {
          case NetworkStatus.LOADING:
            return Center(child: CircularProgressIndicator());

          case NetworkStatus.COMPLETE:
            return ListView(
              children: <Widget>[
                Container(
                 height: queryData.size.height,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 15.0),
                      _circleImage(student.image),
                      SizedBox(height: 10.0),
                      Text(
                        '${student.name}',
                        style: TextStyle(fontSize: 25.0),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: _emailText(student.email),
                      ),
                      ListTile(
                        leading: Icon(Icons.location_on),
                        title: _locationText(student.location),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: _mobileText(student.mobile),
                      ),
                      _editButton()
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                )
              ],
            );
          case NetworkStatus.FAILED:
            return Center(
              child: Column(
                children: <Widget>[
                  Text('Error loading! Check your connection...'),
                  IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        _getStudentDetails();
                      })
                ],
              ),
            );
        }
      }),
    );
  }

  Widget _circleImage(String url) {
    if (url == null) {
      return CircleAvatar(
        child: Image(image: AssetImage('assets/images/user.png')),
        maxRadius: 55.0,
        minRadius: 20.0,
        backgroundColor: Colors.transparent,
      );
    } else {
      return CircleAvatar(
        backgroundImage: NetworkImage(url),
      );
    }
  }

  Widget _emailText(String email) {
    if (email == null)
      return Text("Not entered");
    else
      return Text(
        '$email',
        style: TextStyle(fontSize: 20.0),
      );
  }

  Widget _locationText(String location) {
    if (location == null)
      return Text("Not entered");
    else
      return Text(
        '$location',
        style: TextStyle(fontSize: 20.0),
      );
  }

  Widget _mobileText(String mobile) {
    if (mobile == null)
      return Text("Not entered");
    else
      return Text(
        '$mobile',
        style: TextStyle(fontSize: 20.0),
      );
  }

  Widget _editButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(32.0),
        color: Colors.blueAccent,
        shadowColor: Colors.blueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 150.0,
          height: 45.0,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfile()),
            );
          },
          child: Text('Edit'),
        ),
      ),
    );
  }

  Future<String> _getStudentDetails() async {
    var url = 'https://guarded-beyond-19031.herokuapp.com/viewProfile';

    var body = {'email': '$studentEmail', 'role': 'student'};
    print(body);
    http.post(url, body: body).then((dynamic response) {
      Map<String, dynamic> res = jsonDecode(response.body);
      setState(() {
        _networkStatus = NetworkStatus.COMPLETE;
        student = new Student.fromJson(res);
        //print(student.name);
      });
    });
  }


  _getStudentEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      studentEmail = prefs.getString("email");
      print(studentEmail);
      _getStudentDetails();
    });
  }
}

enum NetworkStatus { LOADING, COMPLETE, FAILED }
