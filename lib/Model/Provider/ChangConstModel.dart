import 'package:flutter/material.dart';


class ChangConstModel extends ChangeNotifier {
  String? selectedMajor;
  String? selectedSearch;
  List<bool> isSuperviser = [false];
  List<bool> setType() {
    isSuperviser[0] = !isSuperviser[0];
    notifyListeners();
    return isSuperviser;
  }

  String? setMajor(String select) {
    selectedMajor = select;
    notifyListeners();
    return selectedMajor;
  }

  String? setSearch(String select) {
    selectedSearch = select;
    notifyListeners();
    return selectedSearch;
  }
}
