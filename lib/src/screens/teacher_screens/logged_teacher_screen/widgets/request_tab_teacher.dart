import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestsTab extends StatefulWidget {
  @override
  _RequestsTabState createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  NetworkStatus _networkStatus;
  String tutorEmail;
  List _recievedReqList;
  int reqId;
  String viewReqUrl =
      "https://guarded-beyond-19031.herokuapp.com/viewAllRequests";
  String rejectReqUrl =
      "https://guarded-beyond-19031.herokuapp.com/rejectRequest";
  String acceptReqUrl =
      "https://guarded-beyond-19031.herokuapp.com/acceptRequest";

  @override
  void initState() {
    super.initState();
    _getPreferences();
    _networkStatus = NetworkStatus.LOADING;
  }

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
        if(_recievedReqList.isNotEmpty){
        return Container(
          child: Container(
            child: _showReqList(),
          ),
        );
        }
          return Container(
            child: Center(child: Text("Nothing to show...",style: TextStyle(fontSize: 15.0),)),
          );

      case NetworkStatus.FAILED:
        return Container(
          child: Center(
            child: Text("Falid loading! Check connection..."),
          ),
        );
    }
  }

  Widget _showReqList() {
    return Container(
      child: ListView.builder(
        itemCount: _recievedReqList == null ? 0 : _recievedReqList.length,
        itemBuilder: (BuildContext context, index) {
          return _listItem(index);
        },
      ),
    );
  }

  Widget _listItem(int index) {
    List<String> split = _recievedReqList[index]["sent_date"].split('T');
    return Card(
      elevation: 3.0,
      child: ListTile(
        title: Text(_recievedReqList[index]["student"]),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Subject: " + _recievedReqList[index]["subject"]),
            Text("Day: " + _recievedReqList[index]["day"]),
            Text("Location: " + _recievedReqList[index]["location"]),
            Text("Sent Date: " + split[0]),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  reqId = _recievedReqList[index]["id"];
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _acceptWarningDialog();
                      });
                }),
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  reqId = _recievedReqList[index]["id"];
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _rejectWarningDialog();
                      });
                })
          ],
        ),
      ),
    );
  }

  Future<String> _getRequestsList() async {
    var sentReqBody = {'tutor': '$tutorEmail'};

    await http
        .post(Uri.encodeFull(viewReqUrl), body: sentReqBody)
        .then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);
      setState(() {
        _networkStatus = NetworkStatus.COMPLETE;
        _recievedReqList = res['request'];
        print(_recievedReqList);
      });
    });
    return 'response';
  }

  Widget _rejectWarningDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      contentPadding: EdgeInsets.all(5.0),
      title: Text("Do you want to reject this request?"),
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
              _rejectRequest();
              setState(() {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _loadingDialog();
                    });
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _acceptWarningDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      contentPadding: EdgeInsets.all(5.0),
      title: Text("Do you want to accept this request?"),
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
              _acceptRequest();
              setState(() {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _loadingDialog();
                    });
              });
            },
          ),
        ],
      ),
    );
  }

  Future<String> _rejectRequest() async {
    var rejectReqBody = {"id": "$reqId"};
    print(rejectReqBody);
    print(rejectReqUrl);

    await http.post(rejectReqUrl, body: rejectReqBody).then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);
      Navigator.of(context).pop();

      if (res['success'] == true) {
        setState(() {
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

  Future<String> _acceptRequest() async {
    var acceptReqBody = {"id": "$reqId"};
    print(acceptReqBody);
    print(acceptReqUrl);

    await http.post(acceptReqUrl, body: acceptReqBody).then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);
      Navigator.of(context).pop();

      if (res['success'] == true) {
        setState(() {
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
              Navigator.of(context).popAndPushNamed('/teacher_logged');
            },
          ),
        ],
      ),
    );
  }

  Widget _loadingDialog() {
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

  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tutorEmail = prefs.getString("email");
      _getRequestsList();
      print(tutorEmail);
    });
  }
}

enum NetworkStatus { COMPLETE, LOADING, FAILED }
