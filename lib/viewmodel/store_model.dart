import 'package:flutter/foundation.dart';
import 'package:mask_stock/MyApplication.dart';
import 'package:mask_stock/model/store.dart';
import 'package:mask_stock/repo/store_repository.dart';
import 'package:provider/provider.dart';

class StoreModel with ChangeNotifier {
  var isLoading = false;
  List<Store> stores = [];
  MyApplication myApplication = MyApplication();

  // Dart 에서 _붙이면 Private 안붙이면 Public 임
  final _storeRepository = StoreRepository();

  StoreModel() {
    myApplication.logger.d("실행 됨?");
    fetch();
  }

  Future fetch() async {
    // isLoading 통지를 변경될 때 마다 notifyListeners 를 이용하여 해줘야
    isLoading = true;
    notifyListeners();

    stores = await _storeRepository.fetch();

    isLoading = false;
    notifyListeners();
  }

}