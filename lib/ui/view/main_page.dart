import 'package:flutter/material.dart';
import 'package:mask_stock/model/store.dart';
import 'package:mask_stock/viewmodel/store_model.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Koin 이랑 비슷함
    // 매번 ViewModel 을 호출할 필요없이 Provider 를 이용하여 주입하면 됨
    final storeModel = Provider.of<StoreModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('마스크 재고 있는 곳 : ${storeModel.stores.where((e) {
          return e.remainStat == 'plenty' ||
              e.remainStat == 'some' ||
              e.remainStat == 'few';
        }).length}곳'),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                storeModel.fetch();
              })
        ],
      ),
      body: storeModel.isLoading
          ? loadingWidget()
          : ListView(
        children: storeModel.stores.where((e) {
          return e.remainStat == 'plenty' ||
              e.remainStat == 'some' ||
              e.remainStat == 'few';
        }).map((e) {
          return ListTile(
            title: Text(e.name),
            subtitle: Text(e.addr),
//            trailing: Text(e.remainStat ?? '매진'), // [elements ?? ''] => elements 의 값이 Null 일 때 ''로 교체,
            trailing: _buildRemainStatWidget(e),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRemainStatWidget(Store store) {
    var remainStat = '판매중지';
    var description = '판매중지';
    var color = Colors.black;

//    if (store.remainStat == 'plenty') {
//      remainStat = '충분';
//      description = '100개 이상';
//      color = Colors.green;
//    }
    switch (store.remainStat) {
      case 'plenty':
        remainStat = '충분';
        description = '100개 이상';
        color = Colors.green;
        break;
      case 'some':
        remainStat = '보통';
        description = '30 ~ 100개';
        color = Colors.yellow;
        break;
      case 'few':
        remainStat = '부족';
        description = '2 ~ 30개';
        color = Colors.red;
        break;
      case 'empty':
        remainStat = '소진임박';
        description = '1개 이하';
        color = Colors.grey;
        break;
      default:
    }

    return Column(
      children: [
        Text(
          remainStat,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        Text(description),
      ],
    );
  }

  Widget loadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('정보를 가져오는 중...'),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}