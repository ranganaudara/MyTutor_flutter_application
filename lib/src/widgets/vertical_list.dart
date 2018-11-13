import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:tutor_app_new/src/models/trnding_user.dart';
import 'package:tutor_app_new/src/screens/trendings_details.dart';

class VerticalList extends StatefulWidget {
  @override
  _VerticalListState createState() => _VerticalListState();
}

class _VerticalListState extends State<VerticalList> {
  final String url = "https://randomuser.me/api/?results=5000";

  Future<List<User>> _getJsonData() async {
    var data = await http.get(url);
    var jsonData = json.decode(data.body);

    List<User> users = [];

    for (var u in jsonData) {
      User user =
          User(u['index'], u['about'], u['name'], u['email'], u['picture']);
      users.add(user);
    }

    print('list conut: ${users.length}');

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future:
            _getJsonData(), //whatever this returns, will be inside of snapshot parameter
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: Text('Loading...'),
              ),
            );
          } else {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: Colors.black12,
                        height:250.0,
                        width: 250.0,
                        child:
                        Image.network(snapshot.data[index].picture),
                      ),
                      Container(
                        height: 250.0,
                        width: 250.0,
                        child: ListTile(
                          dense: true,
                          title: Text(snapshot.data[index].name),
                          subtitle: Text(snapshot.data[index].email),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TrendingDetails(snapshot.data[index]),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
