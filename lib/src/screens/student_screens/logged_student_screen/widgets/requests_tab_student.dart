import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestsTab extends StatefulWidget {
  @override
  _RequestsTabState createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  NetworkStatus _networkStatus;
  List sentReqList;

  int reqId;
  int listItemIndex;
  String studentEmail;
  String viewReqUrl =
      "https://guarded-beyond-19031.herokuapp.com/viewMyRequests";
  String cancelReqUrl =
      "https://guarded-beyond-19031.herokuapp.com/cancelRequest";

  @override
  Widget build(BuildContext context) {
    switch (_networkStatus) {
      case NetworkStatus.LOADING:
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );

      case NetworkStatus.COMPLETE:
        if (sentReqList.isEmpty) {
          return Container(
            child: Container(
              child: Center(
                child: Text("Nothing to show..."),
              ),
            ),
          );
        } else {
          return Container(
            child: Container(
              child: _sentReqList(),
            ),
          );
        }
        break;
      case NetworkStatus.FAILED:
        return Container(
          child: Center(
            child: Text("Falid loading! Check connection..."),
          ),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    _getStudentEmail();
    _networkStatus = NetworkStatus.LOADING;
    print("init called");
  }

  Widget _sentReqList() {
    return ListView.builder(
      itemCount: sentReqList == null ? 0 : sentReqList.length,
      itemBuilder: (BuildContext context, index) {
        return _listItem(index);
      },
    );
  }

  Future<String> _getSentRequestsList() async {
    var sentReqBody = {'student': '$studentEmail'};

    await http
        .post(Uri.encodeFull(viewReqUrl), body: sentReqBody)
        .then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);
      setState(() {
        _networkStatus = NetworkStatus.COMPLETE;
        sentReqList = res['request'];
      });
    });
    return 'response';
  }

  Future<String> _cancelSentRequests() async {
    var cancelReqBody = {'id': '$reqId'};

    await http
        .post(Uri.encodeFull(cancelReqUrl), body: cancelReqBody)
        .then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);
      if (res['success'] == true) {
        setState(() {
          sentReqList = res['request'];
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return _resultDialog("Success!");
              });
        });
      } else {
        setState(() {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return _resultDialog("Failed!");
              });
        });
      }
    });
    return 'response';
  }

  void _getStudentEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      studentEmail = prefs.getString("email");
      print(studentEmail);
      _getSentRequestsList();
    });
  }

  Widget _listItem(int index) {
    List<String> split = sentReqList[index]["sent_date"].split('T');

    return Card(
      elevation: 3.0,
      child: ListTile(
        title: Text(sentReqList[index]["FirstName"] +
            " " +
            sentReqList[index]["LastName"]),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Subject: " + sentReqList[index]["subject"]),
            Text("Day: " + sentReqList[index]["day"]),
            Text("Location: " + sentReqList[index]["location"]),
            Text("Status: " + sentReqList[index]["status"]),
            Text("Sent Date: " + split[0]),
          ],
        ),
        trailing: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              reqId = sentReqList[index]["id"];
              listItemIndex = index;
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _warningDialog();
                  });
            }),
      ),
    );
  }

  Widget _warningDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      contentPadding: EdgeInsets.all(5.0),
      title: Text("Do you want to cancel this request?"),
      content: ButtonBar(
        children: <Widget>[
          FlatButton(
            child: Text(
              'No',
              style: TextStyle(fontSize: 16.0),
            ),
            textColor: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(
              'Yes',
              style: TextStyle(fontSize: 16.0),
            ),
            textColor: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
              _cancelSentRequests();
            },
          ),
        ],
      ),
    );
  }

  Widget _resultDialog(String msg) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      contentPadding: EdgeInsets.all(0.0),
      title: Text(msg),
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
              Navigator.of(context).popAndPushNamed('/student_logged');
            },
          ),
        ],
      ),
    );
  }
}

enum NetworkStatus { COMPLETE, LOADING, FAILED }
