import 'package:affirm_assignment/apis/search_api.dart';
import 'package:affirm_assignment/managers/logger.dart';
import 'package:affirm_assignment/model/business.dart';
import 'package:flutter/cupertino.dart';

/// Helper layer for fetching businesses from yelp.
/// Because yelp API return limited number of result in one search like a page, this layer serves as the cache
/// If the index queried is already in cache, simply return the cached value, otherwise query yelp
class BusinessFetcher {
  final int latitude;
  final int longitude;
  final List<String> categories;
  final int queryLimit;
  final Map<int, Future> _inProgressSearch = {};
  int _totalCount = 0;
  
  List<Business> _businesses;

  int get totalCount => _totalCount;

  BusinessFetcher({@required this.latitude, @required this.longitude, this.categories = const ['restaurants'], this.queryLimit = 20});

  Future<void> init() {
    if (_businesses != null) {
      /// If there is already cached value, don't do anything.
      return Future.value();
    } else {
      return _searchBusinessAtPage(pageIndex: 0);
    }
  }

  /// Api to search business at given index
  Future<Business> searchBusiness(int index) {
    if (_businesses != null && _businesses[index] != null) {
      return Future.value(_businesses[index]);
    } else {
      final pageIndex = (index.toDouble() / queryLimit.toDouble()).floor();
      return _searchBusinessAtPage(pageIndex: pageIndex).then((_) => _businesses[index]);
    }
  }

  /// Api to return the initial part of business responses
  /// TODO: For now limit the size to be smaller than queryLimit
  Future<List<Business>> getFirstBusinesses(int size) {
    if (_businesses != null && _businesses.length >= size && _businesses[size - 1] != null) {
      return Future.value(_businesses.sublist(0, size));
    } else {
      return _searchBusinessAtPage(pageIndex: 0).then((_) => _businesses.sublist(0, _businesses.length > size ? size : _businesses.length));
    }
  }

  Future _searchBusinessAtPage({int pageIndex}) {
    /// Prevent duplicate calls
    if (_inProgressSearch.containsKey(pageIndex)) {
      return _inProgressSearch[pageIndex];
    }
    
    Future searchFuture = searchBusinesses(latitude, longitude, categories, pageIndex * queryLimit, queryLimit).then(
        (response) {
          List<Business> businesses = response['businesses'].map<Business>((businessJson) => Business.fromDynamic(businessJson)).toList();
          if (_businesses == null) {
            int totalCount = response['total'];
            _totalCount = totalCount;
            logger.d('Total count $totalCount');
            _businesses = List<Business>(totalCount);
          }
          List.copyRange(_businesses, pageIndex * queryLimit, businesses);
          _inProgressSearch.remove(pageIndex);
        }
    );
    _inProgressSearch[pageIndex] = searchFuture;
    return searchFuture;
  }
}