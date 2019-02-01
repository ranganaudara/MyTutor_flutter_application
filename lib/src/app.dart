import 'package:flutter/material.dart';
import 'package:tutor_app_new/src/screens/choose_user_screen.dart';
import 'package:tutor_app_new/src/screens/home_screen.dart';
import 'package:tutor_app_new/src/screens/student_screens/logged_student_screen/logged_student_screen.dart';
import 'package:tutor_app_new/src/screens/student_screens/logged_student_screen/widgets/requests_tab_student.dart';
import 'package:tutor_app_new/src/screens/student_screens/login_screen_student/login_screen_student.dart';
import 'package:tutor_app_new/src/screens/student_screens/register_screen_student/register_screen_student.dart';
import 'package:tutor_app_new/src/screens/teacher_screens/logged_teacher_screen/logged_teacher_screen.dart';
import 'package:tutor_app_new/src/screens/teacher_screens/login_screen_teacher/login_screen_teacher.dart';
import 'package:tutor_app_new/src/screens/teacher_screens/register_screen_teacher/register_screen_teacher.dart';

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: 'Tutor App',
      home: Scaffold(
        body: HomeScreen(),
      ),
      routes: <String, WidgetBuilder>{
        '/choose_user': (BuildContext context)=> ChooseUser(),
        '/student_login': (BuildContext context)=> StudentLoginScreen(),
        '/student_logged': (BuildContext context)=> LoggedInStudent(),
        '/student_register': (BuildContext context)=> StudentRegisterScreen(),
        '/teacher_logged': (BuildContext context)=> LoggedTeacherScreen(),
        '/teacher_login': (BuildContext context)=> TeacherLoginScreen(),
        '/teacher_register': (BuildContext context)=> TeacherRegisterScreen(),
        '/start_page':(BuildContext context)=> HomeScreen(),
        '/student_requests' : (BuildContext context)=> RequestsTab(),
      },
    );
  }
}