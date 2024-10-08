import 'package:flutter/foundation.dart';

class MyDataModel {
  final String count;

  MyDataModel({required this.count});
}


class MyDataProvider extends ChangeNotifier {
  MyDataModel _myData = MyDataModel(count: '');

  MyDataModel get myData => _myData;

  void updateCount(String newCount) {
    _myData = MyDataModel(count: newCount);
    notifyListeners();
  }
}

