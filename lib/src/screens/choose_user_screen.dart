import 'package:flutter/material.dart';
import 'package:tutor_app_new/src/screens/student_screens/login_screen_student.dart';
import 'package:tutor_app_new/src/screens/teacher_screens/login_screen_teacher.dart';

class ChooseUser extends StatefulWidget {
  @override
  _ChooseUserState createState() => _ChooseUserState();
}

class _ChooseUserState extends State<ChooseUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to MyTutor!'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 10.0),
          _logo(),
          SizedBox(height: 10.0),
          _text(),
          SizedBox(height: 10.0),
          _loginButton(),
          SizedBox(height: 10.0),
          _registerButton(),
          SizedBox(height: 150.0),

        ],
      ),
    );
  }

  Widget _logo() {
    return Center(
      child: CircleAvatar(
        child: Image(image: AssetImage('assets/images/icon.png')),
        maxRadius: 60.0,
        minRadius: 20.0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _text() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left:24.0, right: 24.0),
        child: Text(
          "Let us know you to make your experience better...",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return Material(
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
            MaterialPageRoute(builder: (context) => TeacherLoginScreen()),
          );
        },
        child: Text('I am a Teacher'),
      ),
    );
  }

  Widget _registerButton() {
    return Material(
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
            MaterialPageRoute(builder: (context) => StudentLoginScreen()),
          );
        },
        child: Text('I am a Student'),
      ),
    );
  }
}
