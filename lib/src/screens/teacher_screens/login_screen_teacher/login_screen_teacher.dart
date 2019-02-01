import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tutor_app_new/src/screens/teacher_screens/logged_teacher_screen/logged_teacher_screen.dart';
import 'package:tutor_app_new/src/screens/teacher_screens/register_screen_teacher/register_screen_teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../mixins/validator_mixin.dart';

class TeacherLoginScreen extends StatefulWidget {
  @override
  _TeacherLoginScreenState createState() => _TeacherLoginScreenState();
}

class _TeacherLoginScreenState extends State<TeacherLoginScreen>
    with ValidatorMixin {

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String tutorFName;
  String tutorLName;
  String tutorEmail;
  String userName;
  String password;
  String invalidMsg = "";

  //<<<<<<<<<< Snack Bar >>>>>>>>

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
              SizedBox(height: 45.0),
              userNameField(),
              SizedBox(height: 8.0),
              passwordField(),
              SizedBox(height: 24.0),
              loginButton(),
              forgetPasswordButton(),
              createAccountButton(),
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
        maxRadius: 60.0,
        minRadius: 20.0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget welcomeText() {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Text('Log in to connect with your student...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  Widget userNameField() {
    return TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        labelText: 'User Name',
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      ),
      validator: (value) {
        if (value.isEmpty) return 'please enter username';
      },
      onSaved: (String value) {
        this.userName = value;
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(Icons.keyboard),
        labelText: 'Password',
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      ),
      validator: passwordValidator,
      onSaved: (String value) {
        this.password = value;
      },
    );
  }

  Widget loginButton() {
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
//            if (_formKey.currentState.validate()) {
//              _formKey.currentState.save();
//              loginRequest();
//            }
          loginRequest();
          },
          child: Text('Log In'),
        ),
      ),
    );
  }

  Widget forgetPasswordButton() {
    return FlatButton(
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          color: Colors.black54,
        ),
      ),
      onPressed: () {},
    );
  }

  Widget createAccountButton() {
    return FlatButton(
      child: Text(
        'Create new Account',
        style: TextStyle(
          color: Colors.black54,
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TeacherRegisterScreen()),
        );
      },
    );
  }

  void loginRequest() async {
    var url = 'https://guarded-beyond-19031.herokuapp.com/login';

//    var body = {
//      'userName': userName,
//      'password': password,
//        'role': 'tutor',
//    };

    var body = {
      'username': 'lkj@lkj',
      'password': 'lkjlkjlkj',
      'role':'tutor'
    };
    print(body);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return buildLoadingDialog();
        });

    http.post(url, body: body).then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);
      print(res);
      if (res['success'] == true) {

        setState(() {
          tutorFName = res['user']['fname'];
          tutorLName = res['user']['lname'];
          tutorEmail = res['user']['email'];
          _savePreference();
        });


        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoggedTeacherScreen()),
        );
      } else if (res['success'] == true && res['block'] == true) {
        invalidAuthUserBlocked();
      } else if (res['success'] == false && res['block'] == false) {
        invalidAuth();
      } else {
        somethingError();
      }
    });
  }

  void invalidAuth() {
    setState(() {
      this.invalidMsg = "Invalid Username or Password";
      _showSnackBar(invalidMsg);
      _formKey.currentState.reset();
    });
  }

  void somethingError() {
    setState(() {
      this.invalidMsg = "Something went wrong";
      _showSnackBar(invalidMsg);
      _formKey.currentState.reset();
    });
  }

  void invalidAuthUserBlocked() {
    setState(() {
      this.invalidMsg = "Can't login! You are blocked!";
      _showSnackBar(invalidMsg);
      _formKey.currentState.reset();
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

  _savePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("myFName", tutorFName);
      prefs.setString("myLName", tutorLName);
      prefs.setString("email", tutorEmail);
    });
  }

}
