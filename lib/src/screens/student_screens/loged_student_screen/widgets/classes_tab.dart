import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClassesTab extends StatefulWidget {
  @override
  _ClassesTabState createState() => _ClassesTabState();
}

class _ClassesTabState extends State<ClassesTab> {

  List sentReqList;
  String studentEmail;
  String viewReqUrl = "https://guarded-beyond-19031.herokuapp.com/viewMyRequests";

  @override
  void initState() {
    super.initState();
    _getStudentEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          _requestCard(),
        ],
      ),
    );
  }

  Widget _requestCard(){
    return Container(
      child: Card(
        child: _sentReqList(),
      ),
    );
  }

  void getSentRequestsList() async {
    var sentReqBody  = {'student': ''};
    await http
        .post(Uri.encodeFull(viewReqUrl), body: sentReqBody)
        .then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);
      setState(() {
        sentReqList = res['request'];
      });
    });
  }

  _getStudentEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      studentEmail = prefs.getString("email");
    });
  }

  Widget _sentReqList() {
    return Container(
      child: ListView.builder(
        itemCount: sentReqList == null ? Text('Nothing to show') : sentReqList.length,
        itemBuilder: (BuildContext context, index) {
          return Card(
            child: ListTile(
//              leading: CircleAvatar(
//                backgroundImage:
//                NetworkImage(allTutors[index]["imgURL"]),
//              ),
              title: Text(sentReqList[index]["FirstName"]+" "+sentReqList[index]["LastName"]),
              subtitle: Text(sentReqList[index]["sent_date"]),
            ),
          );
        },
      ),
    );
  }

}
