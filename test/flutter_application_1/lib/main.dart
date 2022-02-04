// @dart=2.9
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_application_1/location.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraExample(),
    );
  }
}

class CameraExample extends StatefulWidget {
  const CameraExample({Key key}) : super(key: key);
  @override
  _CameraExampleState createState() => _CameraExampleState();
}

class _CameraExampleState extends State<CameraExample> {
  static final CameraPosition _initialCarm = CameraPosition(
    target: LatLng(37.39348036043087, 127.11455031065394),
    zoom: 14,
  );
  File _image;
  final picker = ImagePicker();
  List _outputs;
//바텀 네비게이션바 이름
  int screenIndex = 0;
  List<Widget> screenList = [Text('홈스크린'), Text('채팅 스크린'), Text('마이 스크린')];

  Marker _origin;
  Marker _destination;

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  // 위치 관련!!!!!!

  Location location = Location();
  UserLocation mylocation = UserLocation();

  // Completer<GoogleMapController> _controller = Completer();

  GoogleMapController _controller;

  void _onMapCreated(GoogleMapController ctrl) async {
    setState(() {
      _controller = ctrl;
    });
    // 실시간 위치 추적 및 위치 정보 업데이트
    location.onLocationChanged.listen((userlocation) {
      mylocation.currentlocation = userlocation;
      mylocation.latitude = userlocation.latitude;
      mylocation.longitude = userlocation.longitude;
      // currentMarkerUpdate();
    });
  }

  // 버튼 클릭 시 현재 위치 정보 얻기
  void getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    try {
      mylocation.currentlocation = await location.getLocation();
    } catch (error) {
      print(error);
    }
  }

  void moveCameraPosition() async {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(mylocation.currentlocation.latitude,
              mylocation.currentlocation.longitude),
          zoom: 17,
        ),
      ),
    );
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/garbage_classification.tflite",
      labels: "assets/label.txt",
    ).then((value) {
      setState(() {
        //loading = false;
      });
    });
  }

  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    setState(() {
      _image = File(image.path);
    });
    await classifyImage(File(image.path));
  }

/*  Uint8List imageToByteListFloat32(
    img.Image image, int inputSize, double mean, double std) {
  var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
  var buffer = Float32List.view(convertedBytes.buffer);
  int pixelIndex = 0;
  for (var i = 0; i < inputSize; i++) {
    for (var j = 0; j < inputSize; j++) {
      var pixel = image.getPixel(j, i);
      buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
      buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
      buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
    }
  }
  return convertedBytes.buffer.asUint8List();
}
*/
  Future classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0,
      imageStd: 255.0,
      numResults: 9, // defaults to 5
      threshold: 0.3, // defaults to 0.1
    );
    setState(() {
      _outputs = output;
    });
  }

  Widget showImage() {
    return Container(
        color: const Color(0xffd0cece),
        margin: EdgeInsets.only(left: 95, right: 95),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Center(
            child: _image == null
                ? Text('No image selected.')
                : Image.file(File(_image.path))));
  }

  Widget showmap() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialCarm,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              onMapCreated: _onMapCreated,
              onLongPress: _addMarker,
              markers: {
                if (_origin != null) _origin,
                if (_destination != null) _destination
              },
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: InkWell(
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Color(0xff4B9B77),
                    borderRadius: BorderRadius.all(
                      Radius.circular(180.0),
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/location_icon.png",
                      width: 45,
                      height: 45,
                    ),
                  ),
                ),
                onTap: () {
                  getCurrentLocation();
                  // currentMarkerUpdate();
                  moveCameraPosition();
                },
              ),
            ),
          ],
        ));
  }

  Widget first_space() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (screenIndex == 0) SizedBox(height: 25.0),
        screenIndex == 0 ? showImage() : showmap(),
        if (screenIndex == 0) SizedBox(height: 50.0),
        if (screenIndex == 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // 카메라 촬영 버튼
              FloatingActionButton.extended(
                icon: Icon(Icons.add_a_photo),
                label: Text('pick Iamge'),
                tooltip: 'pick Iamge',
                onPressed: () async {
                  await getImage(ImageSource.camera);
                  recycleDialog();
                },
              ),

              // 갤러리에서 이미지를 가져오는 버튼
              FloatingActionButton.extended(
                icon: Icon(Icons.add_photo_alternate_outlined),
                label: Text('pick Iamge'),
                tooltip: 'pick Iamge',
                onPressed: () async {
                  await getImage(ImageSource.gallery);
                  recycleDialog();
                },
              ),
            ],
          )
      ],
    );
  }

  recycleDialog() {
    _outputs != null
        ? showDialog(
            context: context,
            barrierDismissible:
                false, // barrierDismissible - Dialog를 제외한 다른 화면 터치 x
            builder: (BuildContext context) {
              return AlertDialog(
                // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _outputs[0]['label'].toString().toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        background: Paint()..color = Colors.white,
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  Center(
                    child: new FlatButton(
                      child: new Text("Ok"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              );
            })
        : showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "데이터가 없거나 잘못된 이미지 입니다.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  Center(
                    child: new FlatButton(
                      child: new Text("Ok"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              );
            });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xfff4f3f9),
          body: first_space(),
          //바텀 네비게이션바
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: screenIndex,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.camera_alt), label: 'Trash'),
              BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.restore_from_trash), label: 'Adding')
            ],
            onTap: (value) {
              setState(() {
                screenIndex = value;
              });
            },
          )),
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        _destination = null;
      });
    } else {
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });
    }
  }
}
