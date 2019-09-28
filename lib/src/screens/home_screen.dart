import 'package:flutter/material.dart';
import 'package:tutor_app_new/src/screens/choose_user_screen.dart';
import 'package:tutor_app_new/src/widgets/top_tachers_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 320.0,
                  color: Colors.grey[300],
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(height: 12.0),
                      _logo(),
                      _welcomeText(),
                      SizedBox(height: 8.0),
                      _startButton(),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
                SizedBox(height: 12.0),
                Container(
                  height: 15.0,
                  child: Text(
                    'Top Rated Teachers',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 300.0,
                  child: TopTeachersList(),
                )
              ],
            ),
          ],
        ),
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

  Widget _welcomeText() {
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            "eTutor",
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Pacifito',
            ),
          ),
          SizedBox(height: 8.0),
          Center(
            child: Text('Join with us to find the best Teacher for your need!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ],
      ),
    );
  }

  Widget _startButton() {
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
            MaterialPageRoute(builder: (context) => ChooseUser()),
          );
        },
        child: Text(
          'Start Using eTutor...',
          style: TextStyle(fontSize: 16.0, color: Colors.black87),
        ),
      ),
    );
  }
}
