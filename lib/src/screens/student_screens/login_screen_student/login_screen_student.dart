import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tutor_app_new/src/screens/student_screens/logged_student_screen/logged_student_screen.dart';
import 'package:tutor_app_new/src/screens/student_screens/register_screen_student/register_screen_student.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../mixins/validator_mixin.dart';
class StudentLoginScreen extends StatefulWidget {
  @override
  _StudentLoginScreenState createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen>
    with ValidatorMixin {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String userName;
  String password;
  String invalidMsg = "";
  String email = "";

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
              SizedBox(height: 8.0),
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
        child: Image(image: AssetImage('assets/images/student_login.png')),
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
            height: 20.0,
          ),
          Text('Log in to find your teacher...',
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
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              loginRequest();
            }
            //loginRequest();
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
          MaterialPageRoute(builder: (context) => StudentRegisterScreen()),
        );
      },
    );
  }

  void loginRequest() async {
    var url = 'https://guarded-beyond-19031.herokuapp.com/login';

    var body = {
      "username": "$userName",
      "password": "$password",
      "role": "student"
    };
//    var body = {
//      "username": "abc@email.com",
//      "password": "12345678",
//      "role": "student"
//    };

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return buildLoadingDialog();
        });

      http.post(url, body: body).then((dynamic response) {
        Map<String, dynamic> res = json.decode(response.body);
        Navigator.pop(context);
        if (res['success'] == true && res['block'] == false) {
          setState(() {
            email = res['user']['email'];
            userName = res['user']['name'];
          });
          _savePreference();

        } else if (res['success'] == true && res['block'] == true) {
          invalidAuthUserBlocked();
        } else if (res['success'] == false && res['block'] == false) {
          invalidAuth();
        } else if(res['success'] == true && res['confiremed'] == false){
          invalidAuthNotConfirmed();
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

  void invalidAuthNotConfirmed() {
    setState(() {
      this.invalidMsg = "You have not varify your email!";
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

  _savePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("email", email);
      prefs.setString("name", userName);

      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoggedInStudent()),
      );

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

}
