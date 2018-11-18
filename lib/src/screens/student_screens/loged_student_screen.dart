import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LogedInStudent extends StatefulWidget {
  @override
  _LogedInStudentState createState() => _LogedInStudentState();
}

class _LogedInStudentState extends State<LogedInStudent> {
  String url = "https://guarded-beyond-19031.herokuapp.com/search";
  List data;

  @override
  void initState() {
    super.initState();
    this.makeRequest();
  }

  Future<String> makeRequest() async {
    var body = {'district': 'all', 'subject': 'all'};

    var response = await http
        .post(
      Uri.encodeFull(url),
      body: body,
    )
        .then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);

      print(res);

      setState(() {
        data = res["user"];
      });

      print(data[0]["fname"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Hello User!")),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(

      ),
      body: Container(
        child: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, index) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(data[index]["imgURL"]),
                ),
                title: Text(data[index]["fname"] + " " + data[index]["lname"]),
                subtitle: Text(data[index]["subject"]),
                onTap: () {},
              ),
            );
          },
        ),
      ),
    );
  }
}
