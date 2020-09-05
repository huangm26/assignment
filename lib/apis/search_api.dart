
import 'package:affirm_assignment/managers/http_client.dart';
import 'package:dio/dio.dart';

/// Network api for search business from yelp
/// @param latitude the latitude of target location to search
/// @param longitude the longitude of target location to search
/// @param categories the business categories to search
Future<dynamic> searchBusinesses(int latitude, int longitude, List<String> categories, int offset, int limit) async {
  final String url = 'https://api.yelp.com/v3/businesses/search';
  final String categoryParam = categories.join(',');
  Response response = await httpManager.client.get(
    url,
    queryParameters: {
      'latitude': latitude,
      'longitude': longitude,
      'categories': categoryParam,
      'limit': limit,
      'offset': offset
    }
  );
  return response.data;
}