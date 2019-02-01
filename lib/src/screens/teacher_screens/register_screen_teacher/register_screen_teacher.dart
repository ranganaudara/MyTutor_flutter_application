import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tutor_app_new/src/mixins/validator_mixin.dart';
import 'package:tutor_app_new/src/screens/teacher_screens/login_screen_teacher/login_screen_teacher.dart';

class TeacherRegisterScreen extends StatefulWidget {
  @override
  _TeacherRegisterScreenState createState() => _TeacherRegisterScreenState();
}

class _TeacherRegisterScreenState extends State<TeacherRegisterScreen>
    with ValidatorMixin {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String invalidMsg = "";
  String email;
  String password;
  String checkPassword;
  String firstName;
  String lastName;
  String city;
  String contactNumber;
  String userName;

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
        child: Image(image: AssetImage('assets/images/teacher_login.png')),
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
            registerRequest();
          }
        },
        child: Text('Register'),
      ),
    );
  }

  void registerRequest() async {
    var url = 'https://guarded-beyond-19031.herokuapp.com/register';

    var body = {
      'role': 'tutor',
      'fname': firstName,
      'lname': lastName,
      'email': email,
      'password': password,
    };

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return buildLoadingDialog();
        });

    print(body);

    http.post(url, body: body).then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);
      print(res);
      if (res['success'] == true) {
        print(res['msg']);
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/teacher_login',
          ModalRoute.withName('/choose_user'),
        );
      } else {
        Navigator.of(context).pop();
        invalidAuth();
      }
    });
  }

  Widget buildLoadingDialog() {
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

  void invalidAuth() {
    setState(() {
      this.invalidMsg = "This user already exists!";
      _showSnackBar(invalidMsg);
      _formKey.currentState.reset();
    });
  }

  _showSnackBar(String invalidMsg) {
    final snackBar = SnackBar(
      content: Text(
        invalidMsg,
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.blueGrey,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
