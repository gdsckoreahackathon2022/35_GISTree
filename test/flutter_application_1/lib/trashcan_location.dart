import 'package:google_maps_flutter/google_maps_flutter.dart';

BitmapDescriptor normalicon = BitmapDescriptor.defaultMarkerWithHue(43);
BitmapDescriptor recycleicon = BitmapDescriptor.defaultMarkerWithHue(96);
BitmapDescriptor foodicon = BitmapDescriptor.defaultMarkerWithHue(219);
BitmapDescriptor batteryicon = BitmapDescriptor.defaultMarkerWithHue(24);
BitmapDescriptor clothicon = BitmapDescriptor.defaultMarkerWithHue(153);

int normalcount = 3;
int recyclecount = 3;
int foodcount = 3;
int batterycount = 3;
int clothcount = 3;

List<Marker> normaltrashcanInfo = [
  Marker(
    markerId: MarkerId("1"),
    position: LatLng(35.2272, 126.8415),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("2"),
    position: LatLng(35.2290, 126.8466),
    onTap: () {},
    icon: normalicon,
  )
];

List<Marker> recycletrashcanInfo = [
  Marker(
    markerId: MarkerId("1"),
    position: LatLng(35.2288, 126.8475),
    onTap: () {},
    icon: recycleicon,
  ),
  Marker(
    markerId: MarkerId("2"),
    position: LatLng(35.2255, 126.8406),
    onTap: () {},
    icon: recycleicon,
  )
];

List<Marker> foodtrashcanInfo = [
  Marker(
    markerId: MarkerId("1"),
    position: LatLng(35.2272, 126.8415),
    onTap: () {},
    icon: foodicon,
  ),
  Marker(
    markerId: MarkerId("2"),
    position: LatLng(35.2290, 126.8466),
    onTap: () {},
    icon: foodicon,
  )
];

List<Marker> batterytrashcanInfo = [
  Marker(
    markerId: MarkerId("1"),
    position: LatLng(35.2288, 126.8475),
    onTap: () {},
    icon: batteryicon,
  ),
  Marker(
    markerId: MarkerId("2"),
    position: LatLng(35.2255, 126.8406),
    onTap: () {},
    icon: batteryicon,
  )
];

List<Marker> clothtrashcanInfo = [
  Marker(
    markerId: MarkerId("1"),
    position: LatLng(35.2272, 126.8415),
    onTap: () {},
    icon: clothicon,
  ),
  Marker(
    markerId: MarkerId("2"),
    position: LatLng(35.2290, 126.8466),
    onTap: () {},
    icon: clothicon,
  )
];
