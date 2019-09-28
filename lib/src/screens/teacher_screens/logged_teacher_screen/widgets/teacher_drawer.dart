import 'package:flutter/material.dart';
import 'package:tutor_app_new/src/screens/about_screen/contact_screen.dart';
import 'package:tutor_app_new/src/screens/teacher_screens/boost_profile_screen/boost_profile_screen.dart';
import 'package:tutor_app_new/src/screens/teacher_screens/feedback_screen_tutor/feedback_tutor.dart';
import 'package:tutor_app_new/src/screens/teacher_screens/teacher_profile/teacher_profile.dart';
class TeacherDrawer extends StatelessWidget {
  final String fname;
  final String lname;
  final String email;

  TeacherDrawer({Key key, this.fname, this.lname, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('$fname '+ lname),
            accountEmail: Text('$email'),
            currentAccountPicture: CircleAvatar(
              child: Image(image: AssetImage('assets/images/user.png')),
              maxRadius: 30,
              minRadius: 10,
              backgroundColor: Colors.transparent,
            ),
          ),
          ListTile(
            title: Text('My Profile'),
            leading: Icon(Icons.person),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TeacherProfile(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Feedback'),
            leading: Icon(Icons.feedback),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedbackScreenTutor(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('About'),
            leading: Icon(Icons.info),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutUsScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Boost your Profile'),
            leading: Icon(Icons.av_timer),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BoostProfileScreen(),
                ),
              );
            },
          ),
          Divider(
            height: 10.0,
          ),
          ListTile(
            title: Text('Log out'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/start_page',
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

}



