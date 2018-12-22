import 'package:flutter/material.dart';
import 'package:tutor_app_new/src/models/tutor_model.dart';
import 'package:tutor_app_new/src/widgets/rating.dart';
import 'package:tutor_app_new/src/widgets/request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherProfile extends StatefulWidget {
  final myTutor;

  TeacherProfile({Key key, this.myTutor}) : super(key: key);

  @override
  _TeacherProfileState createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {
  String url;
  String tutorEmail;
  MediaQueryData queryData;
  var _reviewsViewHeight = 150.0;
  var _classesViewHeight = 150.0;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    tutorEmail = "${widget.myTutor["email"]}";
    queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: queryData.size.height / 2,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(height: 15.0),
                _profilePicture(),
                SizedBox(height: 10.0),
                Text(
                  '${widget.myTutor["fname"]} ${widget.myTutor["lname"]}',
                  style: TextStyle(fontSize: 25.0),
                ),
                SizedBox(height: 5.0),
                Text('${widget.myTutor["subject"]}'),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Colors.green,
                    ),
                    SizedBox(width: 12.0),
                    Text(
                      "${widget.myTutor["rate"]}",
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [reqButton(), rateButton()],
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 100),
            height: _reviewsViewHeight,
            width: queryData.size.width,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: Card(
              child: Column(
                children: <Widget>[
                  Text("Card view"),
                  FlatButton.icon(
                    onPressed: () {
                      setState(() {
                        _reviewsViewHeight > 150.0
                            ? _reviewsViewHeight = 150.0
                            : _reviewsViewHeight = queryData.size.height / 2;
                      });
                    },
                    icon: _iconOfReviewsButton(),
                    label: _nameOfReviewsButton(),
                    //child: _nameOfReviewsButton(),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 100),
            height: _classesViewHeight,
            width: queryData.size.width,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: Card(
              child: Column(
                children: <Widget>[
                  Text("Card view"),
                  FlatButton.icon(
                    onPressed: () {
                      setState(() {
                        _classesViewHeight > 150.0
                            ? _classesViewHeight = 150.0
                            : _classesViewHeight = queryData.size.height / 2;
                      });
                    },
                    icon: _iconOfClassesButton(),
                    label: _nameOfClassesButton(),
                    //child: _nameOfReviewsButton(),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          )
        ],
      ),
    );
  }

  Widget _profilePicture() {
    return CircleAvatar(
      maxRadius: 55.0,
      minRadius: 20.0,
      backgroundImage: NetworkImage(widget.myTutor["imgURL"]),
    );
  }

  Widget _nameOfReviewsButton() {
    if (_reviewsViewHeight > 150.0) {
      return Text("less");
    } else {
      return Text("more");
    }
  }

  Widget _iconOfReviewsButton() {
    if (_reviewsViewHeight > 150.0) {
      return Icon(Icons.keyboard_arrow_up);
    } else {
      return Icon(Icons.keyboard_arrow_down);
    }
  }

  Widget _nameOfClassesButton() {
    if (_classesViewHeight > 150.0) {
      return Text("less");
    } else {
      return Text("more");
    }
  }

  Widget _iconOfClassesButton() {
    if (_classesViewHeight > 150.0) {
      return Icon(Icons.keyboard_arrow_up);
    } else {
      return Icon(Icons.keyboard_arrow_down);
    }
  }

  Widget reqButton() {
    return Container(
      height: 50.0,
      child: RaisedButton(
        color: Colors.lightBlueAccent,
        child: Column(
          children: <Widget>[
            Icon(Icons.person_add),
            Text('Request'),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RequestWidget(myTutor: widget.myTutor),
            ),
          );
        },
      ),
    );
  }

  Widget rateButton() {
    return Container(
      height: 50.0,
      child: RaisedButton(
        color: Colors.lightBlueAccent,
        child: Column(
          children: <Widget>[
            Icon(Icons.rate_review),
            Text('Rate'),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RatingWidget(tutorEmail: tutorEmail)),
          );
        },
      ),
    );
  }

}
