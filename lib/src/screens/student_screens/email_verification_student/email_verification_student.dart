import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EmailVerificationStudent extends StatefulWidget {
  @override
  _EmailVerificationStudentState createState() =>
      _EmailVerificationStudentState();
}

class _EmailVerificationStudentState extends State<EmailVerificationStudent> {

  String verificationCode;
  String verificationUrl = 'https://guarded-beyond-19031.herokuapp.com/verify';
  String studentEmail;
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Enter your verification code here...",
                style: TextStyle(fontSize: 22.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              _verificationCodeField(),
              SizedBox(height: 16.0),
              _loginButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _verificationCodeField() {
    return TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        icon: Icon(Icons.vpn_key),
        labelText: 'Varification Code',
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      ),
      validator: (value) {
        if (value.isEmpty) return 'please enter your verification code';
      },
      onSaved: (String value) {
        this.verificationCode = value;
      },
    );
  }

  Widget _loginButton() {
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

              _sendVerificationCode();

            }
          },
          child: Text('Submit', style: TextStyle(fontSize: 16.0)),
        ),
      ),
    );
  }


  void _sendVerificationCode() async {
    var body = {
      'token': verificationCode,
      'role': "student",
      'email': studentEmail
    };

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return _buildLoadingDialog();
        });

    print("Body======++>");
    print(body);

    http.post(verificationUrl, body: body).then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);
      print(res);
      Navigator.pop(context);
      if (res['success'] == true) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/student_login',
              (Route<dynamic> route) => false,
        );
      }else{
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return _failedDialog();
            });
      }
    });
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

  Widget _failedDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListTile(
          title: Text('Failed! Try Again!'),
        ),
      ),
    );
  }

  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      studentEmail = prefs.getString("studentRegEmail");
    });
  }

}
