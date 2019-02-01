import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {


  final feedbackTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feedback')),
      body: Container(
        child: Column(
          children: <Widget>[
            _textArea()
          ],
        ),
      ),
    );
  }


  Widget _textArea() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(),
            right: BorderSide(),
            left: BorderSide(),
          )),
      height: 159.0,
      width: 350.0,
      child: TextField(
        controller: feedbackTextController,
        keyboardType: TextInputType.multiline,
        maxLength: 150,
        maxLines: 7,
      ),
    );
  }
}
