import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_app_new/src/models/tutor_model.dart';
import 'package:tutor_app_new/src/screens/teacher_screens/teacher_profile/teacher_profile_edit.dart';
import 'package:tutor_app_new/src/widgets/image_upload.dart';

class TeacherProfile extends StatefulWidget {
  @override
  _TeacherProfileState createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {
  MediaQueryData queryData;
  Tutor myTutor;
  String myEmail;
  NetworkStatus _networkStatus;
  String getTeachersUrl =
      'https://guarded-beyond-19031.herokuapp.com/viewProfile';

  @override
  void initState() {
    super.initState();
    _getPreferences();
    _networkStatus = NetworkStatus.LOADING;
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Builder(
        builder: (context) {
          switch (_networkStatus) {
            case NetworkStatus.LOADING:
              return Center(child: CircularProgressIndicator());

            case NetworkStatus.COMPLETE:
              return ListView(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 15.0),
                        InkWell(
                          radius: 80.0,
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ImageUpload()),
                            );
                          },
                          child: _circleImage(myTutor.imgUrl),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          '${myTutor.fname} ' + '${myTutor.lname}',
                          style: TextStyle(fontSize: 25.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            SizedBox(width: 10.0),
                            Text(myTutor.rating==null? '0' :myTutor.rating.toStringAsFixed(1)),
                          ],
                        ),
                        Container(
                          width: queryData.size.width * 0.9,
                          child: Center(
                              child: _descriptionText(myTutor.description)),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.email),
                          title: _emailText(myTutor.email),
                        ),
                        ListTile(
                          leading: Icon(Icons.location_on),
                          title: _locationText(myTutor.location),
                        ),
                        ListTile(
                          leading: Icon(Icons.phone),
                          title: _mobileText(myTutor.mobile),
                        ),
                        ListTile(
                          leading: Icon(Icons.library_books),
                          title: _subjectText(myTutor.subject),
                        ),
                        ListTile(
                          leading: Icon(Icons.monetization_on),
                          title: _priceText(myTutor.price),
                        ),
                        ListTile(
                          leading: Icon(Icons.event_available),
                          title: _availableTimeText(myTutor.available),
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
                          _getTeacherDetails();
                        })
                  ],
                ),
              );
          }
        },
      ),
    );
  }

  Future<String> _getTeacherDetails() async {
    var teacherDetailsBody = {'email': '$myEmail', 'role': 'tutor'};
    await http
        .post(Uri.encodeFull(getTeachersUrl), body: teacherDetailsBody)
        .then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);

      print('>>>>>> $res');

      setState(() {
        print('<<<<<<<<<<<<<< $res');
        _networkStatus = NetworkStatus.COMPLETE;
        myTutor = Tutor.fromJson(res);

        print(myTutor.fname);
      });
    });
    return "Sucess";
  }

  Widget _circleImage(String url) {
    if (url == null) {
      return CircleAvatar(
        child: Image(image: AssetImage('assets/images/user.png')),
        maxRadius: 80.0,
        minRadius: 45.0,
        backgroundColor: Colors.transparent,
      );
    } else {
      return CircleAvatar(
        maxRadius: 80.0,
        minRadius: 45.0,
        backgroundImage: NetworkImage(url),
      );
    }
  }

  Widget _emailText(String email) {
    if (email == null || email == 'undefined' || email == '')
      return Text("Not entered", style: TextStyle(fontSize: 20.0),);
    else
      return Text(
        '$email',
        style: TextStyle(fontSize: 20.0),
      );
  }

  Widget _locationText(String location) {
    if (location == null || location == 'undefined' || location == '')
      return Text("Not entered",style: TextStyle(fontSize: 20.0),);
    else
      return Text(
        '$location',
        style: TextStyle(fontSize: 20.0),
      );
  }

  Widget _mobileText(String mobile) {
    if (mobile == null)
      return Text("Not entered",style: TextStyle(fontSize: 20.0),);
    else
      return Text(
        '$mobile',
        style: TextStyle(fontSize: 20.0),
      );
  }

  Widget _descriptionText(String description) {
    if (description == null || description == 'undefined' || description == '')
      return Text(
        "Not entered",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15.0),
      );
    else
      return Text(
        '$description',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 17.0,
        ),
      );
  }

  Widget _subjectText(String subject) {
    if (subject == null || subject == 'undefined' || subject == '')
      return Text("Not entered",style: TextStyle(fontSize: 20.0),);
    else
      return Text(
        '$subject',
        style: TextStyle(fontSize: 20.0),
      );
  }

  Widget _priceText(var price) {
    if (price == null || price == 'undefined' || price == '')
      return Text("Not entered",style: TextStyle(fontSize: 20.0),);
    else
      return Text(
        'Rs. $price per Hour',
        style: TextStyle(fontSize: 20.0),
      );
  }

  Widget _availableTimeText(String available) {
    if (available == null)
      return Text("Not entered",style: TextStyle(fontSize: 20.0),);
    else
      return Text(
        'Available Time : $available',
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
              MaterialPageRoute(builder: (context) => EditTutorProfile()),
            );
          },
          child: Text('Edit'),
        ),
      ),
    );
  }

  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myEmail = prefs.getString("email");
      _getTeacherDetails();
    });
  }
}

enum NetworkStatus { LOADING, COMPLETE, FAILED }
