import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RatingWidget extends StatefulWidget {
  final String tutorEmail;
  RatingWidget({Key key, this.tutorEmail}) : super(key: key);

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  final reviewController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String review;
  String rateUrl = "https://guarded-beyond-19031.herokuapp.com/rate";
  String reviewUrl = "https://guarded-beyond-19031.herokuapp.com/writeReview";
  double rate = 0.0;
  String studentEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rate Tutor"),
      ),
      key: _scaffoldKey,
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          children: <Widget>[
            SizedBox(height: 30.0),
            Container(
              child: Center(
                child: Text(
                  "Your Rating",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            SizedBox(height: 15.0),
            _starRating(),
            SizedBox(height: 15.0),
            Container(
              child: Center(
                child: Text(
                  "Your Review",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            SizedBox(height: 15.0),
            _textArea(),
            SizedBox(height: 35.0),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  Future<String> rateTutor() async {
    Map<String, dynamic> bodyForRateRq = {
      "rate": "$rate",
      "tutor": "${widget.tutorEmail}",
      "student": "$studentEmail",
    };

    http.post(rateUrl, body: bodyForRateRq).then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);
    });

    return "Success";
  }

  Future<String> reviewTutor() async {
    Map<String, dynamic> bodyForReview = {
      "student": "$studentEmail",
      "tutor": "${widget.tutorEmail}",
      "content": "$review",
    };

    http.post(reviewUrl, body: bodyForReview).then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);
      _showSnackBar(res);
    });
    return "Success";
  }

  @override
  void initState() {
    super.initState();
    _getStudentEmail();
  }

  void _showSnackBar(Map<String, dynamic> res) {
    final snackBar = SnackBar(
      content: res['allowed']
          ? Text(
              'Rating process succefull!',
              style: TextStyle(color: Colors.white),
            )
          : Text(
              'Oops! You are not allowed to rate or review!',
              style: TextStyle(color: Colors.white),
            ),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.blueGrey,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget _starRating() {
    return StarRating(
      size: 25.0,
      rating: rate,
      color: Colors.orange,
      borderColor: Colors.grey,
      starCount: 5,
      onRatingChanged: (rating) => setState(() {
            this.rate = rating;
            print(this.rate);
          }),
    );
  }

  Widget _textArea() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(),
        right: BorderSide(),
        left: BorderSide(),
      )),
      height: 159.0,
      width: 350.0,
      child: TextField(
        controller: reviewController,
        keyboardType: TextInputType.multiline,
        maxLength: 150,
        maxLines: 7,
      ),
    );
  }

  Widget _submitButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.blue,
      child: Text(
        'Submit',
        style: TextStyle(fontSize: 15.0),
      ),
      onPressed: () {
        setState(() {
          review = reviewController.text;
          print(review);
          rateTutor();
          reviewTutor();
        });
      },
    );
  }

  _getStudentEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      studentEmail = prefs.getString("email");
    });
  }
}
