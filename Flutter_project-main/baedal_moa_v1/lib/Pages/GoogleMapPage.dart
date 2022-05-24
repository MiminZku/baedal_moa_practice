import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../Model/AppUser.dart';
import 'App.dart';

class GoogleMapPage extends StatefulWidget {
  // User user;
  late int userId;
  late String userNickname;
  GoogleMapPage({Key? key, required this.userId}) : super(key: key);

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  late List<Marker> myMarker = <Marker>[];
  late String locStr;
  late String curLoc;
  //x좌표
  double lat = 0.0;
  //y좌표
  double lon = 0.0;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  //현재 사용자의 위치 받아오기
  Future<void> getLocation() async {
    try {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((result) {
        print(result.toString());
        print("현재 사용자 위치 : " +
            result.latitude.toString() +
            ", " +
            result.longitude.toString());

        lat = result.latitude;
        lon = result.longitude;

        //현재 좌표를 마커(리스트)에 넣기
        setState(() {
          myMarker.add(
              Marker(markerId: MarkerId("first"), position: LatLng(lat, lon)));
        });
      });
      //좌표->주소로 변환
      _getAddress();
    } catch (error) {
      print("현재 사용자 위치 받아오기 에러 : " + error.toString());
    }
  }

  _getAddress() async {
    final placeMarks =
        await placemarkFromCoordinates(lat, lon, localeIdentifier: "ko_KR");
    setState(() {
      locStr = ("${placeMarks[0].street}");
      print("LocStr : " + locStr);
      curLoc = "${placeMarks[0].thoroughfare} ${placeMarks[0].subThoroughfare}";
    });
  }

//핑 찍은 곳을 마커에 추가
  _handleTap(LatLng tappedPoint) async {
    lat = tappedPoint.latitude;
    lon = tappedPoint.longitude;
    print("사용자가 마크한 좌표 : " + lat.toString() + ", " + lon.toString());
    _getAddress();
    // final placeMarks =
    //     await placemarkFromCoordinates(lat, lon, localeIdentifier: "ko_KR");
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
        markerId: MarkerId("first"),
        position: tappedPoint,
      ));
      // locStr = ("${placeMarks[0].street}");
      // print("LocStr : " + locStr);
      // curLoc = "${placeMarks[0].thoroughfare} ${placeMarks[0].subThoroughfare}";
    });
  }

//postPosition 실행
  _postaddress() {
    // print("서버에 전송한 좌표 : " + lat.toString() + ", " + lon.toString());
    postPosition(lat, lon);
  }

  //서버로 좌표 전송
  Future<void> postPosition(double lat, double lon) async {
    try {
      final _url = Uri.parse('http://203.249.22.50:8080/map');
      await http
          .post(_url, headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
          }, body: {
            "user_id": widget.userId.toString(),
            "latitude": lat.toString(),
            "longitude": lon.toString()
          })
          .then((res) => print(json.decode(res.body.toString())))
          .catchError((e) => print(e.toString()));
      print("서버에 전송한 좌표 : " + lat.toString() + ", " + lon.toString());
    } catch (error) {
      print('구글맵 좌표 전송 에러 : ' + error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('배달 모아')),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.deepOrange,
          titleTextStyle: TextStyle(
              color: Colors.white,
              letterSpacing: 3.0,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
          elevation: 1,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 3,
                            style: BorderStyle.solid,
                            color: Colors.deepOrange)),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.9,
                    child: myMarker.isEmpty
                        ? Center(child: Text("loading map..."))
                        : GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: myMarker[0].position, zoom: 18.0),
                            markers: Set.from(myMarker),
                            onTap: _handleTap,
                          ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 30, left: 30, right: 30),
                alignment: Alignment.center,
                child: Text(
                  myMarker.isEmpty ? "loading map..." : locStr,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                width: 230,
                child: CupertinoButton(
                  child: Text(
                    '이 위치로 설정하기',
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  color: Colors.deepOrange,
                  onPressed: () => {
                    if (curLoc.isNotEmpty)
                      {
                        _postaddress(),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  App(userId: widget.userId, curLoc: curLoc),
                            ))
                      }
                  },
                ),
              )
            ],
          ),
        ));
  }
}
