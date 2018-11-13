import 'package:flutter/material.dart';
import 'package:tutor_app_new/src/models/trnding_user.dart';

class TrendingDetails extends StatelessWidget {

  final User user;
  TrendingDetails(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
    );
  }
}
