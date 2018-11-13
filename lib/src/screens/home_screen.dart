import 'package:flutter/material.dart';
import 'package:tutor_app_new/src/screens/choose_user_screen.dart';
import 'package:tutor_app_new/src/widgets/vertical_list2.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor App'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
              padding: EdgeInsets.only(right: 10.0)),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
              padding: EdgeInsets.only(right: 20.0)),
        ],
      ),
      drawer: Drawer(),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              color: Colors.black12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(height: 12.0),
                  logo(),
                  welcomeText(),
                  SizedBox(height: 8.0),
                  _startButton(),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.0),
          Container(
            child: Text(
              'Trending Techers',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 200.0,
              child: VerticalList(),
            ),
          )
        ],
      ),
    );
  }

  Widget logo() {
    return Center(
      child: CircleAvatar(
        child: Image(image: AssetImage('assets/images/icon.png')),
        maxRadius: 60.0,
        minRadius: 20.0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget welcomeText() {
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            "MyTutor",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Pacifito',
            ),
          ),
          Text('Log in to find your teacher...',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              )),
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
        child: Text('Start Using MyTutor...'),
      ),
    );
  }
}