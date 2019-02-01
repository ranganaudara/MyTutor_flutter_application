import 'package:flutter/material.dart';
import 'package:tutor_app_new/src/screens/student_screens/student_profile/student_profile.dart';
import 'package:tutor_app_new/src/screens/about_screen/contact_screen.dart';
class CustomDrawer extends StatelessWidget {
  final String name;

  //String imageUrl;
  final String email;

  CustomDrawer({Key key, this.name, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('$name'),
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
                  builder: (context) => StudentProfile(),
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
                  builder: (context) => StudentProfile(),
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
