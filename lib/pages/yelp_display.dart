import 'package:affirm_assignment/apis/business_fetcher.dart';
import 'package:affirm_assignment/managers/location_manager.dart';
import 'package:affirm_assignment/model/business.dart';
import 'package:affirm_assignment/widgets/business_card.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

/// Main page for displaying the yelp search result with image, rating and name
/// Also allows toggle between restaurant and all businesses
class YelpDisplay extends StatefulWidget {
  @override
  _YelpDisplayState createState() => _YelpDisplayState();
}

class _YelpDisplayState extends State<YelpDisplay> {
  static String _restaurant = 'restaurants';
  static String _allCategory = 'all';
  static final int querySize = 20;
  static final int stackSize = 3;
  BusinessFetcher _businessFetcher;
  List<Business> _businesses = [];
  int _start, _end;
  LocationData _location;
  bool _restaurantOnly = true;

  @override
  void initState() {
    super.initState();

    locationManager.getLocation()
        .then((location) {
      _location = location;
      return _reload(_restaurant);
    });
  }

  Future _reload(String category) {
    _businessFetcher = BusinessFetcher(latitude: _location.latitude.toInt(), longitude: _location.longitude.toInt(), queryLimit: querySize, categories: [category]);
    return _businessFetcher.init().then((_) => _initializeData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yelp Search'), centerTitle: true),
      body: _businessFetcher != null ? SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Stack(
                  children: _businesses.asMap().map((index, value) => MapEntry(
                    index, index == 0 ? BusinessCard(business: value, elevation: 0) : Positioned.fill(
                    top: index * 2.0,
                    child: BusinessCard(
                      business: value,
                      elevation: index * 4.0,
                    ),
                  )
                  )).values.toList().reversed.toList(),
                ),
              ),
              SizedBox(
                height: 200,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _button('Previous', Colors.red, _start == 0 ? null : _showPrevious),
                  Column(
                    children: [
                      Switch(
                        value: _restaurantOnly,
                        onChanged: _onChangeSwitch,
                      ),
                      Text(
                        'Restaurant Only'
                      )
                    ],
                  ),
                  _button('Next', Colors.green, _end == _businessFetcher.totalCount - 1 ? null : _showNext)
                ],
              )
            ],
          ),
        ),
        ) : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  
  Future _initializeData() {
    _businesses = [];
    return _businessFetcher.getFirstBusinesses(stackSize).then((values) {
      _start = 0;
      _end = values.length - 1;
      setState(() => _businesses.addAll(values));
    });
  }

  Widget _button(String title, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 60,
      height: 60,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        color: color,
        padding: EdgeInsets.zero,
        child: Text(
          title,
          style: Theme.of(context).textTheme.button.copyWith(color: Colors.white),
        ),
        onPressed: onPressed,
      ),
    );
  }

  void _showPrevious() {
    _businessFetcher.searchBusiness(--_start).then((value) {
      setState(() {
        _businesses.insert(0, value);
        _businesses.removeLast();
        _end--;
      });
    });
  }

  void _showNext() {
    _businessFetcher.searchBusiness(++_end).then((value) {
      setState(() {
        _businesses.add(value);
        _businesses.removeAt(0);
        _start++;
      });
    });
  }

  void _onChangeSwitch(bool value) {
    setState(() {
      _restaurantOnly = value;
    });
    _reload(value ? _restaurant : _allCategory);
  }
}
