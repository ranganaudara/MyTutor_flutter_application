import 'package:flutter/material.dart';
import 'package:tutor_app_new/src/models/tutor_model.dart';

class TeacherProfile extends StatefulWidget {

  final myTutor;

  TeacherProfile({Key key, this.myTutor}) : super (key: key);

  @override
  _TeacherProfileState createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {
  String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.deepOrange,
              child: Column(
                children: <Widget>[
                  _profilePicture(),
                  Text('${widget.myTutor["fname"]}'),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _profilePicture() {
    return CircleAvatar(
      maxRadius: 60.0,
      minRadius: 20.0,
      backgroundImage: NetworkImage(widget.myTutor["imgURL"]),
    );
  }
}
