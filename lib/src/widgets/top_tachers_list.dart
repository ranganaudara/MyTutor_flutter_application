import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class TopTeachersList extends StatefulWidget {
  @override
  _TopTeachersListState createState() => _TopTeachersListState();
}

class _TopTeachersListState extends State<TopTeachersList> {
  NetworkStatus _networkStatus;
  String noImgUrl = "https://desmoines.spagworks.com/noimage.gif";
  String url = "https://guarded-beyond-19031.herokuapp.com/highestRate";
  List data;

  @override
  void initState() {
    super.initState();
    _networkStatus = NetworkStatus.LOADING;
    this.makeRequest();
  }

  Future<String> makeRequest() async {
    try {
      var response = await http.get(
        Uri.encodeFull(url),
        headers: {"Accept": "application/json"},
      );
      setState(() {
        _networkStatus = NetworkStatus.COMPLETE;
        var res = json.decode(response.body);
        data = res["tutorList"];
        print(data);
      });
    } catch (e) {
      print('Exception:=> $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_networkStatus) {
      case NetworkStatus.LOADING:
        return Center(
          child: CircularProgressIndicator(),
        );
      case NetworkStatus.COMPLETE:
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
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    SizedBox(width: 10.0),
                    Text(data[index]["rate"] == null
                        ? '0'
                        : "${data[index]["rate"].toStringAsFixed(1)}"),
                  ],
                ),
                onTap: () {},
              ),
            );
          },
        );
        
      case NetworkStatus.FAILED:
        return Center(child: Text("Something went wrong..."),);
    }
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

enum NetworkStatus { COMPLETE, LOADING, FAILED }
