import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BoostProfileScreen extends StatefulWidget {
  @override
  _BoostProfileScreenState createState() => _BoostProfileScreenState();
}

class _BoostProfileScreenState extends State<BoostProfileScreen> {
  String tutorEmail;
  NetworkStatus _networkStatus;
  List packageList;
  var subscription;
  bool canBoost;
  String boostDetailsUrl = "https://guarded-beyond-19031.herokuapp.com/boost";

  @override
  void initState() {
    super.initState();
    _getPreferences();
    _networkStatus = NetworkStatus.LOADING;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Boost Profile"),
      ),
      body: _boostPackagesContainer(),
    );
  }

  Widget _boostPackagesContainer() {
    switch (_networkStatus) {
      case NetworkStatus.LOADING:
        return Center(
          child: CircularProgressIndicator(),
        );

      case NetworkStatus.COMPLETE:
        return Scaffold(
          body: Container(
            child: Column(
              children: <Widget>[],
            ),
          ),
        );

      case NetworkStatus.FAILED:
        return Center(
          child: Text("Failed to load"),
        );
    }
  }

  void _getBoostDetails() async {
    var boostBody = {"tutor": "$tutorEmail"};

    await http.post(boostDetailsUrl, body: boostBody).then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);

      setState(() {
        _networkStatus = NetworkStatus.COMPLETE;
      });

      if (res["success"] == true) {
        canBoost = res["boost"];
        packageList = res["packages"];
        subscription = res["data"];
      } else {
        _networkStatus = NetworkStatus.FAILED;
      }
    });
  }

  Widget _packageDetailes() {
    return SizedBox(
      height: 200.0,
      width: 200.0,
      child: Card(
        child: Stack(
          children: <Widget>[

          ],
        ),
      ),
    );
  }

  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tutorEmail = prefs.getString("email");
      _getBoostDetails();
    });
  }
}

enum NetworkStatus { COMPLETE, LOADING, FAILED }
