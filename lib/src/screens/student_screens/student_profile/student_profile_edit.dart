import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_app_new/src/mixins/validator_mixin.dart';
class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> with ValidatorMixin{
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String url = "https://guarded-beyond-19031.herokuapp.com/editProfile";

  String name;
  String mobile;
  String location;
  String email;

  @override
  void initState() {
    super.initState();
    _getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Center(
        child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(height: 20.0),
                _titleText(),
                SizedBox(height: 20.0),
                _nameField(),
                SizedBox(height: 10.0),
                _locationField(),
                SizedBox(height: 10.0),
                _mobileField(),
                SizedBox(height: 10.0),
                _submitButton(),
              ],
            )),
      ),
    );
  }

  Widget _titleText() {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Text('Enter your new details here!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  Widget _nameField() {
    return TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        labelText: 'Name',
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      ),
      validator: (value) {
        if (value.isEmpty) return 'please enter username';
      },
      onSaved: (String value) {
        this.name = value;
      },
    );
  }

  Widget _mobileField() {
    return TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        icon: Icon(Icons.phone),
        labelText: 'Mobile Number',
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      ),
      validator: mobileValidator,
      keyboardType: TextInputType.numberWithOptions(),
      onSaved: (String value) {
        this.mobile = value;
      },
    );
  }

  Widget _locationField() {
    return TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        icon: Icon(Icons.location_on),
        labelText: 'Location',
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      ),
      validator: (value) {
        if (value.isEmpty) return 'please enter location';
      },
      onSaved: (String value) {
        this.location = value;
      },
    );
  }

  Widget _submitButton() {
    return Padding(
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
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              _submitRequest();
            }
          },
          child: Text(
            'Submit',
            style: TextStyle(fontSize: 17.0),
          ),
        ),
      ),
    );
  }

  Future<String> _submitRequest() async {
    var detailsBody = {
      "email": "$email",
      "name": "$name",
      "mobile": "$mobile",
      "location": "$location",
      "role": "student"
    };

    print(detailsBody);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return buildLoadingDialog();
        });

    await http.put(url, body: detailsBody).then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);
      print(res['success']);
      if (res['success'] == true) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/student_login', (Route<dynamic> route) => false);
      } else if (res['success'] == false) {
        _showSnackBar();
      }
    });
  }

  void _showSnackBar() {
    final snackBar = SnackBar(
      content: Text('Something went wrong! Try Again!'),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.blueGrey,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget buildLoadingDialog() {
    return AlertDialog(
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
      email = prefs.getString("email");
    });
  }
}
