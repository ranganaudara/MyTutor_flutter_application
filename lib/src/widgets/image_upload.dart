import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String imgUploadUrl =
      "https://guarded-beyond-19031.herokuapp.com/uploadImage";

  File _image;
  String myEmail;

  @override
  void initState() {
    super.initState();
    _getPreferences();
  }

  Future _getCameraImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future _getGalleryImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Change Profile Picture'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _showImage(),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                tooltip: "Camera",
                iconSize: 40.0,
                icon: Icon(Icons.camera_alt),
                color: Colors.black54,
                onPressed: _getCameraImage,
              ),
              IconButton(
                tooltip: "Gallery",
                iconSize: 40.0,
                icon: Icon(Icons.photo),
                color: Colors.black54,
                onPressed: _getGalleryImage,
              )
            ],
          ),
          _submitButton(),
        ],
      ),
    );
  }

  Widget _showImage() {
    return CircleAvatar(
      child: ClipOval(
        child: InkWell(
          child: Center(
            child: _image == null
                ? Image.asset('assets/images/user.png')
                : Image.file(_image),
          ),
        ),
      ),
      maxRadius: 120.0,
      minRadius: 70.0,
      backgroundColor: Colors.transparent,
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
            if(_image == null){

            }
            _upload();
            print("submit pressed`");
          },
          child: Text(
            'Set Image',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }

  //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Img Upload>>>>>>>>>>>>>>>>>>>>>

  void _upload() {
    if (_image == null) {
      print('return');
      return;
    }
    String base64Image = base64Encode(_image.readAsBytesSync());
    String _encodedImage = 'data:image/jpg;base64,' + base64Image;

    var body = {
      "image": _encodedImage,
      "email": myEmail,
      "role": "tutor",
    };
    print(body);

    http.post(imgUploadUrl, body: body).then((dynamic response) {

      Map<String, dynamic> res = json.decode(response.body);
      if(res["success"]==true){
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/teacher_logged', (Route<dynamic> route) => false);
      }
      print(res["success"]);

    }).catchError((err) {
      print(err);
    });
  }
  //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Img Upload>>>>>>>>>>>>>>>>>>>>>

  void _showSnackBar(String msg) {
    final snackBar = SnackBar(
      content: Text(
        '$msg',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.blueGrey,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myEmail = prefs.getString("email");
    });
  }
}
