import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_app_new/src/models/district_list.dart';
import 'package:tutor_app_new/src/screens/teacher_screens/teacher_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LogedInStudent extends StatefulWidget {
  @override
  _LogedInStudentState createState() => _LogedInStudentState();
}

class _LogedInStudentState extends State<LogedInStudent> {
  String _currentSubjectSelected;
  String _currentDistrictSelected;
  final searchController = TextEditingController();
  String _district = "all";
  String _subject = "all";
  String _searchKey;
  String urlForSubject = 'https://guarded-beyond-19031.herokuapp.com/subject';
  String urlForAll = "https://guarded-beyond-19031.herokuapp.com/search";

  List allTutors;
  List subjectList = [''];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this.getAllTutors();
    this.getAllSubjects();
  }

  //<<<<<<<<<< Snack Bar >>>>>>>>>>>>

  void _showSnackBar() {
    final snackBar = SnackBar(
      content: Text(
        'Oops! Couldn\'t find any teacher!',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.blueGrey,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  //<<<<<<<<<<<Get all subjects>>>>>>>>>.

  Future<String> getAllSubjects() async {
    var res = await http.get(urlForSubject);
    var resBody = json.decode(res.body);
    setState(() {
      subjectList = resBody['subject'];
    });

    return "Sucess";
  }
//<<<<<<<<<<Get Tutors>>>>>>>>>>

  Future<String> getAllTutors() async {
    var allTutorsBody = {'district': '$_district', 'subject': '$_subject'};
    await http
        .post(Uri.encodeFull(urlForAll), body: allTutorsBody)
        .then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);

      print(res);

      setState(() {
        allTutors = res["user"];
        if (allTutors.isEmpty) {
          _showSnackBar();
        }
      });

      print(allTutors);
    });
    return "Sucess";
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
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
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.person),
                text: 'Teachers',
              ),
              Tab(
                icon: Icon(Icons.book),
                text: 'Classes',
              ),
              Tab(
                icon: Icon(Icons.chat),
                text: 'ChatRoom',
              ),
            ],
          ),
        ),
        drawer: Drawer(),
        body: TabBarView(
          children: <Widget>[
            _containerBox(),
            Icon(Icons.chat_bubble_outline),
          ],
        ),
      ),
    );
  }

  Widget _teachersList() {
    return Container(
      child: ListView.builder(
        itemCount: allTutors == null ? 0 : allTutors.length,
        itemBuilder: (BuildContext context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage:
                NetworkImage(allTutors[index]["imgURL"]),
              ),
              title: Text(allTutors[index]["fname"]+" "+allTutors[index]["lname"]),
              subtitle: Text(allTutors[index]["location"]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherProfile(myTutor: allTutors[index],)),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _title() {
    return Container(
      child: Text(
        'Filter Teachers',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _subjectButton() {
    return DropdownButton<String>(
      items: subjectList == null
          ? null
          : subjectList.map((dropDownItem) {
        return DropdownMenuItem<String>(
          value: dropDownItem,
          child: Text(dropDownItem),
        );
      }).toList(),
      onChanged: (String valueSelected) {
        _onDropDownSubjectSelected(valueSelected);
      },
      value: _currentSubjectSelected,
      hint: Text('Filter by subject'),
    );
  }

  Widget _districtButton() {
    return DropdownButton<String>(
      items: districtList.isEmpty
          ? null
          : districtList.map((dropDownItem) {
        return DropdownMenuItem<String>(
          value: dropDownItem,
          child: Text(dropDownItem),
        );
      }).toList(),
      onChanged: (String valueSelected) {
        _onDropDownDistrictSelected(valueSelected);
      },
      value: _currentDistrictSelected,
      hint: Text('Filter by district'),
    );
  }

  Widget _searchBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Please enter a search term',
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Material(
              borderRadius: BorderRadius.circular(32.0),
              color: Colors.blueAccent,
              shadowColor: Colors.blueAccent.shade100,
              elevation: 5.0,
              child: MaterialButton(
                minWidth: 150.0,
                height: 45.0,
                onPressed: () {
                  setState(() {
                    _searchKey = searchController.text;
                  });
                },
                child: Text('Search'),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _containerBox() {
    return Column(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                _title(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _subjectButton(),
                    _districtButton(),
                  ],
                ),
                _searchBox(),
              ],
            )),
        Expanded(
          flex: 1,
          child: _teachersList(),
        ),
      ],
    );
  }

  void _onDropDownSubjectSelected(String valueSelected) {
    setState(() {
      this._currentSubjectSelected = valueSelected;
      this._subject = valueSelected;
      getAllTutors();
    });
  }

  void _onDropDownDistrictSelected(String valueSelected) {
    setState(() {
      this._currentDistrictSelected = valueSelected;
      this._district = valueSelected;
      getAllTutors();
    });
  }
  _getEmailPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String myEmail = prefs.getString("email");
      print(myEmail);
    });
  }
}