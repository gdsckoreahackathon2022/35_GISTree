import 'package:google_maps_flutter/google_maps_flutter.dart';

BitmapDescriptor normalicon = BitmapDescriptor.defaultMarkerWithHue(43);
BitmapDescriptor recycleicon = BitmapDescriptor.defaultMarkerWithHue(96);
BitmapDescriptor foodicon = BitmapDescriptor.defaultMarkerWithHue(219);
BitmapDescriptor batteryicon = BitmapDescriptor.defaultMarkerWithHue(24);
BitmapDescriptor clothicon = BitmapDescriptor.defaultMarkerWithHue(153);

int normalcount = 29;
int recyclecount = 14;
int foodcount = 11;
int batterycount = 6;
int clothcount = 7;

List<Marker> normaltrashcanInfo = [
  Marker(
    markerId: MarkerId("1"),
    position: LatLng(37.528063, 127.040634),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("2"),
    position: LatLng(37.528064, 127.040965),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("3"),
    position: LatLng(37.529051, 127.037492),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("4"),
    position: LatLng(37.529259, 127.036478),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("5"),
    position: LatLng(37.530124, 127.042464),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("6"),
    position: LatLng(37.527580, 127.028943),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("7"),
    position: LatLng(37.532128, 127.027328),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("8"),
    position: LatLng(37.524438, 127.020279),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("9"),
    position: LatLng(37.525035, 127.021609),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("10"),
    position: LatLng(37.524119, 127.022502),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("11"),
    position: LatLng(37.525188, 127.024360),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("12"),
    position: LatLng(37.526856, 127.027938),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("13"),
    position: LatLng(37.528589, 127.037466),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("14"),
    position: LatLng(37.52581685483343, 127.02830973354921),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("15"),
    position: LatLng(37.526073457922394, 127.02864808813216),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("16"),
    position: LatLng(37.52352886331878, 127.02853302179518),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("17"),
    position: LatLng(37.52317179391182, 127.02809095428097),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("18"),
    position: LatLng(37.52534696879149, 127.02517690004545),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("19"),
    position: LatLng(37.52536843401708, 127.02516787820574),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("20"),
    position: LatLng(37.52678857863348, 127.03325687872771),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("21"),
    position: LatLng(37.53002181574934, 127.03411518560593),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("22"),
    position: LatLng(37.53002181574934, 127.03411518560593),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("23"),
    position: LatLng(37.52879660554416, 127.03593908772218),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("24"),
    position: LatLng(37.528275665522294, 127.03956833765166),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("25"),
    position: LatLng(37.52909577664997, 127.036467556179),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("26"),
    position: LatLng(37.52924892841194, 127.03549123210502),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("27"),
    position: LatLng(37.52366860538007, 127.03509685322646),
    onTap: () {},
    icon: normalicon,
  ),
  Marker(
    markerId: MarkerId("28"),
    position: LatLng(37.52543941522402, 127.03463115673154),
    onTap: () {},
    icon: normalicon,
  )
];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

List<Marker> recycletrashcanInfo = [
  Marker(
    markerId: MarkerId("1"),
    position: LatLng(37.528063, 127.040634),
    onTap: () {},
    icon: recycleicon,
  ),
  Marker(
    markerId: MarkerId("2"),
    position: LatLng(37.528064, 127.040965),
    onTap: () {},
    icon: recycleicon,
  ),
  Marker(
    markerId: MarkerId("3"),
    position: LatLng(37.529051, 127.037492),
    onTap: () {},
    icon: recycleicon,
  ),
  Marker(
    markerId: MarkerId("4"),
    position: LatLng(37.529259, 127.036478),
    onTap: () {},
    icon: recycleicon,
  ),
  Marker(
    markerId: MarkerId("5"),
    position: LatLng(37.530124, 127.042464),
    onTap: () {},
    icon: recycleicon,
  ),
  Marker(
    markerId: MarkerId("6"),
    position: LatLng(37.527580, 127.028943),
    onTap: () {},
    icon: recycleicon,
  ),
  Marker(
    markerId: MarkerId("7"),
    position: LatLng(37.532128, 127.027328),
    onTap: () {},
    icon: recycleicon,
  ),
  Marker(
    markerId: MarkerId("8"),
    position: LatLng(37.524438, 127.020279),
    onTap: () {},
    icon: recycleicon,
  ),
  Marker(
    markerId: MarkerId("9"),
    position: LatLng(37.525035, 127.021609),
    onTap: () {},
    icon: recycleicon,
  ),
  Marker(
    markerId: MarkerId("10"),
    position: LatLng(37.524119, 127.022502),
    onTap: () {},
    icon: recycleicon,
  ),
  Marker(
    markerId: MarkerId("11"),
    position: LatLng(37.525188, 127.024360),
    onTap: () {},
    icon: recycleicon,
  ),
  Marker(
    markerId: MarkerId("12"),
    position: LatLng(37.526856, 127.027938),
    onTap: () {},
    icon: recycleicon,
  ),
  Marker(
    markerId: MarkerId("13"),
    position: LatLng(37.528589, 127.037466),
    onTap: () {},
    icon: recycleicon,
  )
];

///////////////////////////////////////////////////////////////////////

List<Marker> foodtrashcanInfo = [
  Marker(
    markerId: MarkerId("1"),
    position: LatLng(37.53014088733779, 127.03761671959738),
    onTap: () {},
    icon: foodicon,
  ),
  Marker(
    markerId: MarkerId("2"),
    position: LatLng(37.53247812188024, 127.03139821265175),
    onTap: () {},
    icon: foodicon,
  ),
  Marker(
    markerId: MarkerId("3"),
    position: LatLng(37.53138681138017, 127.02705799998866),
    onTap: () {},
    icon: foodicon,
  ),
  Marker(
    markerId: MarkerId("4"),
    position: LatLng(37.533065309724286, 127.02773319249665),
    onTap: () {},
    icon: foodicon,
  ),
  Marker(
    markerId: MarkerId("5"),
    position: LatLng(37.528272007446255, 127.03603049528645),
    onTap: () {},
    icon: foodicon,
  ),
  Marker(
    markerId: MarkerId("6"),
    position: LatLng(37.52844645436581, 127.03463407559273),
    onTap: () {},
    icon: foodicon,
  ),
  Marker(
    markerId: MarkerId("7"),
    position: LatLng(37.53172615110267, 127.03630262686382),
    onTap: () {},
    icon: foodicon,
  ),
  Marker(
    markerId: MarkerId("8"),
    position: LatLng(37.52932563921774, 127.04286424100397),
    onTap: () {},
    icon: foodicon,
  ),
  Marker(
    markerId: MarkerId("9"),
    position: LatLng(37.530948860721466, 127.0371550955725),
    onTap: () {},
    icon: foodicon,
  ),
  Marker(
    markerId: MarkerId("10"),
    position: LatLng(37.53025604294621, 127.04071188640265),
    onTap: () {},
    icon: foodicon,
  )
];

List<Marker> batterytrashcanInfo = [
  Marker(
    markerId: MarkerId("1"),
    position: LatLng(37.52687425748841, 127.02838815933015),
    onTap: () {},
    icon: batteryicon,
  ),
  Marker(
    markerId: MarkerId("2"),
    position: LatLng(37.52778021813731, 127.04071438731566),
    onTap: () {},
    icon: batteryicon,
  ),
  Marker(
    markerId: MarkerId("3"),
    position: LatLng(37.52999689086257, 127.03850847402545),
    onTap: () {},
    icon: batteryicon,
  ),
  Marker(
    markerId: MarkerId("4"),
    position: LatLng(37.53085599885529, 127.03898333777224),
    onTap: () {},
    icon: batteryicon,
  ),
  Marker(
    markerId: MarkerId("5"),
    position: LatLng(37.52886197990224, 127.04363734208353),
    onTap: () {},
    icon: batteryicon,
  )
];

List<Marker> clothtrashcanInfo = [
  Marker(
    markerId: MarkerId("1"),
    position: LatLng(37.529775487256636, 127.04055183621338),
    onTap: () {},
    icon: clothicon,
  ),
  Marker(
    markerId: MarkerId("2"),
    position: LatLng(37.52897325611291, 127.04374284120203),
    onTap: () {},
    icon: clothicon,
  ),
  Marker(
    markerId: MarkerId("3"),
    position: LatLng(37.529902501427195, 127.04005364456965),
    onTap: () {},
    icon: clothicon,
  ),
  Marker(
    markerId: MarkerId("4"),
    position: LatLng(37.53104536749685, 127.03743640266381),
    onTap: () {},
    icon: clothicon,
  ),
  Marker(
    markerId: MarkerId("5"),
    position: LatLng(37.531848321130056, 127.03558784600023),
    onTap: () {},
    icon: clothicon,
  ),
  Marker(
    markerId: MarkerId("6"),
    position: LatLng(37.530377057864285, 127.03500255561897),
    onTap: () {},
    icon: clothicon,
  )
];
