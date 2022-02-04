import 'package:google_maps_flutter/google_maps_flutter.dart';

List<Marker> trashcanInfo = [
  Marker(
    markerId: MarkerId("123"),
    position: LatLng(35.2272, 126.8415),
    onTap: () {},
    icon: BitmapDescriptor.defaultMarker,
  ),
  Marker(
    markerId: MarkerId("can_1"),
    position: LatLng(35.2290, 126.8466),
    onTap: () {},
    icon: BitmapDescriptor.defaultMarker,
  )
];
