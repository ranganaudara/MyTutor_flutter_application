import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tutor_app_new/src/screens/student_screens/loged_student_screen/loged_student_screen.dart';
import 'package:tutor_app_new/src/screens/student_screens/register_screen_student/register_screen_student.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../mixins/validator_mixin.dart';

class StudentLoginScreen extends StatefulWidget {
  @override
  _StudentLoginScreenState createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> with ValidatorMixin {

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String userName;
  String password;
  String invalidMsg = "";
  String email  = "";

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
              postRequest();
              alertLoading();

            }
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
      onPressed: () {

      },
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

  void postRequest() async {
    var url = 'https://guarded-beyond-19031.herokuapp.com/login';

    var body = {'username': userName, 'password': password, 'role': 'student'};

    http.post(url, body: body).then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);
      setState(() {
        email = res['user']['email'];
      });
      _saveEmailPreference();


      if (res['success'] == true && res['block'] == false) {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LogedInStudent()),
        );
      }else if(res['success'] == true && res['block'] == true) {
        invalidAuthUserBlocked();
      }else{
        invalidAuth();
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

  void invalidAuthUserBlocked() {
    setState(() {
      this.invalidMsg = "Can't login! You are blocked!";
      _showSnackBar(invalidMsg);
      _formKey.currentState.reset();
    });
  }

  void alertLoading() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Container(
          width: 20.0,
          height: 20.0,
          child: null,
        );
      },
    );
  }


  _saveEmailPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("email", email);
    });
  }
}
