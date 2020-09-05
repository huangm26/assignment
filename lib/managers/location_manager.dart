import 'package:affirm_assignment/managers/logger.dart';
import 'package:location/location.dart';

LocationManager locationManager = LocationManager._();  /// Global instance

/// Manager for handling location requests
class LocationManager {
  LocationManager._();

  Location _location;
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted;
  LocationData _locationData;   /// Cached location data

  /// Public getters
  bool get serviceEnabled => _serviceEnabled;
  PermissionStatus get permissionStatus => _permissionGranted;

  /// Init locationManager and set the current location service status and permission status
  /// This method should be called before other calls
  Future<void> init() async {
    _location = Location();
    _serviceEnabled = await _location.serviceEnabled();
    _permissionGranted = _serviceEnabled ? await _location.hasPermission() : PermissionStatus.denied;
  }

  /// Api to get the current location
  /// It would request user to enable service and grant permission
  Future<LocationData> getLocation() async {
    assert(_location != null);

    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        logger.w('User disabled location service');
        /// TODO: Consider show warning to user
        return _locationData; /// We try to show the last location to user if exists
      }
    }

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        logger.w('User denied location permission');
        /// TODO: Consider show warning to user
        return _locationData; /// We try to show the last location to user if exists
      }
    }
    _locationData = await _location.getLocation();
    return _locationData;
  }
}