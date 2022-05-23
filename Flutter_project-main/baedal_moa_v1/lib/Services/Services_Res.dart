import 'dart:convert';

import 'package:baedal_moa/Model/Menu.dart';
import 'package:http/http.dart' as http;
import '../Model/Res.dart';

class Services_Res {
  static const String url = 'http://203.249.22.50:8080/reslist';

  static Future<List<Res>> getRests() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (200 == response.statusCode) {
        final List<Res> Res1 = resFromJson(response.body);
        for (int i = 0; i < Res1.length; i++) {
          print("가게 : " + Res1[i].resLocation);
        }
        return Res1;
      } else {
        print('Restaurant empty');
        return <Res>[]; // 빈 사용자 목록을 반환
      }
    } catch (e) {
      return <Res>[];
    }
  }

  // 안쓰임 레스토랑 아이디 전송
  static Future<void> postRest(String resId) async {
    try {
      String __url = 'http://203.249.22.50:8080/menu';
      final _url = Uri.parse(__url);
      print("선택한 가게 이름 : " + resId);
      http
          .post(_url, headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
          }, body: {
            "res_id": resId
          })
          .then((res) => print(json.decode(res.body)))
          .catchError((error) => print(error.toString()));
    } catch (error) {
      print('에러?? : ' + error.toString());
    }
  }
}
