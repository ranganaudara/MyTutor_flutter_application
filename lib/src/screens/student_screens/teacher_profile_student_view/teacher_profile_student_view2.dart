import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_app_new/src/models/tutor_model.dart';
import 'package:tutor_app_new/src/widgets/rating.dart';
import 'package:tutor_app_new/src/widgets/request.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

class TeacherProfileStudentView2 extends StatefulWidget {

  @override
  _TeacherProfileStudentView2State createState() =>
      _TeacherProfileStudentView2State();
}

class _TeacherProfileStudentView2State
    extends State<TeacherProfileStudentView2> {
  String getAchievementsUrl =
      "https://guarded-beyond-19031.herokuapp.com/getAchievements";
  String getTeacherUrl =
      'https://guarded-beyond-19031.herokuapp.com/viewProfile';

  String noImgUrl = "https://desmoines.spagworks.com/noimage.gif";
  List achievementList = List();
  List achievementsWithHidden = List();
  String profilePicUrl;
  String tutorEmail;
  MediaQueryData queryData;
  String rate;
  NetworkStatus _networkStatus;
  NetworkStatus _networkStatus2;
  Tutor myTutor;

  @override
  void initState() {
    super.initState();
    _networkStatus = NetworkStatus.LOADING;
    _networkStatus2 = NetworkStatus.LOADING;
    _getPreferences();

  }

  @override
  Widget build(BuildContext context) {

    queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(height: 8.0),
                _description(),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [_reqButton(), _rateButton()],
                ),
                SizedBox(height: 10.0)
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.white,
            child: Center(
              child: Text(
                "Best Achievements...",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
          _achievementsViewer(),
          SizedBox(height: 20.0)
        ],
      ),
    );
  }

  Widget _reqButton() {
    return Container(
      height: 50.0,
      child: RaisedButton(
        color: Colors.lightBlueAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.person_add,
              color: Colors.white,
            ),
            Text('Request'),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RequestWidget(),
            ),
          );
        },
      ),
    );
  }

  Widget _rateButton() {
    return Container(
      height: 50.0,
      child: RaisedButton(
        color: Colors.lightBlueAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.rate_review,
              color: Colors.white,
            ),
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

  Widget _description() {
    switch (_networkStatus2) {
      case NetworkStatus.LOADING:
        return Container(
          height: 600.0,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );

      case NetworkStatus.COMPLETE:
        return Column(
          children: <Widget>[
            SizedBox(height: 15.0),
            _circleImage(myTutor.imgUrl),
            SizedBox(height: 10.0),
            Text(
              '${myTutor.fname} ${myTutor.lname}',
              style: TextStyle(fontSize: 25.0),
            ),
            SizedBox(height: 5.0),
            _descriptionText(myTutor.description),
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
                  myTutor.rating == 0 ? '0' : "${myTutor.rating}",
                  style: TextStyle(fontSize: 17.0),
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: _emailText(myTutor.email),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: _locationText(myTutor.location),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: _mobileText(myTutor.mobile),
            ),
            ListTile(
              leading: Icon(Icons.library_books),
              title: _subjectText(myTutor.subject),
            ),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: _priceText(myTutor.price),
            ),
            ListTile(
              leading: Icon(Icons.event_available),
              title: _availableTimeText(myTutor.available),
            ),
          ],
        );

      case NetworkStatus.FAILED:
        return Center(
          child: Text("Failed to load"),
        );
    }
  }

  Future<String> _getTeacherDetails() async {
    var teacherDetailsBody = {
      'email': '$tutorEmail',
      'role': 'tutor'
    };
    await http
        .post(Uri.encodeFull(getTeacherUrl), body: teacherDetailsBody)
        .then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);

      setState(() {
        _networkStatus2 = NetworkStatus.COMPLETE;
        myTutor = Tutor.fromJson(res);
      });
    });
    return "Sucess";
  }

  Future<String> _getAchievements() async {
    var getAchievementsBody = {
      "tutor": "$tutorEmail",
    };

    await http
        .post(getAchievementsUrl, body: getAchievementsBody)
        .then((dynamic response) {
      var res = json.decode(response.body);
      setState(() {

        achievementsWithHidden = res["achievements"];

        for(int i = 0; i < achievementsWithHidden.length; i++){
          if(achievementsWithHidden[i]["hide"]==1){
            achievementList.add(achievementsWithHidden[i]);
          }
        }
        _networkStatus = NetworkStatus.COMPLETE;

      });

      print(achievementList);
    });
  }

  Widget _achievementsViewer() {
    switch (_networkStatus) {
      case NetworkStatus.LOADING:
        return Container(
          height: 300.0,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );

      case NetworkStatus.COMPLETE:
        if (achievementList.length == 0) {
          return Container(
            height: 300.0,
            child: Center(
              child: Text("Nothing to show..."),
            ),
          );
        } else {
          return CarouselSlider(
            items: achievementList.map((index) {
              return new Builder(
                builder: (BuildContext context) {
                  return new Container(
                    width: MediaQuery.of(context).size.width,
                    margin: new EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: new BoxDecoration(
                      image: DecorationImage(
                        image: _carousalBackground(index['ImgUrl']),
//                            image: NetworkImage(achievementList[index]["ImgUrl"]== null ?noImgUrl: achievementList[index]["ImgUrl"]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: _achievementCard(index),
                  );
                },
              );
            }).toList(),
            height: 300.0,
            autoPlay: true,
          );
        }
        break;
      case NetworkStatus.FAILED:
        return Container(
          child: Center(
            child: Text("Failed Loading..."),
          ),
        );
    }
  }

  Widget _achievementCard(index) {
    return SizedBox.expand(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              index["title"],
              style: TextStyle(fontSize: 17.0),
            ),
          ),
          Positioned(
            top: 250,
            left: 20,
            child: Container(
              width: queryData.size.width * 0.5,
              child: Text(
                index["description"],
                style: TextStyle(fontSize: 17.0),
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleImage(String url) {
    if (url == null) {
      return CircleAvatar(
        child: Image(image: AssetImage('assets/images/user.png')),
        maxRadius: 80.0,
        minRadius: 45.0,
        backgroundColor: Colors.transparent,
      );
    } else {
      return CircleAvatar(
        maxRadius: 80.0,
        minRadius: 45.0,
        backgroundImage: NetworkImage(url),
      );
    }
  }

  Widget _emailText(String email) {
    if (email == null || email == 'undefined' || email == '')
      return Text(
        "Not entered",
        style: TextStyle(fontSize: 20.0),
      );
    else
      return Text(
        '$email',
        style: TextStyle(fontSize: 20.0),
      );
  }

  Widget _locationText(String location) {
    if (location == null || location == 'undefined' || location == '')
      return Text(
        "Not entered",
        style: TextStyle(fontSize: 20.0),
      );
    else
      return Text(
        '$location',
        style: TextStyle(fontSize: 20.0),
      );
  }

  Widget _mobileText(String mobile) {
    if (mobile == null)
      return Text(
        "Not entered",
        style: TextStyle(fontSize: 20.0),
      );
    else
      return Text(
        '$mobile',
        style: TextStyle(fontSize: 20.0),
      );
  }

  Widget _descriptionText(String description) {
    if (description == null || description == 'undefined' || description == '')
      return Text(
        "Not entered",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15.0),
      );
    else
      return Text(
        '$description',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 17.0,
        ),
      );
  }

  Widget _subjectText(String subject) {
    if (subject == null || subject == 'undefined' || subject == '')
      return Text(
        "Not entered",
        style: TextStyle(fontSize: 20.0),
      );
    else
      return Text(
        '$subject',
        style: TextStyle(fontSize: 20.0),
      );
  }

  Widget _priceText(var price) {
    if (price == null || price == 'undefined' || price == '')
      return Text(
        "Not entered",
        style: TextStyle(fontSize: 20.0),
      );
    else
      return Text(
        'Rs. $price per Hour',
        style: TextStyle(fontSize: 20.0),
      );
  }

  Widget _availableTimeText(String available) {
    if (available == null)
      return Text(
        "Not entered",
        style: TextStyle(fontSize: 20.0),
      );
    else
      return Text(
        'Available Time : $available',
        style: TextStyle(fontSize: 20.0),
      );
  }

  NetworkImage _carousalBackground(String url) {
    if (url == "undefined" || url == null || url == '') {
      return NetworkImage(noImgUrl);
    } else {
      return NetworkImage(url);
    }
  }

  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tutorEmail = prefs.getString("selectedTutorEmail");
    });
    _getTeacherDetails();
    _getAchievements();
  }

}

enum NetworkStatus { LOADING, COMPLETE, FAILED }
