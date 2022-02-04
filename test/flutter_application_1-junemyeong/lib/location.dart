import 'package:location/location.dart';

class UserLocation {
  LocationData? currentlocation;
  double? latitude;
  double? longitude;

  UserLocation({this.latitude, this.longitude, this.currentlocation});
}