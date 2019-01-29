import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class VerticalList extends StatefulWidget {
  @override
  _VerticalListState createState() => _VerticalListState();
}

class _VerticalListState extends State<VerticalList> {
  String url = "https://guarded-beyond-19031.herokuapp.com/highestRate";
  List data;

  @override
  void initState() {
    super.initState();
    this.makeRequest();
  }

  Future<String> makeRequest() async {
    try{
      var response = await http.get(
        Uri.encodeFull(url),
        headers: {"Accept": "application/json"},
      );
      setState(() {
        var res = json.decode(response.body);
        data = res["tutorList"];
      });
    } catch (e){
      print('Exception:=> $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, index) {
        return Card(
          child: ListTile(
            leading: _circleImage(data[index]["img"]),
            title: Text(data[index]["name"]),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.star,color: Colors.yellow,),
                SizedBox(width: 10.0),
                Text(data[index]["rate"]==null?'0':"${data[index]["rate"].toStringAsFixed(1)}"),
              ],
            ),
            onTap: () {
            },
          ),
        );
      },
    );
  }

  Widget _circleImage(String url) {
    if (url == null) {
      return CircleAvatar(
        child: Image(image: AssetImage('assets/images/user.png')),
        maxRadius: 20.0,
        minRadius: 5.0,
        backgroundColor: Colors.transparent,
      );
    } else {
      return CircleAvatar(
        backgroundImage: NetworkImage(url),
      );
    }
  }
}
