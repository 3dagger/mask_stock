import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'package:mask_stock/model/store.dart';

class StoreRepository {
  final _distance = Distance();

  Future fetch(double lat, double lng) async {
    var stores = List<Store>();
    var url =
        'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json?lat=$lat&lng=$lng';

    // 매우 중요함
    // get 은 Future 를 Return 함
    // await 가 없으면 다음 코드가 수행될 보장이 없음
    // 그래서 await 키워드로 해당 get 이 끝날 때 까지 기다린 후 다음 코드를 진행 함 (결론은 await 함수는 Future 안에서만 사용 가능)
    // utf8.decode 사용하는 이유 => 한글 깨짐 처리하기 위해, 하지만 전체 데이터가 String 덩어리로 들어옴
    // 이를 해결하기위해 jsonDecode 메서드 사용 => json 형태로 Decode 해줘야 Model 클래스에 담을 수 있다

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResult = jsonDecode(utf8.decode(response.bodyBytes));

        final jsonStores = jsonResult['stores'];

        // 상태가 변경되었을때 화면을 다시 그려주는 역할 => setState()
        // 값이 담겨있으면 초기화 (새로고침 기능을 만들기 위해)
        jsonStores.forEach((e) {
          final store = Store.fromJson(e);
          final km = _distance.as(LengthUnit.Kilometer,
              LatLng(store.lat, store.lng), LatLng(lat, lng));
          store.km = km;
          stores.add(store);
        });
        return stores.where((e) {
          return e.remainStat == 'plenty' ||
              e.remainStat == 'some' ||
              e.remainStat == 'few';
        }).toList()
          ..sort((a, b) => b.km.compareTo(a.km));
        // List 에는 sort 기능이 있음, return 이 void 임 Sorting 한 결과를 받고싶으면 ..sort
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
