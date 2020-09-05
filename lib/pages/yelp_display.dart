import 'package:affirm_assignment/apis/business_fetcher.dart';
import 'package:affirm_assignment/managers/location_manager.dart';
import 'package:affirm_assignment/model/business.dart';
import 'package:affirm_assignment/widgets/business_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class YelpDisplay extends StatefulWidget {
  @override
  _YelpDisplayState createState() => _YelpDisplayState();
}

class _YelpDisplayState extends State<YelpDisplay> {
  static final int querySize = 20;
  static final int stackSize = 5;
  BusinessFetcher _businessFetcher;
  List<Business> _businesses = [];

  @override
  void initState() {
    super.initState();

    locationManager.getLocation()
        .then((location) {
          _businessFetcher = BusinessFetcher(latitude: location.latitude.toInt(), longitude: location.longitude.toInt());
          return _businessFetcher.init();
    }).then((_) => _searchBusinesses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yelp Search'), centerTitle: true),
      body: _businessFetcher != null ? SingleChildScrollView(
        child: Column(
          children: _businesses.map((e) => BusinessCard(business: e)).toList(),
        ),
      ) : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  
  Future _searchBusinesses() {
    return _businessFetcher.searchBusiness(0).then((value) => setState(() => _businesses.add(value)));
  }
}
