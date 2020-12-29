import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mask_stock/MyApplication.dart';
import 'package:mask_stock/model/store.dart';
import 'package:mask_stock/repo/location_repository.dart';
import 'package:mask_stock/repo/store_repository.dart';
import 'package:provider/provider.dart';

class StoreModel with ChangeNotifier {
  var isLoading = false;
  List<Store> stores = [];
  MyApplication myApplication = MyApplication();

  // Dart 에서 _붙이면 Private 안붙이면 Public 임
  final _storeRepository = StoreRepository();
  final _locationRepository = LocationRepository();

  StoreModel() {
    fetch();
  }

  Future fetch() async {
    // isLoading 통지를 변경될 때 마다 notifyListeners 를 이용하여 해줘야
    isLoading = true;
    notifyListeners();

    Position position = await _locationRepository.getCurrentLocation();

    stores = await _storeRepository.fetch(position.latitude, position.longitude);

    isLoading = false;
    notifyListeners();
  }
}
