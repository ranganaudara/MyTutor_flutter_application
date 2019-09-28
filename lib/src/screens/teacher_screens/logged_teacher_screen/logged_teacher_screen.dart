import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_app_new/src/screens/teacher_screens/logged_teacher_screen/widgets/request_tab_teacher.dart';
import 'package:tutor_app_new/src/screens/teacher_screens/logged_teacher_screen/widgets/students_tab.dart';
import 'package:tutor_app_new/src/screens/teacher_screens/logged_teacher_screen/widgets/teacher_drawer.dart';

class LoggedTeacherScreen extends StatefulWidget {
  @override
  _LoggedTeacherScreenState createState() => _LoggedTeacherScreenState();
}

class _LoggedTeacherScreenState extends State<LoggedTeacherScreen> {
  String myFName;
  String myLName;
  String myEmail;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Center(child: Text("Hello! $myFName $myLName!")),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.person),
                text: 'Classes',
              ),
              Tab(
                icon: Icon(Icons.book),
                text: 'Requests',
              ),
              Tab(
                icon: Icon(Icons.chat),
                text: 'ChatRoom',
              ),
            ],
          ),
        ),
        drawer: TeacherDrawer(
          fname: myFName,
          lname: myLName,
          email: myEmail,
        ),
        body: TabBarView(
          children: <Widget>[
            StudentsTab(),
            RequestsTab(),
            Icon(Icons.chat_bubble_outline),
          ],
        ),
      ),
    );
  }

  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myFName = prefs.getString("myFName");
      myLName = prefs.getString("myLName");
      myEmail = prefs.getString("email");

      print(myEmail);
    });
  }
}
