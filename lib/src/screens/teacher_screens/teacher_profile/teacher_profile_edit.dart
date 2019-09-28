import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_app_new/src/mixins/validator_mixin.dart';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor_app_new/src/widgets/image_upload.dart';

class EditTutorProfile extends StatefulWidget {
  @override
  _EditTutorProfileState createState() => _EditTutorProfileState();
}

class _EditTutorProfileState extends State<EditTutorProfile>
    with ValidatorMixin {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String editProfileUrl =
      "https://guarded-beyond-19031.herokuapp.com/editProfile";
  String imgUploadUrl =
      "https://guarded-beyond-19031.herokuapp.com/uploadImage";

  File _image;

  String fname;
  String lname;
  String mobile;
  String location;
  String email;
  String description;
  String subject;
  String availableTime;
  String price;

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
                _circleImage(),
                SizedBox(height: 20.0),
                _titleText(),
                SizedBox(height: 20.0),
                _firstNameField(),
                SizedBox(height: 10.0),
                _lastNameField(),
                SizedBox(height: 10.0),
                _subjectField(),
                SizedBox(height: 10.0),
                _locationField(),
                SizedBox(height: 10.0),
                _availabilityField(),
                SizedBox(height: 10.0),
                _mobileField(),
                SizedBox(height: 10.0),
                _priceField(),
                SizedBox(height: 10.0),
                _descriptionField(),
                SizedBox(height: 10.0),
                _submitButton(),
                SizedBox(height: 20.0),
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

  Widget _firstNameField() {
    return TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        labelText: 'First Name',
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      ),
      validator: (value) {
        if (value.isEmpty) return 'Enter your first name';
      },
      onSaved: (String value) {
        this.fname = value;
      },
    );
  }

  Widget _lastNameField() {
    return TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        labelText: 'Last Name',
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      ),
      validator: (value) {
        if (value.isEmpty) return 'Enter your last name';
      },
      onSaved: (String value) {
        this.lname = value;
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

  Widget _priceField() {
    return TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        icon: Icon(Icons.monetization_on),
        labelText: 'Price per Hour',
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      ),
      validator: (value) {
        if (value.isEmpty) return 'Enter the price per hour';
      },
      keyboardType: TextInputType.numberWithOptions(),
      onSaved: (String value) {
        this.price = value;
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
        if (value.isEmpty) return 'Please enter location';
      },
      onSaved: (String value) {
        this.location = value;
      },
    );
  }

  Widget _subjectField() {
    return TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        icon: Icon(Icons.subject),
        labelText: 'Subject',
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      ),
      validator: (value) {
        if (value.isEmpty) return 'Please enter a subject';
      },
      onSaved: (String value) {
        this.subject = value;
      },
    );
  }

  Widget _descriptionField() {
    return TextFormField(
      maxLength: 225,
      maxLines: 7,
      autofocus: false,
      decoration: InputDecoration(
        icon: Icon(Icons.text_fields),
        labelText: 'Description',
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      ),
      validator: (value) {
        if (value.isEmpty) return 'Enter the description';
      },
      onSaved: (String value) {
        this.description = value;
      },
    );
  }

  Widget _availabilityField() {
    return TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        icon: Icon(Icons.event_available),
        labelText: 'Availability',
        hintText: 'Day / Night',
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      ),
      validator: (value) {
        if (value.isEmpty) return 'Enter your availability';
      },
      onSaved: (String value) {
        this.availableTime = value;
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
      "fname": "$fname",
      "lname": "$lname",
      "description": "$description",
      "mobile": "$mobile",
      "location": "$location",
      "email": "$email",
      "role": "tutor",
      "subject": "$subject",
      "price": "$price",
      "available": "$availableTime"
    };

    print(detailsBody);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return buildLoadingDialog();
        });

    await http.post(editProfileUrl, body: detailsBody).then((dynamic response) {
      Map<String, dynamic> res = json.decode(response.body);

      if (res['success'] == true) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/teacher_login', (Route<dynamic> route) => false);
      } else if (res['success'] == false) {
        Navigator.of(context).pop();
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

  Widget _circleImage() {
    return CircleAvatar(
      child: ClipOval(
        child: InkWell(
          child: Image(image: AssetImage('assets/images/user.png')),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImageUpload()),
            );
          },
        ),
      ),
      maxRadius: 80.0,
      minRadius: 50.0,
      backgroundColor: Colors.transparent,
    );
  }

  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString("email");
    });
  }
}
