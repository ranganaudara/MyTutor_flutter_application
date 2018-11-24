import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class VerticalList extends StatefulWidget {
  @override
  _VerticalListState createState() => _VerticalListState();
}

class _VerticalListState extends State<VerticalList> {
  String url = "https://randomuser.me/api/?results=10";
  List data;

  @override
  void initState() {
    super.initState();
    this.makeRequest();
  }

  Future<String> makeRequest() async {
    var response = await http.get(
      Uri.encodeFull(url),
      headers: {"Accept": "application/json"},
    );
    setState(() {
      var extractdata = json.decode(response.body);
      data = extractdata["results"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, index) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(data[index]["picture"]["thumbnail"]),
            ),
            title: Text(data[index]["name"]["first"]),
            subtitle: Text(data[index]["location"]["city"]),
            onTap: (){},
          ),
        );
      },
    );
  }

}
