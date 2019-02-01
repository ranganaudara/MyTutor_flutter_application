import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tutor_app_new/src/widgets/rating.dart';
import 'package:tutor_app_new/src/widgets/request.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class TeacherProfileStudentView extends StatefulWidget {
  final myTutor;
  TeacherProfileStudentView({Key key, this.myTutor}) : super(key: key);

  @override
  _TeacherProfileStudentViewState createState() =>
      _TeacherProfileStudentViewState();
}

class _TeacherProfileStudentViewState extends State<TeacherProfileStudentView> {
  String getAchievementsUrl =
      "https://guarded-beyond-19031.herokuapp.com/getAchievements";

  String noImgUrl = "https://desmoines.spagworks.com/noimage.gif";
  List achievementList;
  String profilePicUrl;
  String tutorEmail;
  MediaQueryData queryData;
  String rate;
  NetworkStatus _networkStatus;

  @override
  void initState() {
    super.initState();
    rate = widget.myTutor["rate"].toString();
    rate = rate.length > 3 ? rate.substring(0, 3) : rate;
    _networkStatus = NetworkStatus.LOADING;
    _getAchievements();
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
            padding: EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(height: 15.0),
                _backgroundImage(widget.myTutor["imgURL"]),
                SizedBox(height: 10.0),
                Text(
                  '${widget.myTutor["fname"]} ${widget.myTutor["lname"]}',
                  style: TextStyle(fontSize: 25.0),
                ),
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Colors.green,
                    ),
                    SizedBox(width: 12.0),
                    Text(
                      widget.myTutor["rate"] == '' ? '0' : "$rate",
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ],
                ),
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
          SizedBox(height: 15.0)
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
              builder: (context) => RequestWidget(myTutor: widget.myTutor),
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

  Widget _backgroundImage(String profilePicUrl) {
    if (profilePicUrl == null) {
      return CircleAvatar(
        child: Image(image: AssetImage('assets/images/user.png')),
        maxRadius: 55.0,
        minRadius: 20.0,
        backgroundColor: Colors.transparent,
      );
    } else {
      return CircleAvatar(
        backgroundImage: NetworkImage(profilePicUrl),
      );
    }
  }

  Widget _description() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text(
            widget.myTutor['location'] == ''
                ? 'Not Entered'
                : widget.myTutor['location'],
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text(
            widget.myTutor['mobile'] == ''
                ? 'Not Entered'
                : widget.myTutor['mobile'],
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        ListTile(
          leading: Icon(Icons.attach_money),
          title: Text(
            widget.myTutor['price'] == ''
                ? 'Not Entered'
                : "Rs. " + (widget.myTutor['price']).toString() + ' per hour',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ],
    );
  }

  Future<String> _getAchievements() async {
    var getAchievementsBody = {
      "tutor": "${widget.myTutor["email"]}",
    };

    await http
        .post(getAchievementsUrl, body: getAchievementsBody)
        .then((dynamic response) {
      var res = json.decode(response.body);
      setState(() {
        achievementList = res["achievements"];
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

  NetworkImage _carousalBackground(String url) {
    if (url == "undefined" || url == null || url == '') {
      return NetworkImage(noImgUrl);
    } else {
      return NetworkImage(url);
    }
  }
}

enum NetworkStatus { LOADING, COMPLETE, FAILED }
