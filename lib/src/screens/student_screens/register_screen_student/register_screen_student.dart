import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:tutor_app_new/src/mixins/validator_mixin.dart';
import 'package:tutor_app_new/src/screens/student_screens/email_verification_student/email_verification_student.dart';

class StudentRegisterScreen extends StatefulWidget {
  @override
  _StudentRegisterScreenState createState() => _StudentRegisterScreenState();
}

class _StudentRegisterScreenState extends State<StudentRegisterScreen>
    with ValidatorMixin {
  String url = 'https://guarded-beyond-19031.herokuapp.com/register';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String email;
  String password;
  String firstName;
  String lastName;
  String city;
  String contactNumber;
  String userName;
  String checkPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo(),
              SizedBox(height: 8.0),
              welcomeText(),
              SizedBox(height: 13.0),
              _firstNameField(),
              SizedBox(height: 8.0),
              _lastNameField(),
              SizedBox(height: 8.0),
              _emailField(),
              SizedBox(height: 8.0),
              _passwordField(),
              SizedBox(height: 8.0),
              _confirmPasswordField(),
              SizedBox(height: 8.0),
              Container(margin: EdgeInsets.only(bottom: 25.0)),
              _registerButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget logo() {
    return Center(
      child: CircleAvatar(
        child: Image(image: AssetImage('assets/images/student_login.png')),
        maxRadius: 40.0,
        minRadius: 10.0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget welcomeText() {
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            "eTutor",
            style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                fontFamily: "Pacifito"),
          ),
          Text(
            'Enter your details',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _firstNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'First Name',
        hintText: 'Buddhika',
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter first name';
        }
      },
      onSaved: (String value) {
        this.firstName = value;
      },
    );
  }

  Widget _lastNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Last name',
        hintText: 'Chathuranga',
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter last name';
        }
      },
      onSaved: (String value) {
        this.lastName = value;
      },
    );
  }

  Widget _emailField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'name@email.com',
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: emailValidator,
      onSaved: (String value) {
        this.email = value;
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'password',
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      ),
      obscureText: true,
      validator: passwordValidator,
      onSaved: (String value) {
        this.password = value;
      },
    );
  }

  Widget _confirmPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        hintText: 'password',
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      ),
      obscureText: true,
      validator: confirmPassword,
      onSaved: (String value) {
        this.checkPassword = value;
      },
    );
  }

  Widget _registerButton() {
    return Material(
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
            _sendUserDetails();
          }
        },
        child: Text('Register'),
      ),
    );
  }

  void _sendUserDetails() async {
    var body = {
      'fname': firstName,
      'lname': lastName,
      'email': email,
      'password': password,
      'role': "student"
    };

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return _buildLoadingDialog();
        });

    print(body);

    http.post(url, body: body).then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);
      Navigator.pop(context);
      print(res);
      if (res['success'] == true) {
        print(res['msg']);
        _savePreference();
      }else if(res['success'] == false && res['has'] == true){
        invalidAuth("User already exists!!");
      }else{
        invalidAuth("Something went wrong! Try again!");
      }
    });
  }

  void invalidAuth(String msg) {
    setState(() {
      _showSnackBar(msg);
      _formKey.currentState.reset();
    });
  }

  _showSnackBar(String msg) {
    final snackBar = SnackBar(
      content: Text(
        msg,
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.blueGrey,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget _buildLoadingDialog() {
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


  _savePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("studentRegEmail", email);

      Navigator.of(context).pushNamed('/student_verification');
    });
  }
}
