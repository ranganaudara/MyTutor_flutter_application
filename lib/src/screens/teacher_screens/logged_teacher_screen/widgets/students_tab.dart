import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StudentsTab extends StatefulWidget {
  @override
  _StudentsTabState createState() => _StudentsTabState();
}

class _StudentsTabState extends State<StudentsTab> {
  NetworkStatus _networkStatus;
  List studentList;
  int reqId;
  String deleteClassUrl = "https://guarded-beyond-19031.herokuapp.com/unshowRequest";
  String noImgUrl = "https://desmoines.spagworks.com/noimage.gif";
  String getStudentsUrl =
      "https://guarded-beyond-19031.herokuapp.com/getAcceptedStudents";
  String tutorEmail;

  @override
  void initState() {
    super.initState();
    _networkStatus = NetworkStatus.LOADING;
    _getPreferences();
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
        if (studentList.isNotEmpty) {
          return Container(
            child: Container(
              child: _showstudentsList(),
            ),
          );
        }
        return Container(
          child: Center(
              child: Text(
            "Nothing to show...",
            style: TextStyle(fontSize: 15.0),
          )),
        );

      case NetworkStatus.FAILED:
        return Container(
          child: Center(
            child: Text("Falid loading! Check connection..."),
          ),
        );
    }
  }

  Future<String> _getStudents() async {
    var getStudentsBody = {"tutor": "$tutorEmail"};

    await http
        .post(getStudentsUrl, body: getStudentsBody)
        .then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);

      _networkStatus = NetworkStatus.COMPLETE;
      setState(() {
        studentList = res["students"];
      });
    });
  }

  Widget _showstudentsList() {
    return Container(
      child: ListView.builder(
        itemCount: studentList == null ? 0 : studentList.length,
        itemBuilder: (BuildContext context, index) {
          return _listItem(index);
        },
      ),
    );
  }

  Widget _listItem(int index) {
    return Card(
//      elevation: 3.0,
      child: ListTile(
        leading: _showProfileImage(studentList[index]["ImgUrl"]),
        title: Text(
          studentList[index]["name"],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Subject: " + studentList[index]["subject"]),
            Text("Day: " + studentList[index]["day"]),
            Text("Location: " + studentList[index]["location"]),
          ],
        ),
        trailing: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              reqId = studentList[index]["reqID"];
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _deleteWarningDialog();
                  });
            }),
      ),
    );
  }

  Widget _deleteWarningDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      contentPadding: EdgeInsets.all(5.0),
      title: Text("Do you want to delete this class?"),
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
              _deleteClassRequest();
              setState(() {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _loadingDialog();
                  },
                );
              });
            },
          ),
        ],
      ),
    );
  }

  void _deleteClassRequest() async {
    var deleteClassReqBody = {"id": "$reqId"};

    print(deleteClassReqBody);

    await http
        .post(deleteClassUrl, body: deleteClassReqBody)
        .then((dynamic response) {
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
  }

  Widget _showProfileImage(String url) {
    if (url == "undefined" || url == null || url == '') {
      return SizedBox(
        height: 70.0,
        width: 70.0,
        child: Image(
          image: AssetImage('assets/images/user.png'),
        ),
      );
    } else {
      return SizedBox(
        height: 70.0,
        width: 70.0,
        child: Image.network(url),
      );
    }
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
      _getStudents();
    });
  }
}

enum NetworkStatus { COMPLETE, LOADING, FAILED }
