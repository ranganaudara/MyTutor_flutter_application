import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About us'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _logo(),
            SizedBox(height: 15.0),
            Text("Contact us:", style: TextStyle(fontSize: 18.0),),
            SizedBox(height: 18.0),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('0711765356'),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('teaminsomniac@gmail.com'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logo() {
    return Center(
      child: SizedBox(
        width: 250,
        height: 250,
        child: Image.asset('assets/images/InsomniacIcon.png'),
      ),
    );
  }
}
