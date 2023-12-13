import 'dart:convert';

import 'package:geolocator/geolocator.dart';


class LocationService {
  LocationService._privateConstructor();
  static final LocationService _instance =
      LocationService._privateConstructor();
  Position? _lastGetLocation;
  // LocationPermission permission;

  factory LocationService() {
    return _instance;
  }

  Future getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: false,
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: Duration(milliseconds: 5000),
      );
      print('blablalb');
      print(jsonEncode(position));

      _lastGetLocation = position;

      if (_lastGetLocation == null) {
        _lastGetLocation = await getLastKnownLocation();
      }

      return _lastGetLocation;
    } catch (_) {
      print(_.toString());
      _lastGetLocation = await getLastKnownLocation();
      return _lastGetLocation;
    }
  }

  Position getLastLocation() {
    return _lastGetLocation!;
  }

  static Future<Position> getLastKnownLocation() async {
    Position? position;
    try {
      position = await Geolocator.getLastKnownPosition();

      if (position != null) return position;

      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.lowest,
          forceAndroidLocationManager: true,
          timeLimit: Duration(milliseconds: 5000));
    } catch (_) {}

    return position!;
  }

  Future<bool> checkPermission() async {
    // await Geolocator.requestPermission();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      LocationPermission ipermission = await Geolocator.requestPermission();
      if (ipermission == LocationPermission.deniedForever) {
        return false;
      } else if (ipermission == LocationPermission.denied) {
        return false;
      } else {
        return true;
      }
    } else if (permission == LocationPermission.deniedForever) {
      LocationPermission ipermission = await Geolocator.requestPermission();
      if (ipermission == LocationPermission.deniedForever) {
        return false;
      } else {
        return true;
      }
    } else if (permission == LocationPermission.unableToDetermine) {
      return false;
    } else if (permission == LocationPermission.whileInUse) {
      await Geolocator.getCurrentPosition();
      return true;
    } else if (permission == LocationPermission.always) {
      // await Geolocator.requestPermission();
      await Geolocator.getCurrentPosition();

      return true;
    }
    return false;
  }
}
