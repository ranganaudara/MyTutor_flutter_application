import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedbackScreenTutor extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreenTutor> {
  String feedbackUrl =
      "https://guarded-beyond-19031.herokuapp.com/makeSuggestion";
  String myEmail;
  String feedbackContent;
  final feedbackTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feedback')),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 160.0,
                  width: 160.0,
                  child: Image.asset('assets/images/feedback.png'),
                ),
                SizedBox(height: 20.0),
                Text(
                  "Say what you think bout our platform...",
                  style: TextStyle(fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                _textArea(),
                SizedBox(height: 20.0),
                _submitButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendFeedback() async {
    var feedBackBody = {"email": "$myEmail", "content": "$feedbackContent"};

    print(feedBackBody);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return buildLoadingDialog();
        });

    await http.post(feedbackUrl, body: feedBackBody).then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);

      Navigator.pop(context);

      if (res["success"] == true) {
        _successDialog("Success!");
      } else {
        _resultDialog("Failed! Try again!");
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return _successDialog("Success!");
          });
    });
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
        controller: feedbackTextController,
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
          print("pressed");
          feedbackContent = feedbackTextController.text;
          print(feedbackContent);
          if (feedbackContent == '') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return _resultDialog("Oops! You have written nothing!");
              },
            );
          } else {
            _sendFeedback();
          }
        });
      },
    );
  }

  Widget buildLoadingDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListTile(
          leading: CircularProgressIndicator(),
          title: Text('Loading...'),
        ),
      ),
    );
  }

  Widget _resultDialog(String msg) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      contentPadding: EdgeInsets.all(0.0),
      title: Text(
        msg,
        textAlign: TextAlign.center,
      ),
      content: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text(
              'OK',
              style: TextStyle(fontSize: 16.0),
            ),
            textColor: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _successDialog(String msg) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      contentPadding: EdgeInsets.all(0.0),
      title: Text(
        msg,
        textAlign: TextAlign.center,
      ),
      content: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text(
              'OK',
              style: TextStyle(fontSize: 16.0),
            ),
            textColor: Colors.black,
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/teacher_logged',
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myEmail = prefs.getString("email");
    });
  }
}
