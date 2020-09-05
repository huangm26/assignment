import 'package:affirm_assignment/managers/http_manager.dart';
import 'package:affirm_assignment/managers/location_manager.dart';
import 'package:affirm_assignment/pages/yelp_display.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AffirmAssignmentApp());
}

class AffirmAssignmentApp extends StatefulWidget {
  @override
  _AffirmAssignmentAppState createState() => _AffirmAssignmentAppState();
}

class _AffirmAssignmentAppState extends State<AffirmAssignmentApp> {
  @override
  void initState() {
    super.initState();
    /// Init managers
    locationManager.init()
        .then((_) => httpManager.init());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Affirm Assignment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: YelpDisplay()
    );
  }
}
