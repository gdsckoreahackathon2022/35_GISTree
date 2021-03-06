// @dart=2.9
import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui';
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_application_1/location.dart';
import 'package:flutter_application_1/trashcan_location.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;

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
    target: LatLng(37.5276, 127.0406),
    zoom: 14,
  );
  File _image;
  final picker = ImagePicker();
  List _outputs;
//바텀 네비게이션바 이름
  int screenIndex = 1;
  List<Widget> screenList = [Text('홈스크린'), Text('채팅 스크린'), Text('마이 스크린')];

  Marker _origin;
  Marker _destination;

  BitmapDescriptor myIcon;

  var product = -1;
  var carmera_id = 0;
  void changing_screen(point) {
    if (point == 8 || point == 7) {
      trashcanMarkerUpdate(normaltrashcanInfo);
      currentTrashType = "normal";
    }
    if (point == 3 || point == 4 || point == 5 || point == 6) {
      trashcanMarkerUpdate(recycletrashcanInfo);
      currentTrashType = "recycle";
    }
    if (point == 1) {
      trashcanMarkerUpdate(foodtrashcanInfo);
      currentTrashType = "food";
    }
    if (point == 0) {
      trashcanMarkerUpdate(batterytrashcanInfo);
      currentTrashType = "battery";
    }
    if (point == 2) {
      trashcanMarkerUpdate(clothtrashcanInfo);
      currentTrashType = "cloth";
    }
    screenIndex = 1;
    carmera_id = 0;
  }

  void changing_screen2(point) {
    screenIndex = 1;
    carmera_id = 0;
  }

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
    setCustomIcon();
  }

  void setCustomIcon() async {
    myIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 4), "assets/myicon.png");
  }

  // 위치 관련!!!!!!

  Location location = Location();
  UserLocation mylocation = UserLocation();

  GoogleMapController _controller;

  void _onMapCreated(GoogleMapController ctrl) async {
    setState(() {
      _controller = ctrl;
    });

    if (currentTrashType == "") {
      trashcanMarkerUpdate(normaltrashcanInfo);
    } else if (currentTrashType == "recycle") {
      trashcanMarkerUpdate(recycletrashcanInfo);
    } else if (currentTrashType == "food") {
      trashcanMarkerUpdate(foodtrashcanInfo);
    } else if (currentTrashType == "battery") {
      trashcanMarkerUpdate(batterytrashcanInfo);
    } else if (currentTrashType == "cloth") {
      trashcanMarkerUpdate(clothtrashcanInfo);
    } else {
      trashcanMarkerUpdate(normaltrashcanInfo);
    }

    // 실시간 위치 추적 및 위치 정보 업데이트
    location.onLocationChanged.listen((userlocation) {
      mylocation.currentlocation = userlocation;
      mylocation.latitude = userlocation.latitude;
      mylocation.longitude = userlocation.longitude;
      currentMarkerUpdate();
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

  // 마커 관련!!!!

  Set<Marker> marker = {};
  Marker mymarker = Marker(markerId: MarkerId("current"));
  List<Marker> trashmarker = [];

  // 사용자가 마커 추가할 때 사용
  String currentTrashType = "";

  // 현재 위치 마커
  void currentMarkerUpdate() {
    setState(() {
      mymarker = Marker(
        markerId: const MarkerId("current"),
        draggable: false,
        onTap: () {},
        position: LatLng(mylocation.currentlocation.latitude,
            mylocation.currentlocation.longitude),
        icon: myIcon,
      );
    });
    sumMarker();
  }

  void sumMarker() {
    setState(() {
      marker = {};
      marker.add(mymarker);
      marker.addAll(trashmarker);
    });
  }

  void trashcanMarkerUpdate(List<Marker> trashcan) {
    setState(() {
      trashmarker = [];
      trashmarker = trashcan;
    });
    sumMarker();
  }

  // 쓰레기 분류 관련!!!!!!!!!!

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

  Future<bool> getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    } else {
      return false;
    }

    await classifyImage(File(image.path));
    return true;
  }

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
        margin: EdgeInsets.only(left: 25, right: 25),
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
        height: MediaQuery.of(context).size.height - 94,
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialCarm,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              onMapCreated: _onMapCreated,
              onLongPress: checkAddMarker,
              markers: marker,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox.fromSize(size: Size(2, 15)),
                SizedBox.fromSize(
                  size: Size(MediaQuery.of(context).size.width - 30, 50),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Trash Fresh ",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black)),
                            Text(
                              ' beta',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.black),
                            ) // <-- Text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox.fromSize(size: Size(10, 5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox.fromSize(size: Size(10, 10)),
                    SizedBox.fromSize(
                      size: Size(55, 30),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Material(
                          color: Colors.yellow[700],
                          child: InkWell(
                            onTap: () {
                              trashcanMarkerUpdate(normaltrashcanInfo);
                              currentTrashType = "normal";
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.miscellaneous_services,
                                    size: 13, color: Colors.white), // <-- Icon
                                Text("일반",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white)), // <-- Text
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox.fromSize(
                      size: Size(65, 30),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Material(
                          color: Colors.green[400],
                          child: InkWell(
                            onTap: () {
                              trashcanMarkerUpdate(recycletrashcanInfo);
                              currentTrashType = "recycle";
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.eco_outlined,
                                    size: 13, color: Colors.white), // <-- Icon
                                Text(
                                  "재활용",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                ), // <-- Text
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox.fromSize(
                      size: Size(65, 30),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Material(
                          color: Colors.blue[600],
                          child: InkWell(
                            splashColor: Colors.green,
                            onTap: () {
                              trashcanMarkerUpdate(foodtrashcanInfo);
                              currentTrashType = "food";
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.invert_colors,
                                    size: 13, color: Colors.white), // <-- Icon
                                Text(
                                  "음식물",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                ), // <-- Text
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox.fromSize(
                      size: Size(65, 30),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Material(
                          color: Colors.red[500],
                          child: InkWell(
                            onTap: () {
                              trashcanMarkerUpdate(batterytrashcanInfo);
                              currentTrashType = "battery";
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.battery_std_sharp,
                                    size: 13, color: Colors.white), // <-- Icon
                                Text(
                                  "건전지",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                ), // <-- Text
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox.fromSize(
                      size: Size(55, 30),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Material(
                          color: Colors.green[700],
                          child: InkWell(
                            onTap: () {
                              trashcanMarkerUpdate(clothtrashcanInfo);
                              currentTrashType = "cloth";
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.local_mall_sharp,
                                    size: 13, color: Colors.white), // <-- Icon
                                Text(
                                  "의류",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                ), // <-- Text
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox.fromSize(
                        size: Size(MediaQuery.of(context).size.width - 330, 1)),
                  ],
                )
              ],
            ),
            Positioned(
              left: 20,
              bottom: 20,
              child: InkWell(
                child: Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    color: Color(0xffff0f0f0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(180.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/location_icon.png",
                      height: 35,
                      width: 35,
                    ),
                  ),
                ),
                onTap: () {
                  getCurrentLocation();
                  currentMarkerUpdate();
                  moveCameraPosition();
                },
              ),
            ),
          ],
        ));
  }

  Widget first_space() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (screenIndex == 0) SizedBox(height: 25.0),
        screenIndex == 0 ? showImage() : showmap(),
        if (screenIndex == 0) SizedBox(height: 50.0),
        if (screenIndex == 0)
          if (carmera_id == 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox.fromSize(size: Size(10, 1)),
                // 카메라 촬영 버튼
                FloatingActionButton.extended(
                  backgroundColor: Color(0xfff4B9B9B),
                  icon: Icon(Icons.camera, size: 15),
                  label: Text('카메라',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                      )),
                  tooltip: 'pick Iamge',
                  onPressed: () async {
                    carmera_id = 1;
                    bool checkCamera = await getImage(ImageSource.camera);
                    if (checkCamera) {
                      recycleDialog();
                    }
                  },
                ),
                SizedBox.fromSize(size: Size(5, 1)),
                // 갤러리에서 이미지를 가져오는 버튼
                FloatingActionButton.extended(
                  backgroundColor: Color(0xfff4B9B9B),
                  icon: Icon(Icons.add_photo_alternate_outlined, size: 15),
                  label: Text('갤러리',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                      )),
                  tooltip: 'pick Iamge',
                  onPressed: () async {
                    carmera_id = 1;
                    bool checkGallery = await getImage(ImageSource.gallery);
                    if (checkGallery) {
                      recycleDialog();
                    }
                  },
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton.extended(
                  backgroundColor: Color(0xfff4B9B9B),
                  icon: Icon(Icons.map, size: 15),
                  label: Text('지도로 돌아가기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                      )),
                  tooltip: 'pick Iamge',
                  onPressed: () {
                    changing_screen(product);
                  },
                ),
                FloatingActionButton.extended(
                  backgroundColor: Color(0xfff4B9B9B),
                  label: Text('쓰레기통 찾기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                      )),
                  tooltip: 'pick Iamge',
                  onPressed: () {
                    changing_screen(product);
                  },
                ),
              ],
            )
      ],
    );
  }

  recycleDialog() {
    if (_outputs[0]['label'].toString() == "0 battery") product = 1;
    if (_outputs[0]['label'].toString() == "1 biological") product = 2;
    if (_outputs[0]['label'].toString() == "2 clothes") product = 3;
    if (_outputs[0]['label'].toString() == "3 glass") product = 4;
    if (_outputs[0]['label'].toString() == "4 metal") product = 5;
    if (_outputs[0]['label'].toString() == "5 paper") product = 6;
    if (_outputs[0]['label'].toString() == "6 plastic") product = 7;
    if (_outputs[0]['label'].toString() == "7 trash") product = 8;
    if (_outputs[0]['label'].toString() == "8 vinyl") product = 9;
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
                    if (_outputs[0]['label'].toString() == "0 battery")
                      Text(
                        "베터리(battery)",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          background: Paint()..color = Colors.white,
                        ),
                      )
                    else if (_outputs[0]['label'].toString() == "1 biological")
                      Text(
                        "음식물(biological)",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          background: Paint()..color = Colors.white,
                        ),
                      )
                    else if (_outputs[0]['label'].toString() == "2 clothes")
                      Text(
                        "의류(clothes)",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          background: Paint()..color = Colors.white,
                        ),
                      )
                    else if (_outputs[0]['label'].toString() == "3 glass")
                      Text(
                        "병류(glass)",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          background: Paint()..color = Colors.white,
                        ),
                      )
                    else if (_outputs[0]['label'].toString() == "4 metal")
                      Text(
                        "캔류(metal)",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          background: Paint()..color = Colors.white,
                        ),
                      )
                    else if (_outputs[0]['label'].toString() == "5 paper")
                      Text(
                        "종이류(paper)",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          background: Paint()..color = Colors.white,
                        ),
                      )
                    else if (_outputs[0]['label'].toString() == "6 plastic")
                      Text(
                        "플라스틱(plastic)",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          background: Paint()..color = Colors.white,
                        ),
                      )
                    else if (_outputs[0]['label'].toString() == "7 trash")
                      Text(
                        "일반(trash)",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          background: Paint()..color = Colors.white,
                        ),
                      )
                    else if (_outputs[0]['label'].toString() == "8 vinyl")
                      Text(
                        "비닐류(vinyl)",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          background: Paint()..color = Colors.white,
                        ),
                      )
                    else
                      Text(
                        "error",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          background: Paint()..color = Colors.white,
                        ),
                      )
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
          bottomNavigationBar: Container(
            height: 70,
            child: BottomNavigationBar(
              backgroundColor: Color(0xff4B9B77),
              currentIndex: screenIndex,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(.70),
              selectedFontSize: 14,
              unselectedFontSize: 14,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.camera_alt), label: 'Trash'),
                BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.book), label: 'My Page')
              ],
              onTap: (value) {
                setState(() {
                  screenIndex = value;
                });
              },
            ),
          )),
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  void checkAddMarker(LatLng pos) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Text("해당 위치에 쓰레기통을 추가할겨?"),
            actions: [
              TextButton(
                  onPressed: () {
                    addMarker(pos);
                    Navigator.pop(context);
                  },
                  child: Text("네")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("아뇨? 뚱인데요?")),
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        });
  }

  void addMarker(LatLng pos) {
    if (currentTrashType == "normal") {
      setState(() {
        normaltrashcanInfo.add(
          Marker(
            markerId: MarkerId(normalcount.toString()),
            icon: normalicon,
            position: pos,
            onTap: () {},
          ),
        );
      });
      normalcount++;
      trashcanMarkerUpdate(normaltrashcanInfo);
    } else if (currentTrashType == "recycle") {
      setState(() {
        recycletrashcanInfo.add(
          Marker(
            markerId: MarkerId(recyclecount.toString()),
            icon: recycleicon,
            position: pos,
            onTap: () {},
          ),
        );
      });
      recyclecount++;
      trashcanMarkerUpdate(recycletrashcanInfo);
    } else if (currentTrashType == "food") {
      setState(() {
        foodtrashcanInfo.add(
          Marker(
            markerId: MarkerId(foodcount.toString()),
            icon: foodicon,
            position: pos,
            onTap: () {},
          ),
        );
      });
      foodcount++;
      trashcanMarkerUpdate(foodtrashcanInfo);
    } else if (currentTrashType == "battery") {
      setState(() {
        batterytrashcanInfo.add(
          Marker(
            markerId: MarkerId(batterycount.toString()),
            icon: batteryicon,
            position: pos,
            onTap: () {},
          ),
        );
      });
      batterycount++;
      trashcanMarkerUpdate(batterytrashcanInfo);
    } else if (currentTrashType == "cloth") {
      setState(() {
        clothtrashcanInfo.add(
          Marker(
            markerId: MarkerId(clothcount.toString()),
            icon: clothicon,
            position: pos,
            onTap: () {},
          ),
        );
      });
      clothcount++;
      trashcanMarkerUpdate(clothtrashcanInfo);
    }
  }
}
