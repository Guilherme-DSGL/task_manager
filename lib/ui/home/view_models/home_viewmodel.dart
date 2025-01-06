import 'package:flutter/foundation.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel();

  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  void setIndex(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
      notifyListeners();
    }
  }
}
