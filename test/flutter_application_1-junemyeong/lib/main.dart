// @dart=2.9
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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
  const CameraExample({ Key key }) : super(key: key);
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
  
  
   void _onMapCreated(GoogleMapController controller) async {
    GoogleMapController _googleMapController;
    _googleMapController=controller;
  }

  loadModel() async {
    await Tflite.loadModel(
      model:  "assets/garbage_classification.tflite",
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
    return 
     

      Container(
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
    return 
      Container(
        color: const Color(0xffd0cece),
        
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: 
        GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: _initialCarm,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  onMapCreated: _onMapCreated,
                  onLongPress: _addMarker,
          ));
  }
  Widget first_space() {
    return 
         Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  screenIndex == 0   
                  ? 'deeplearning'
                  : 'map',
                  style: TextStyle(fontSize: 25, color: const Color(0xff1ea271)),
                ),
                SizedBox(height: 25.0),
                screenIndex == 0   
                  ?  showImage()
                  : showmap(),
               
                SizedBox(
                  height: 50.0,
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // 카메라 촬영 버튼
                    FloatingActionButton(
                      child: Icon(Icons.add_a_photo),
                      tooltip: 'pick Iamge',
                      onPressed: () async {
                        await getImage(ImageSource.camera);
                        recycleDialog();
                      },
                    ),

                    // 갤러리에서 이미지를 가져오는 버튼
                    FloatingActionButton(
                      child: Icon(Icons.wallpaper),
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
   
    return Scaffold(
        backgroundColor: const Color(0xfff4f3f9),
       
        body: 
        first_space(),
    //바텀 네비게이션바
    bottomNavigationBar: BottomNavigationBar(
          currentIndex: screenIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.restore_from_trash), label: 'chat'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'my')
          ],
          onTap: (value) {
            setState(() { 
              screenIndex = value;
            }
            
            );
          },
        )
    );
    
    
  }
  
  
  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
   void _addMarker(LatLng pos) async{
    if (_origin == null || (_origin != null&& _destination != null)){
      setState((){
        _origin = Marker(
        markerId: const MarkerId('origin'),
        infoWindow : const InfoWindow(title:'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: pos,
        );
        _destination = null;

      });
    } else{
      setState((){
        _destination = Marker(
        markerId: const MarkerId('destination'),
        infoWindow : const InfoWindow(title:'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: pos,
        );
      });

  }
}

}